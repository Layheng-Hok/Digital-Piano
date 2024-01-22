`timescale 1ns / 1ps
`include "constants.vh"

module Piano(
    input wire clk,
    input wire rst_n,
    input wire set_mode,
    input wire octave_button,
    input wire set_speed,
    input wire set_song,
    input wire [`KEY_NOTES_WIDTH -1:0] key_notes,
    input set_user,
    output wire speaker,
    output wire [`LIGHT_WIDTH -1:0] light,
    output wire tub_sel,
    output wire tub_sel_user,
    output wire [`TUB_CONTROL -1:0] tub_control, 
    output wire [`TUB_CONTROL_USER -1:0] tub_control_user,
    output hsync,
    output vsync,
    output [`VGA_RGB_WIDTH -1:0] vga_rgb,
    output [`REACTION_RATE_WIDTH -1:0] reaction_rate
    );

    //output from keyController module
    wire key_on_A;
    wire key_off_A;
    wire[`NOTE_A_WIDTH -1:0] note_A;
    
    // output from autoPlay module
    wire key_on_B;
    wire key_off_B;
    wire[`NOTE_B_WIDTH -1:0] note_B;
    wire [`TUB_CONTROL_B -1:0] tub_control_B;
   
   // output from learning mode module 
    wire key_on_C;
    wire key_off_C;
    wire[`NOTE_C_WIDTH -1:0] note_C;
    wire tub_sel_C;
    wire[`TUB_CONTROL -1:0] tub_control_C;
    
    // after selection from ModeSelector module
    wire key_on;
    wire key_off;
    wire [`NOTE_WIDTH -1:0] note;
    wire [`MODE_WIDTH -1:0] mode;
    
    // helper output from buzzer
    wire [`SELECTED_NOTE_WIDTH -1:0] selected_note;
    wire [`CURRENT_OCTAVE_WIDTH -1:0] current_octave;
    
    // from music module
    wire [`TRACK_NUM_AUTO_WIDTH -1:0] track_number_auto;
    wire [`TRACK_NUM_LEARNING_WIDTH -1:0] track_number_learning;
    
    // from learning_mode
    wire finish;
    
//instantiating submodules
    KeyController key_controller (
        .clk(clk),        
        .rst_n(rst_n),
        .key_notes(key_notes),
        .key_on_out(key_on_A),
        .key_off_out(key_off_A),
        .note_out(note_A)
        
    );
    AutoPlay auto_play(
        .clk(clk),
        .rst_n(rst_n),
        .set_speed(set_speed),
        .set_song(set_song),
        .key_on_out(key_on_B),
        .key_off_out(key_off_B),
        .note(note_B),
        .seg(tub_control_B),
        .track_number_auto(track_number_auto)
    );
    LearningMode learning_mode(
        .clk(clk),
        .rst_n(rst_n),
        .set_song(set_song),
        .set_user(set_user),
        .key_notes(key_notes),
        .key_on_out(key_on_C),
        .key_off_out(key_off_C), 
        .notes(note_C),
        .track_number_learning(track_number_learning),
        .reaction_rate(reaction_rate),
        .tub_sel(tub_sel_C),
        .tub_control(tub_control_C),
        .tub_control_user(tub_control_user), 
        .finish(finish)
    );
    ModeSelector(
        .clk(clk),
        .rst_n(rst_n),
        .set_mode(set_mode),
        .key_on_A(key_on_A),
        .key_off_A(key_off_A),
        .note_A(note_A),
        .key_on_B(key_on_B),
        .key_off_B(key_off_B),
        .note_B(note_B),
        .tub_control_B(tub_control_B),
        .key_on_C(key_on_C),
        .key_off_C(key_off_C),
        .note_C(note_C),
        .tub_sel_C(tub_sel_C),
        .tub_control_C(tub_control_C),
        .key_on_out(key_on),
        .key_off_out(key_off),
        .tub_control(tub_control),
        .tub_sel(tub_sel),
        .tub_sel_user(tub_sel_user),
        .note_out(note),
        .mode(mode)
    );
    
//output modules
    LED led(
        .clk(clk),
        .rst_n(rst_n),
        .note(note),
        .key_notes(key_notes),
        .light(light)
    );

    Buzzer buzzer (
        .clk(clk),        
        .rst_n(rst_n),
        .key_on_in(key_on),
        .key_off_in(key_off),
        .note_in(note),  
        .note_out(selected_note),
        .octave_button(octave_button),
        .octave_out(current_octave),
        .speaker(speaker)
    );
            
     VGADisplay vga_display(
        .clk(clk),
        .sys_rst_n(rst_n),
        .mode(mode),
        .key_on_in(key_on),
        .key_off_in(key_off),
        .note_in(note),
        .selected_note(selected_note),
        .track_number_auto(track_number_auto),
        .track_number_learning(track_number_learning),
        .current_octave(current_octave),
        .reaction_rate(reaction_rate),
        .finish(finish),
        .hsync(hsync),
        .vsync(vsync),
        .vga_rgb(vga_rgb)
    );
                
  endmodule