`timescale 1ns / 1ps

module Buzzer (
    input wire clk,         // clock signal
    input wire rst_n,
    input wire key_on_in,
    input wire key_off_in,
    input wire [3:0] note_in,  // note (Input 1 outputs a signal for 'do, 2 for 're, 3 for 'mi, 4, and so on)
    output wire speaker     // buzzer output signal
    );

    localparam IDLE = 1'b0, BUZZ = 1'b1;
    
    reg state;
    wire [31:0] notes [7:0];
    reg counter_en;
    reg [31:0] counter_max;
    reg [31:0] counter;
    reg pwm;
   
    // frequencies of do, re, mi, fa, so, la, si
    // obtain the ratio of how long the buzzer should be active in one second
    // multiply each note by 2 for higher octave
    // divide each note by 2 for lower octave
    assign notes[1] = 381680;
    assign notes[2] = 340136;
    assign notes[3] = 303030;
    assign notes[4] = 285714;
    assign notes[5] = 255102;
    assign notes[6] = 227273;
    assign notes[7] = 202429;

    // clock divider
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
    
    // state machine
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
                            case (note_in)
                                // hard code value for simulation purpose
                                4'd1: counter_max <= 32'd10 - 1; 
                                4'd2: counter_max <= 32'd20 - 1;
                                4'd3: counter_max <= 32'd30 - 1;
                                4'd4: counter_max <= 32'd40 - 1;
                                4'd5: counter_max <= 32'd50 - 1;
                                4'd6: counter_max <= 32'd60 - 1;
                                4'd7: counter_max <= 32'd70 - 1;
                                default: counter_max <=  32'd10 - 1; 
                                // 4'd1: counter_max <= notes[1]; 
                                // 4'd2: counter_max <= notes[2];
                                // 4'd3: counter_max <= notes[3];
                                // 4'd4: counter_max <= notes[4];
                                // 4'd5: counter_max <= notes[5];
                                // 4'd6: counter_max <= notes[6];
                                // 4'd7: counter_max <= notes[7];
                                // default: counter_max <=  notes[1]; 
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

    assign speaker = pwm;  // output a PWM signal to the buzzer

endmodule
