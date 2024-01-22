`timescale 1ns / 1ps
`include "constants.vh"

module VGADisplay(
    input wire clk,
    input wire sys_rst_n,
    input wire [`MODE_WIDTH -1:0] mode,
    input wire key_on_in,
    input wire key_off_in,
    input wire [`NOTE_IN_WIDTH -1:0] note_in,
    input wire [`SELECTED_NOTE_WIDTH -1:0] selected_note,
    input wire [`TRACK_NUM_AUTO_WIDTH -1:0]  track_number_auto,
    input wire [`TRACK_NUM_LEARNING_WIDTH -1:0] track_number_learning,
    input wire [`CURRENT_OCTAVE_WIDTH -1:0] current_octave,
    input wire [`REACTION_RATE_WIDTH -1:0] reaction_rate,
    input wire finish,
    output wire hsync,
    output wire vsync,
    output wire [`VGA_RGB_WIDTH -1:0] vga_rgb
);
//clock and reset signals
    wire vga_clk;
    wire locked;
    wire rst_n;
//pixel-related signals
    wire [`PIX_X_WIDTH -1:0] pix_x;
    wire [`PIX_Y_WIDTH -1:0] pix_y;
    wire [`PIX_DATA_WIDTH -1:0] pix_data;

    assign rst_n = (sys_rst_n && locked);

    clk_wiz_0 clk_25
    (
        .clk_in1(clk),
        .reset(~sys_rst_n),
        .clk_out1(vga_clk),
        .locked(locked)
    );

    PixelMapper pixel_mapper
    (
        .clk(clk),
        .vga_clk(vga_clk),
        .rst_n(rst_n),
        .pix_x(pix_x),
        .pix_y(pix_y),
        .pix_data(pix_data),
        .mode(mode),
        .key_on_in(key_on_in),
        .key_off_in(key_off_in),
        .note_in(note_in),
        .selected_note(selected_note),
        .track_number_auto(track_number_auto),
        .track_number_learning(track_number_learning), 
        .current_octave(current_octave),
        .reaction_rate(reaction_rate),
        .finish(finish)
    );

    VGADriver vga_driver
    (
        .vga_clk(vga_clk),
        .rst_n(rst_n),
        .pix_data(pix_data) ,
        .pix_x(pix_x),
        .pix_y(pix_y),
        .hsync(hsync),
        .vsync(vsync),
        .vga_rgb(vga_rgb)
    );

endmodule
