`timescale 1ns / 1ps

module StateMachine(
    input wire clk,
    input wire rst_n,
    input wire set,
    input wire key_on_A,
    input wire key_off_A,
    input wire[5:0] note_A,
    input wire key_on_B,
    input wire key_off_B,
    input wire[5:0] note_B,
    output reg[0:0] key_on_out,
    output reg[0:0] key_off_out,
    output reg[5:0] note
    );
    parameter freePlay = 2'b00;
    parameter autoPlay = 2'b01;
    parameter learn = 2'b10;
    reg[1:0] currentState;
    always@(posedge clk,negedge rst_n)begin
        if(~rst_n)begin
            key_on_out <= key_on_A;
            key_off_out <= key_off_A;
            note <= note_A;
            currentState <= freePlay;
            
        end
        else begin
            case(currentState)
            freePlay: begin key_on_out <= key_on_A; key_off_out <= key_off_A; note <= note_A; end
            autoPlay: begin key_on_out <= key_on_B; key_off_out <= key_off_B; note <= note_B; end
            learn: begin key_on_out <= key_on_B; key_off_out <= key_off_B; note <= note_B; end//to be modified
            endcase
        end
    end
    
    always@(negedge set)begin
    if(~set)begin
        case(currentState)
        freePlay: currentState <= autoPlay;
        autoPlay: currentState <= learn;
        learn: currentState <= freePlay;
        endcase
    end
    end
endmodule
