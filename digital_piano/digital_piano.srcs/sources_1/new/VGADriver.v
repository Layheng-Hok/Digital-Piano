`timescale 1ns / 1ps
`include "constants.vh" 

/*
    the module takes pixel data as input and generates the necessary signals to display this data on a VGA screen
    it handles the timing and synchronization of the VGA signals, and generates the coordinates for each pixel on
    the screen
*/

module VGADriver(
    input wire vga_clk,          // VGA clock input
    input wire rst_n,            // system reset signal (active low)
    input wire [`PIX_DATA_WIDTH -1:0] pix_data,  // pixel data input
    output wire [`PIX_X_WIDTH -1:0] pix_x,    // pixel X coordinate output
    output wire [`PIX_Y_WIDTH -1:0] pix_y,    // pixel Y coordinate output
    output wire hsync,          // horizontal sync signal output
    output wire vsync,          // vertical sync signal output
    output wire [`VGA_RGB_WIDTH -1:0] vga_rgb  // VGA RGB data output
);

    // horizontal and vertical counters
    reg [`COUNTER_H_WIDTH -1:0] counter_h;
    reg [`COUNTER_V_WIDTH -1:0] counter_v;

    // RGB valid and pixel data request signals
    wire rgb_valid;     // output pix_data to VGA when rgb_valid is high (1'b1)
    wire pix_data_req;  // request new pix_data when pix_data_req is high (1'b1) 

    // horizontal counter logic
    always @(posedge vga_clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            counter_h <= 10'd0;  
        end
        else if (counter_h == (`H_TOTAL - 1'b1)) begin
            counter_h <= 10'd0;  // reset counter at end of line
        end
        else begin
            counter_h <= counter_h + 10'd1;  
        end
    end

    // vertical counter logic
    always @(posedge vga_clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            counter_v <= 10'd0; 
        end
        else if ((counter_h == (`H_TOTAL - 1'b1)) && (counter_v == (`V_TOTAL - 1'b1))) begin
            counter_v <= 10'd0;  // reset counter at end of frame
        end
        else if (counter_h == (`H_TOTAL - 1'b1)) begin
            counter_v <= counter_v + 10'd1;  // increment counter at the end of line
        end
        else begin
            counter_v <= counter_v; // hold the counter
        end
    end

    // RGB valid signal logic
    assign rgb_valid = ((counter_h >= `H_SYNC + `H_BACK + `H_LEFT)
                        && (counter_h < `H_SYNC + `H_BACK + `H_LEFT + `H_VALID)
                        && (counter_v >= `V_SYNC + `V_BACK + `V_TOP)
                        && (counter_v < `V_SYNC + `V_BACK + `V_TOP + `V_VALID))
                        ?  1'b1 : 1'b0;  // RGB valid during addresable video

    // pixel data request signal logic
    assign pix_data_req = ((counter_h >= `H_SYNC + `H_BACK + `H_LEFT - 1'b1)
                        && (counter_h < `H_SYNC + `H_BACK + `H_LEFT + `H_VALID - 1'b1)
                        && (counter_v >= `V_SYNC + `V_BACK + `V_TOP)
                        && (counter_v < `V_SYNC + `V_BACK + `V_TOP + `V_VALID))
                        ?  1'b1 : 1'b0;  // pixel data request during addressable video

    // pixel X and Y coordinate logic
    assign pix_x = (pix_data_req == 1'b1) ? (counter_h - (`H_SYNC + `H_BACK + `H_LEFT) - 1'b1) : 10'd0;
    assign pix_y = (pix_data_req == 1'b1) ? (counter_v - (`V_SYNC + `V_BACK + `V_TOP)) : 10'd0;

    // sync signal logic
    assign hsync = (counter_h <= `H_SYNC - 1'b1) ? 1'b1 : 1'b0;  // HSYNC during sync pulse
    assign vsync = (counter_v <= `V_SYNC - 1'b1) ? 1'b1 : 1'b0;  // VSYNC during sync pulse

    // VGA RGB data logic
    assign vga_rgb = (rgb_valid == 1'b1) ? pix_data : 12'h000;  // output pixel data when RGB valid

endmodule

