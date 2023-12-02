`timescale 1ns / 1ps
`define MAX_COUNT 10

module Key(
    input wire clk,
    input wire rst_n,
    input wire key_note,
    output reg key_on,
    output reg key_off
    );

    localparam IDLE = 2'b00, PRESS = 2'b01, PRESSED = 2'b10, RELEASE = 2'b11;

    reg [1:0] state;
    wire pos_edge;  // record edge value for switching status
    wire neg_edge;
    reg key_sig1, key_sig2, key_sig3;  // edge change is asynchronous signal
    reg counter_en;
    reg [31:0] counter;  // for clock delay

    // synchronize key signal with the clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            key_sig1 <= 1'b0;
            key_sig2 <= 1'b0;
            key_sig3 <= 1'b0;
        end
        else begin
            key_sig1 <= key_note;
            key_sig2 <= key_sig1;
            key_sig3 <= key_sig2;
        end
    end

    assign pos_edge = key_sig2 & (!key_sig3);
    assign neg_edge = (!key_sig2) & key_sig3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            counter <= 32'd0;
        else if (counter_en)
            counter <= counter + 32'd1;
        else
            counter <= 32'd0;
    end

    // state machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            counter_en <= 1'b0;
            key_on <= 1'b0;
            key_off <= 1'b0;
        end
        else begin
            case (state)
                IDLE:
                    begin
                        key_on <= 1'b0;
                        key_off <= 1'b0;
                        if (neg_edge) begin
                            counter_en <= 1'b1;
                            state <= PRESS;
                        end
                        else
                            state <= IDLE;
                    end
                PRESS:
                    begin
                        if (counter == `MAX_COUNT) begin
                            key_on <= 1'b1;
                            counter_en <= 1'b0;
                            state <= PRESSED;
                        end
                        else if (pos_edge) begin
                            counter_en <= 1'b0;
                            state <= IDLE;
                        end
                        else
                            state <= PRESS;
                    end
                PRESSED:
                    begin
                        key_on <= 1'b0; // output one clock pulse, change later
                        if (pos_edge) begin
                            counter_en <= 1'b1;
                            state <= RELEASE;      
                        end
                        else
                            state <= PRESSED;
                    end
                RELEASE:
                    begin
                        if (counter == `MAX_COUNT) begin
                            key_off <= 1'b1;
                            counter_en <= 1'b0;
                            state <= IDLE;
                        end
                        else if (neg_edge) begin
                            counter_en <= 1'b0;
                            state <= PRESSED;
                        end
                        else
                            state <= RELEASE;
                    end
                default:
                    begin
                        state <= IDLE;
                        counter_en <= 1'b0;
                        key_on <= 1'b0;
                        key_off <= 1'b0;
                    end
            endcase
        end
    end
    
endmodule
