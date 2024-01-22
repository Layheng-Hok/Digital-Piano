`timescale 1ns / 1ps
`include "constants.vh"

module ModeSelector(
    input clk,
    input rst_n,
    input set_mode,
    input key_on_A,
    input key_off_A,
    input[`NOTE_A_WIDTH -1:0] note_A,
    input key_on_B,
    input key_off_B,
    input[`NOTE_B_WIDTH -1:0] note_B,
    input [`TUB_CONTROL_B -1:0]tub_control_B,
    input key_on_C,
    input key_off_C,
    input[`NOTE_C_WIDTH -1:0] note_C,
    input tub_sel_C,
    input [`TUB_CONTROL_C -1:0]tub_control_C,
    output reg key_on_out,
    output reg key_off_out,
    output reg[`TUB_CONTROL -1:0]tub_control,
    output reg tub_sel,
    output reg tub_sel_user,
    output reg[`NOTE_OUT_WIDTH -1:0] note_out,
    output reg[`MODE_MODE_SELECTOR_WIDTH -1:0] mode
    );
        
    wire key_on,key_off; //internal signals for key on and key off
    Key key(clk,rst_n,set_mode,key_on,key_off); //key controller instance
    
    always @(posedge clk,posedge key_on)begin
        if(key_on) begin
            key_on_out = 1'b0;
            key_off_out = 1'b1;
            note_out = 6'd0;
            tub_sel = 1'b0;
            tub_control = 8'd0;
        end
        else begin
            case(mode)
            `FREE_MODE: begin key_on_out = key_on_B; key_off_out = key_off_B; note_out = note_B; tub_sel = 1'b1;tub_control = tub_control_B;tub_sel_user = 0;end
            `AUTO_MODE: begin key_on_out = key_on_A; key_off_out = key_off_A; note_out = note_A; tub_sel = 1'b0;tub_control = tub_control_B;tub_sel_user = 0;end
            `LEARNING_MODE: begin  key_on_out = key_on_C; key_off_out = key_off_C; note_out = note_C; tub_sel = tub_sel_C;tub_control = tub_control_C; tub_sel_user = 1;end
            endcase
        end
    end
    
    reg state;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= `IDLE;   //initialize state to IDLE
            mode <= `FREE_MODE;   //initialize mode to Free Mode
        end
        else begin
            case (state)
                `IDLE:
                    begin
                        if (key_on) begin
                            case (mode)
                                `FREE_MODE: begin mode <= `AUTO_MODE; end
                                `AUTO_MODE: begin mode <= `LEARNING_MODE; end
                                `LEARNING_MODE: begin mode <= `FREE_MODE; end
                            endcase
                            state <= `SET;
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
endmodule
