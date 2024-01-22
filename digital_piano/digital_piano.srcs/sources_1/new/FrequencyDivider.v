`timescale 1ns / 1ps
`include "constants.vh"
//cdone

module FrequencyDivider(
    input clk,
    input rst_n,
    output reg slow_clk
    );
    reg [`FREQUENCY_DIVIDER_COUNT -1:0] counter;
    always @(posedge clk, negedge rst_n) begin
        if(~rst_n)begin
            slow_clk<= `SLOW_CLK_INIT_VALUE;
            counter <= `COUNTER_INIT_VALUE;
        end
        else begin
            counter <= counter + 1;
            if (counter == `FREQUENCY_DIVIDER)
                begin
                    counter <= `COUNTER_INIT_VALUE;
                    slow_clk <= ~slow_clk;
                end
        end
    
    end
endmodule
