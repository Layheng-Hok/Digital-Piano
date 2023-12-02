`timescale 1ns / 1ps
`define clk_period 20

module Buzzer_tb();

    reg clk;
    reg rst_n;
    reg key_on;
    reg key_off;
    reg [3:0] note;
    wire speaker;

    Buzzer DUT (
        .clk(clk),
        .rst_n(rst_n),
        .key_on(key_on),
        .key_off(key_off),
        .note(note),
        .speaker(speaker)
    );

    initial clk = 1'b1;
    always #(`clk_period / 2) clk = ~clk;

    initial begin
        rst_n = 1'b0;
        key_on = 1'b0;
        key_off = 1'b0;
        note = 4'd0;
        
        #(`clk_period);
        rst_n = 1'b1;

        // test note do
        #(`clk_period);
        key_on = 1'b1;
        note = 4'd1;  // play do

        #(`clk_period);
        key_on = 1'b0;

        #(`clk_period * 500);
        key_off = 1'b1;

        #(`clk_period);
        key_off = 1'b0;

        // test note re
        #(`clk_period);
        key_on = 1'b1;
        note = 4'd2;  // play re

        #(`clk_period);
        key_on = 1'b0;

        #(`clk_period * 500);
        key_off = 1'b1;

        #(`clk_period);
        key_off = 1'b0;

        // test note mi
        #(`clk_period);
        key_on = 1'b1;
        note = 4'd3;  // play mi

        #(`clk_period);
        key_on = 1'b0;

        #(`clk_period * 500);
        key_off = 1'b1;

        #(`clk_period);
        key_off = 1'b0;

        // test note fa
        #(`clk_period);
        key_on = 1'b1;
        note = 4'd4;  // play fa

        #(`clk_period);
        key_on = 1'b0;

        #(`clk_period * 500);
        key_off = 1'b1;

        #(`clk_period);
        key_off = 1'b0;

        // test note so
        #(`clk_period);
        key_on = 1'b1;
        note = 4'd5;  // play so

        #(`clk_period);
        key_on = 1'b0;

        #(`clk_period * 500);
        key_off = 1'b1;

        #(`clk_period);
        key_off = 1'b0;

        // test note la
        #(`clk_period);
        key_on = 1'b1;
        note = 4'd6;  // play la

        #(`clk_period);
        key_on = 1'b0;

        #(`clk_period * 500);
        key_off = 1'b1;

        #(`clk_period);
        key_off = 1'b0;

        // test note si
        #(`clk_period);
        key_on = 1'b1;
        note = 4'd7;  // play si

        #(`clk_period);
        key_on = 1'b0;

        #(`clk_period * 500);
        key_off = 1'b1;

        #(`clk_period);
        key_off = 1'b0;

        $stop;

    end
    
endmodule
