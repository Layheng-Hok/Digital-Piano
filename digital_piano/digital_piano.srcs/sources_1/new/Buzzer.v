`timescale 1ns / 1ps
`include "constants.vh"

module Buzzer (
    input wire clk,         
    input wire rst_n,
    input wire key_on_in,
    input wire key_off_in,
    input wire [`BUZZER_NOTE_IN_WIDTH -1:0] note_in,  // note (Input 1 outputs a signal for 'do, 2 for 're, 3 for 'mi, 4, and so on)
    output reg [`NOTE_OUT_WIDTH -1:0] note_out,
    input wire octave_button, // octave button to switch between octaves
    output wire [`CURRENT_OCTAVE_WIDTH -1:0] octave_out,
    output wire speaker     // buzzer output signal
    );

    reg[`CURRENT_OCTAVE_WIDTH -1:0] currentOctave;
    assign octave_out = currentOctave;
    localparam IDLE = 1'b0, BUZZ = 1'b1;
    
    wire [`NOTES_WIDTH -1:0] notes [`NOTES_SIZE -1:0];
    reg state;
    reg counter_en;
    reg [`COUNTER_MAX_WIDTH -1:0] counter_max;
    reg [`COUNT_WIDTH -1:0] counter;
    reg pwm;
    reg octave_button_prev;
    wire key_on_tmp,key_off_tmp;
    Key key(clk,rst_n,octave_button,key_on_tmp,key_off_tmp);
    
    assign notes[0] = `BUZZER_NOTE_0;
    // frequencies of do, re, mi, fa, so, la, si 
    assign notes[1] = `BUZZER_NOTE_1;
    assign notes[2] = `BUZZER_NOTE_2;  
    assign notes[3] = `BUZZER_NOTE_3;
    assign notes[4] = `BUZZER_NOTE_4;
    assign notes[5] = `BUZZER_NOTE_5;
    assign notes[6] = `BUZZER_NOTE_6;
    assign notes[7] = `BUZZER_NOTE_7;
   
    //frequencies of low do, low re, low mi...
    assign notes[8] = `BUZZER_NOTE_8;
    assign notes[9] = `BUZZER_NOTE_9;
    assign notes[10] = `BUZZER_NOTE_10;
    assign notes[11] = `BUZZER_NOTE_11;
    assign notes[12] = `BUZZER_NOTE_12;
    assign notes[13] = `BUZZER_NOTE_13;
    assign notes[14] = `BUZZER_NOTE_14;

    //fequencies of high do, high re, high mi... 
    assign notes[15] = `BUZZER_NOTE_15;
    assign notes[16] = `BUZZER_NOTE_16;
    assign notes[17] = `BUZZER_NOTE_17;
    assign notes[18] = `BUZZER_NOTE_18;
    assign notes[19] = `BUZZER_NOTE_19;
    assign notes[20] = `BUZZER_NOTE_20;
    assign notes[21] = `BUZZER_NOTE_21;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pwm <= 1'b0;
            counter <= 32'd0;
        end
        else begin
            if (counter == counter_max) begin
                pwm <= ~pwm;
                counter <= 32'd0;
            end  
            else if (counter_en)
                counter <= counter + 32'd1;
            else 
                counter <= 32'd0;
          end 
          end

       always @(posedge clk or negedge rst_n) begin
                  if (!rst_n) begin
                      state <= IDLE;
                      counter_en <= 1'b0;
                  end
                  else begin
                      case (state)
                          IDLE:
                              begin       
                                  if (key_on_in) begin
                                      state <= BUZZ;
                                      note_out <= note_in;
                                      case ({currentOctave, note_in})
                                            {`OCTAVE_LOW, 6'd1}: counter_max <= notes[8];
                                            {`OCTAVE_LOW, 6'd2}: counter_max <= notes[9];
                                            {`OCTAVE_LOW, 6'd3}: counter_max <= notes[10];
                                            {`OCTAVE_LOW, 6'd4}: counter_max <= notes[11];
                                            {`OCTAVE_LOW, 6'd5}: counter_max <= notes[12];
                                            {`OCTAVE_LOW, 6'd6}: counter_max <= notes[13];
                                            {`OCTAVE_LOW, 6'd7}: counter_max <= notes[14];
                                            
                                            {`OCTAVE_NORMAL, 6'd1}: counter_max <= notes[1];
                                            {`OCTAVE_NORMAL, 6'd2}: counter_max <= notes[2];
                                            {`OCTAVE_NORMAL, 6'd3}: counter_max <= notes[3];
                                            {`OCTAVE_NORMAL, 6'd4}: counter_max <= notes[4];
                                            {`OCTAVE_NORMAL, 6'd5}: counter_max <= notes[5];
                                            {`OCTAVE_NORMAL, 6'd6}: counter_max <= notes[6];
                                            {`OCTAVE_NORMAL, 6'd7}: counter_max <= notes[7];
                                            
                                            {`OCTAVE_HIGH, 6'd1}: counter_max <= notes[15];
                                            {`OCTAVE_HIGH, 6'd2}: counter_max <= notes[16];
                                            {`OCTAVE_HIGH, 6'd3}: counter_max <= notes[17];
                                            {`OCTAVE_HIGH, 6'd4}: counter_max <= notes[18];
                                            {`OCTAVE_HIGH, 6'd5}: counter_max <= notes[19];
                                            {`OCTAVE_HIGH, 6'd6}: counter_max <= notes[20];
                                            {`OCTAVE_HIGH, 6'd7}: counter_max <= notes[21];
                                          default: counter_max <= notes[0];
                                      endcase
                                  end
                                  else
                                      state <= IDLE;
                              end
                          BUZZ:
                              begin
                                  counter_en <= 1'b1;
                                  if (key_off_in) begin
                                      counter_en <= 1'b0;
                                      state <= IDLE;
                                  end
                                  else
                                      state <= BUZZ;
                              end
                          default:
                              state <= IDLE;
                      endcase
                  end    
              end
          
              assign speaker = pwm; 
              reg state1;
                  localparam idle = 1'b0, set = 1'b1;
                  always @(posedge clk or negedge rst_n) begin
                      if (!rst_n) begin
                          state1 <= idle;
                          currentOctave <= `OCTAVE_NORMAL;
                      end
                      else begin
                          case (state1)
                              idle:
                                  begin
                                      if (key_on_tmp) begin
                                          case (currentOctave)
                                              `OCTAVE_NORMAL: begin currentOctave <= `OCTAVE_HIGH; end
                                              `OCTAVE_HIGH: begin currentOctave <= `OCTAVE_LOW; end
                                              `OCTAVE_LOW: begin currentOctave <= `OCTAVE_NORMAL; end
                                          endcase
                                          state1 <= set;
                                      end
                                      else
                                          state1 <= idle;
                                  end
                              set:
                                  begin
                                      if (key_off_tmp) begin
                                          state1 <= idle;
                                      end
                                      else
                                          state1 <= set;
                                  end
                              default:
                                  state1 <= idle;
                          endcase
                      end    
                  end 
          endmodule