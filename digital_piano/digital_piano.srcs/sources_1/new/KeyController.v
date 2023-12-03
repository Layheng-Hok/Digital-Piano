`timescale 1ns / 1ps

module KeyController(
    input wire clk,
    input wire rst_n,
    input wire [6:0] key_notes,
    output wire key_on_out,
    output wire key_off_out,
    output reg [3:0] note_out
    );

    wire [6:0] key_on;
    wire [6:0] key_off;

    // instantiate each key note
    Key key_note_1 (
        .clk(clk),
        .rst_n(rst_n),
        .key_note(key_notes[0]),
        .key_on_out(key_on[0]),
        .key_off_out(key_off[0])
    );

    Key key_note_2 (
        .clk(clk),
        .rst_n(rst_n),
        .key_note(key_notes[1]),
        .key_on_out(key_on[1]),
        .key_off_out(key_off[1])
    );

    Key key_note_3 (
        .clk(clk),
        .rst_n(rst_n),
        .key_note(key_notes[2]),
        .key_on_out(key_on[2]),
        .key_off_out(key_off[2])
    );

    Key key_note_4 (
        .clk(clk),
        .rst_n(rst_n),
        .key_note(key_notes[3]),
        .key_on_out(key_on[3]),
        .key_off_out(key_off[3])
    );

    Key key_note_5 (
        .clk(clk),
        .rst_n(rst_n),
        .key_note(key_notes[4]),
        .key_on_out(key_on[4]),
        .key_off_out(key_off[4])
    );

    Key key_note_6 (
        .clk(clk),
        .rst_n(rst_n),
        .key_note(key_notes[5]),
        .key_on_out(key_on[5]),
        .key_off_out(key_off[5])
    );

    Key key_note_7 (
        .clk(clk),
        .rst_n(rst_n),
        .key_note(key_notes[6]),
        .key_on_out(key_on[6]),
        .key_off_out(key_off[6])
    );

    // decode the correct note
    always @(*) begin
        case (key_on)
            7'b000_0001: note_out = 4'd1; 
            7'b000_0010: note_out = 4'd2;
            7'b000_0100: note_out = 4'd3;
            7'b000_1000: note_out = 4'd4;
            7'b001_0000: note_out = 4'd5;
            7'b010_0000: note_out = 4'd6;
            7'b100_0000: note_out = 4'd7;
            default: note_out = 4'd0;
        endcase
    end

        assign key_on_out = (key_on == 7'd0) ? 0 : 1;
        assign key_off_out = (key_off == 7'd0) ? 0 : 1;

endmodule
