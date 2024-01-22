`timescale 1ns / 1ps
`include "constants.vh"

module LearningMode(
    input clk,
    input rst_n,
    input set_song,
    input set_user,
    input [`KEY_NOTES_WIDTH -1:0] key_notes,
    output key_on_out,
    output key_off_out,
    output wire[`NOTE_WIDTH -1:0] notes, 
    output wire[1:0] track_number_learning,
    output wire[`REACTION_RATE_WIDTH -1:0] reaction_rate,
    output tub_sel,
    output [`TUB_CONTROL -1:0] tub_control,
    output [`TUB_CONTROL_USER -1:0] tub_control_user,
    output wire finish
    ); 
    
    wire[`INDEX_WIDTH -1:0] index;
    wire key_on_song,key_off_song;
    wire key_on_speed,key_off_speed;
    wire [`NOTE_OUT_WIDTH -1:0] dummy;
    wire sameNote;
    wire mistake_on,mistake_off;
    wire [`DUMMY_WIRE_WIDTH -1:0] dummy_wire;
    wire key_on_LED;
    wire[`STATE_LEARNING_MODE_WIDTH -1:0] state;
    wire[`BCD_WIDTH -1:0] new_record;
    
   // submodule instantiations
     Key key(clk, rst_n, set_song, key_on_song, key_off_song);
     MusicChecker music_checker(clk, rst_n, set_song, key_notes, index, state, mistake_on, mistake_off);
     Music music(clk, rst_n, key_on_song, key_off_song, index, dummy_wire, notes, track_number_learning, finish);
     KeyController key_controller(clk, rst_n, key_notes, key_on_out, key_off_out, dummy);
     ReactionRating rating(clk, rst_n, state, reaction_rate);
     Score score(clk, rst_n, mistake_on, mistake_off, finish, tub_sel, tub_control, new_record);
     Record record(clk, rst_n, set_user, finish, new_record, tub_control_user);
endmodule
