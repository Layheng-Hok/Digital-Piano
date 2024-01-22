`timescale 1ns / 1ps
`include "constants.vh" 

module MusicChecker(
    input clk,
    input rst_n,
    input wire set_song,
    input wire [`KEY_NOTES_WIDTH -1:0] key_notes,
    output reg[`INDEX_WIDTH -1:0] index,
    output reg[`STATE_MUSIC_CHECKER_WIDTH -1:0] state,
    output reg mistake_on,
    output reg mistake_off
    );
    
    wire dummyWire;
    wire[`NOTE_INPUT_WIDTH -1:0] note_input;
    wire[`NOTE_CURRENT_WIDTH -1:0] note_current;
    wire key_on,key_off;
    wire key_on_song,key_off_song;
    wire finish;
    
    //submodules' initialization
    Key key(clk, rst_n, set_song, key_on_song, key_off_song);
    KeyController key_controller(clk, rst_n, key_notes, key_on, key_off, note_input);
    Music music(clk, rst_n, key_on_song, key_off_song, index, dummyWire, note_current, finish);
        
    reg[`COUNT_WIDTH -1:0] count;
    reg[`MAX_IDLE_COUNT_WIDTH -1:0] max_IDLE_count = `NORMAL_IDLE;
    always @(posedge clk,negedge rst_n)begin
        if(~rst_n)begin
            index <= 10'd0;
            state <= 2'd0;
            count <= 0;
            mistake_on <=0;
            mistake_off <=1;
        end
        else begin
        /*state explanation
        0:when the user have not press the correct button
        1:the button is on
        2:the button is off, idle then enter state 0 */
            case(state)
                2'd0:
                    if(note_current == note_input)begin
                        state<= 2'd1;
                        mistake_on<=0;
                        mistake_off<=1;
                    end
                    else begin
                    if(key_on)begin
                        mistake_on <=1;
                        mistake_off <=0;
                    end
                    end
                2'd1:
                    if(key_off)begin
                        state <= 2'd2;
                    end
                2'd2:
                    if(count<4*max_IDLE_count) begin
                        count <= count + 1;
                    end
                    else begin
                        index <= index + 1;
                        count <= 0;
                        state <=2'd3;
                    end
                 2'd3:
                    state <= 2'd0;
            endcase
        end 
    end
endmodule
