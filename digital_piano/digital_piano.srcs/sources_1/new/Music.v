`timescale 1ns / 1ps
`include "constants.vh"

module Music(
    input wire clk,
    input wire rst_n,
    input wire key_on,
    input wire key_off,
    input wire[`INDEX_WIDTH -1:0] index,
    output reg[`SONG_BCD_CODE_WIDTH -1:0] song_BCD_code,
    output reg[`NOTE_OUT_WIDTH -1:0] note_out, 
    output wire [`TRACK_NUM_WIDTH-1:0] track_number,
    output reg finish
    );
    
    reg[`SONG_MODE_WIDTH -1:0] song_mode = `LITTLE_STAR_MODE;
    reg[`NOTE_SEQUENCE_WIDTH -1:0] note_sequence = 0;
    assign track_number = song_mode;
    
    always @(*)begin
            case(song_mode)
                `LITTLE_STAR_MODE: begin note_sequence = `LITTLE_STAR; song_BCD_code = 4'd2; end
                `ODE_TO_JOY_MODE: begin note_sequence = `ODE_TO_JOY; song_BCD_code = 4'd3; end
                `TWO_TIGERS_MODE: begin note_sequence= `TWO_TIGERS; song_BCD_code = 4'd1; end
            endcase
            note_out = note_sequence[index * 6 +5 -:6]; 
    end
    
    // state variable for key handling
    reg state;
    always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                state <= `IDLE;
            end
            else begin
                case (state)
                    `IDLE:
                        begin
                            if (key_on) begin
                                state <= `SET;
                                case (song_mode)
                                    `LITTLE_STAR_MODE: song_mode <= `ODE_TO_JOY_MODE;
                                    `TWO_TIGERS_MODE: song_mode <= `LITTLE_STAR_MODE;
                                    `ODE_TO_JOY_MODE: song_mode <= `TWO_TIGERS_MODE;
                                    default: song_mode <= `LITTLE_STAR_MODE;
                                endcase
                            end
                            else
                                state <= `IDLE;
                        end
                    `SET:
                        begin
                            if (key_off) begin
                                state <= `IDLE;
                            end
                            else
                                state <= `SET;
                        end
                    default:
                        state <= `IDLE;
                endcase
            end    
        end
        always@(*)begin
            case(song_mode)
               `LITTLE_STAR_MODE:
               begin
                     if( index == `LITTLE_STAR_LENGTH+1)finish = 1;
               else finish = 0;
               end
               `TWO_TIGERS_MODE:
               begin
                     if( index == `TWO_TIGERS_LENGTH-1)finish = 1;
                     else finish = 0;
                end
                `ODE_TO_JOY_MODE:
                begin
                     if( index == `ODE_TO_JOY_LENGTH-1)finish = 1;
                     else finish = 0;
                end
            endcase
        end
endmodule
