`timescale 1ns / 1ps

module Piano(
    input wire clk,
    input wire rst_n,
    input wire [6:0] key_notes,
    output wire speaker
    );
   
    wire key_on;
    wire key_off;
    wire [3:0] note;

    KeyController key_controller (
        .clk(clk),        
        .rst_n(rst_n),
        .key_notes(key_notes),
        .key_on_out(key_on),
        .key_off_out(key_off),
        .note_out(note)
        
    );

    Buzzer buzzer (
        .clk(clk),        
        .rst_n(rst_n),
        .key_on_in(key_on),
        .key_off_in(key_off),
        .note_in(note),  
        .speaker(speaker)     
    );

endmodule
