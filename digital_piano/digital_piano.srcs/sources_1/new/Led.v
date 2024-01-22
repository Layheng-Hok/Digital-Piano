`timescale 1ns / 1ps
`include "constants.vh"

module LED(
    input wire clk,
    inout wire rst_n, 
    input wire[`NOTE_WIDTH -1:0] note,
    input wire [`KEY_NOTES_WIDTH -1:0] key_notes, //button functionality
    output reg[`LIGHT_WIDTH -1:0] light //one_hot code (LED)
    );
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            light <= 7'b0000000;  // reset the lights when rst_n is inactive
        end else begin
            if (note != 0) begin
                case (note)
                    6'd1: light <= 7'b0000001;
                    6'd2: light <= 7'b0000010;
                    6'd3: light <= 7'b0000100;
                    6'd4: light <= 7'b0001000;
                    6'd5: light <= 7'b0010000;
                    6'd6: light <= 7'b0100000;
                    6'd7: light <= 7'b1000000;
                    
                    6'd8: light <= 7'b0000001;
                    6'd9: light <= 7'b0000010;
                    6'd10: light <= 7'b0000100;
                    6'd11: light <= 7'b0001000;
                    6'd12: light <= 7'b0010000;
                    6'd13: light <= 7'b0100000;
                    6'd14: light <= 7'b1000000;
                    
                    6'd15: light <= 7'b0000001;
                    6'd16: light <= 7'b0000010;
                    6'd17: light <= 7'b0000100;
                    6'd18: light <= 7'b0001000;
                    6'd19: light <= 7'b0010000;
                    6'd20: light <= 7'b0100000;
                    6'd21: light <= 7'b1000000;
                    default: light <= 7'b0000000;
                endcase
            end else begin
                // Free mode
                light <= ~key_notes;
            end
        end
    end
endmodule
