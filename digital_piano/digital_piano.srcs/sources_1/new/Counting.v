`timescale 1ns / 1ps
`include "constants.vh"
//cdone

module Counting(
    input clk,
    input enable,
    output reg[`OUTPUTCOUNT_WIDTH -1:0] outputCount
    );
    always @(posedge clk)begin
        if(!enable) begin
            outputCount <= `OUTPUTCOUNT_INIT_VALUE; //not sure
        end
        else begin
            outputCount <= outputCount + `OUTPUT_INCR;
        end
    end
endmodule
 
