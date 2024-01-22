`timescale 1ns / 1ps 
`include "constants.vh"

module AutoPlay(
    input wire clk,
    input wire rst_n,
    input wire set_speed,
    input wire set_song,
    output wire key_on_out,
    output wire key_off_out,
    output wire[`NOTE_WIDTH - 1:0] note,
    output wire[`SEG_WIDTH -1:0] seg, 
    output wire [`TRACK_NUM_AUTO_WIDTH -1:0] track_number_auto
);
    wire finish;
    wire sameNote;
    wire[`NOTE_WIDTH - 1:0] index;
    wire[`SONG_NUM_WIDTH -1:0] song_num = `SONGNM;
    wire[`SPEED_WIDTH -1:0] speed = `SPEED;
    wire key_on_speed;
    wire key_off_speed;
    wire key_on_song;
    wire key_off_song;
    wire[`SONG_BCD_CODE_WIDTH -1:0] song_BCD_code;
   
   Key key_speed(clk, rst_n, set_speed, key_on_speed, key_off_speed);  //speed key controller
   Key key_song(clk, rst_n, set_song, key_on_song, key_off_song);       //song key controller
   BeatController bc(clk, rst_n, key_on_song, key_off_song, key_on_speed, key_off_speed, key_on_out, key_off_out, index);  //beat controller
   Music music1(clk, rst_n, key_on_song, key_off_song, index, song_BCD_code, note, track_number_auto, finish);  //music playback module
   BCDto7Segment bcd_7segment(song_BCD_code, seg);  // BCD to 7-segment converter

endmodule