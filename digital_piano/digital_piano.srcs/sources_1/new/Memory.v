`timescale 1ns / 1ps

module Memory(
input clk, 
input [6:0] notes_in,
input write_enable, 
input [2:0] address,
output reg [6:0] notes_out
);

    reg [6:0] mem [0:255]; 
    always@(posedge clk) begin
         if (write_enable) 
               mem[address] <=  notes_in;
         else
               notes_out <= mem[address];
         end

endmodule
