`timescale 1ns / 1ps
`include "constants.vh"

module BeatController(
    input wire clk,
    input wire rst_n,
    input wire key_on_song,
    input wire key_off_song,
    input wire key_on,
    input wire key_off,
    output reg key_on_out,
    output reg key_off_out,
    output reg[`INDEX_WIDTH -1:0] index    //index of note
    );

    reg[`COUNT_WIDTH -1:0] count;
    reg[`MAX_COUNT_WIDTH -1:0] max_count = `NORMAL;
    reg[`MAX_IDLE_COUNT_WIDTH -1:0] max_IDLE_count = `NORMAL_IDLE;
    reg[`SPEED_MODE_WIDTH -1:0] speed_mode = `NORMAL_MODE;
    
    always @ (posedge clk, negedge rst_n,posedge key_on_song) begin
            if(~rst_n||key_on_song) begin
                count <= 32'd0;
                key_on_out <= 1'b0;
                key_off_out <= 1'b0;
                index <= 10'd0;
            end
            else begin
                 if(count<max_IDLE_count) begin
                    key_on_out <= 1'b0;
                    key_off_out <= 1'b1;
                    count <= count+32'd1;
    
                end
                else if(count >= max_IDLE_count && count < max_count+max_IDLE_count)begin
                    key_on_out <= 1'b1;
                    key_off_out<= 1'b0;
                    count <= count+32'd1;
                end
                else if(count >= max_count+max_IDLE_count) begin
                    index <= index + 10'd1;
                    count <= 32'd0;
                end
                
            end
        end
        
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
                                case (speed_mode)
                                    2'd0: begin speed_mode <= `NORMAL_MODE;max_count <= `NORMAL; max_IDLE_count <= `NORMAL_IDLE; end
                                    2'd1: begin speed_mode <= `FAST_MODE;max_count <= `FAST; max_IDLE_count <= `FAST_IDLE; end
                                    2'd2: begin speed_mode <= `SLOW_MODE;max_count <= `SLOW; max_IDLE_count <= `SLOW_IDLE; end
                                    default: begin speed_mode <= `NORMAL_MODE;max_count <= `NORMAL; max_IDLE_count <= `NORMAL_IDLE; end
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
endmodule
