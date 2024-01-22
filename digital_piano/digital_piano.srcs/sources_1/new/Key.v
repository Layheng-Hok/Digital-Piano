`timescale 1ns / 1ps
`include "constants.vh"

module Key(
    input wire clk,
    input wire rst_n,
    input wire key_note,
    output reg key_on_out,
    output reg key_off_out
    );

    reg [`STATE_WIDTH -1:0] state;
    wire pos_edge;  // record edge value for switching status
    wire neg_edge;
    reg key_sig1, key_sig2, key_sig3;  // edge change is asynchronous signal
    reg counter_en;
    reg [`KEY_COUNTER_WIDTH -1:0] counter;  // for clock delay

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
            counter <= `KEY_COUNTER_INIT_STATE;
        else if (counter_en)
            counter <= counter + `KEY_COUNTER_INIT_STATE +1;
        else
            counter <= `KEY_COUNTER_INIT_STATE;
    end

    // state machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= `IDLE_KEY;
            counter_en <= 1'b0;
            key_on_out <= 1'b0;
            key_off_out <= 1'b0;
        end
        else begin
            case (state)
                `IDLE_KEY:
                    begin
                        key_on_out <= 1'b0;
                        key_off_out <= 1'b0;
                        if (neg_edge) begin
                            counter_en <= 1'b1;
                            state <= `FILTER0_KEY;
                        end
                        else
                            state <= `IDLE_KEY;
                    end
                `FILTER0_KEY:
                    begin
                        if (counter == `MAX_COUNT) begin
                            key_on_out <= 1'b1;
                            counter_en <= 1'b0;
                            state <= `DOWN_KEY;
                        end
                        else if (pos_edge) begin
                            counter_en <= 1'b0;
                            state <= `IDLE_KEY;
                        end
                        else
                            state <= `FILTER0_KEY;
                    end
                `DOWN_KEY:
                    begin
                        key_on_out <= 1'b0; // output one clock pulse, change later
                        if (pos_edge) begin
                            counter_en <= 1'b1;
                            state <= `FILTER1_KEY;      
                        end
                        else
                            state <= `DOWN_KEY;
                    end
                `FILTER1_KEY:
                    begin
                        if (counter == `MAX_COUNT) begin
                            key_off_out <= 1'b1;
                            counter_en <= 1'b0;
                            state <= `IDLE_KEY;
                        end
                        else if (neg_edge) begin
                            counter_en <= 1'b0;
                            state <= `DOWN_KEY;
                        end
                        else
                            state <= `FILTER1_KEY;
                    end
                default:
                    begin
                        state <= `IDLE_KEY;
                        counter_en <= 1'b0;
                        key_on_out <= 1'b0;
                        key_off_out <= 1'b0;
                    end
            endcase
        end
    end
    
endmodule
