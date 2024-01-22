`timescale 1ns / 1ps
`include "constants.vh"

module ReactionRating(
    input clk,
    input rst_n,
    input [`STATE_REACTION_RATING_WIDTH -1:0] state,
	output reg[`REACTION_RATE_WIDTH -1:0] reaction_rate
    );
    
    reg[`OUTPUTCOUNT_WIDTH -1:0] count_diff1;
    reg[`OUTPUTCOUNT_WIDTH -1:0] count_diff2;
    reg[`OUTPUTCOUNT_WIDTH -1:0] count1;
    reg[`OUTPUTCOUNT_WIDTH -1:0] count2;
    
    // state machine logic
  always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                count1 <= 0;
                count2 <= 0;
                reaction_rate <= 0;
            end
            else begin
                case (state)
                    2'd0:
                        begin
                            if (count1 <= `COUNT1)
                                count1 <= count1 + 32'd1;
                            reaction_rate <= 8'd0;
                            count2 <= 32'd0;
                        end
                    2'd1:
                        begin 
                            if (count2 <= `COUNT2)
                                count2 <= count2 + 32'd1;
                        end
                    2'd2:
                        if (count_diff1 + count_diff2 <= `COUNT_DIFF_12_1)
                            reaction_rate <= 8'b11111111;
                        else if (count_diff1 + count_diff2 <= `COUNT_DIFF_12_2)
                            reaction_rate <= 8'b01111111;
                        else if (count_diff1 + count_diff2 <= `COUNT_DIFF_12_3)
                            reaction_rate <= 8'b00111111;
                        else if (count_diff1 + count_diff2 <= `COUNT_DIFF_12_4)
                            reaction_rate <= 8'b00011111;
                        else if (count_diff1 + count_diff2 <= `COUNT_DIFF_12_5)
                            reaction_rate <= 8'b00001111;
                        else if (count_diff1 + count_diff2 <= `COUNT_DIFF_12_6)
                            reaction_rate <= 8'b00000111;
                        else if (count_diff1 + count_diff2 <= `COUNT_DIFF_12_7)
                            reaction_rate <= 8'b00000011;
                        else
                            reaction_rate <= 8'b00000001;
                    2'd3:
                        begin
                            count1 <= 32'd0;
                            count2 <= 32'd0;
                        end
                endcase
            end
        end
    
        // count difference calculation
        always @(*) begin
            count_diff1 = count1;
            if (count2 > `COUNT2_GREATER)
                count_diff2 = count2 - 32'd20000000;
            else
                count_diff2 = 32'd20000000 - count2;
        end
    
    endmodule
