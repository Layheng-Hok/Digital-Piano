`timescale 1ns / 1ps
`define MAX_COUNT 1_000_000 - 1 // 20ms / 20ns - 1, change to 10 for simulation
//`define MAX_COUNT 10

module Key(
    input wire clk,
    input wire rst_n,
    input wire key_note,
    output reg key_on_out,
    output reg key_off_out
    );

    localparam IDLE = 2'b00, FILTER0 = 2'b01, DOWN = 2'b10, FILTER1 = 2'b11;

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
            key_on_out <= 1'b0;
            key_off_out <= 1'b0;
        end
        else begin
            case (state)
                IDLE:
                    begin
                        key_on_out <= 1'b0;
                        key_off_out <= 1'b0;
                        if (neg_edge) begin
                            counter_en <= 1'b1;
                            state <= FILTER0;
                        end
                        else
                            state <= IDLE;
                    end
                FILTER0:
                    begin
                        if (counter == `MAX_COUNT) begin
                            key_on_out <= 1'b1;
                            counter_en <= 1'b0;
                            state <= DOWN;
                        end
                        else if (pos_edge) begin
                            counter_en <= 1'b0;
                            state <= IDLE;
                        end
                        else
                            state <= FILTER0;
                    end
                DOWN:
                    begin
                        key_on_out <= 1'b0; // output one clock pulse, change later
                        if (pos_edge) begin
                            counter_en <= 1'b1;
                            state <= FILTER1;      
                        end
                        else
                            state <= DOWN;
                    end
                FILTER1:
                    begin
                        if (counter == `MAX_COUNT) begin
                            key_off_out <= 1'b1;
                            counter_en <= 1'b0;
                            state <= IDLE;
                        end
                        else if (neg_edge) begin
                            counter_en <= 1'b0;
                            state <= DOWN;
                        end
                        else
                            state <= FILTER1;
                    end
                default:
                    begin
                        state <= IDLE;
                        counter_en <= 1'b0;
                        key_on_out <= 1'b0;
                        key_off_out <= 1'b0;
                    end
            endcase
        end
    end
    
endmodule
