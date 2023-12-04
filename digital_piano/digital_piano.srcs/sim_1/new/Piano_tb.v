`timescale 1ns / 1ps
`define clk_period 10

module Piano_tb();
    reg clk;
    reg rst_n;
    reg [6:0] key_notes;
    wire speaker;

    Piano DUT (
        .clk(clk),
        .rst_n(rst_n),
        .key_notes(key_notes),
        .speaker(speaker)
    );

    initial clk = 1'b1;
    always #(`clk_period / 2) clk = ~clk;

    initial begin
        rst_n = 1'b0;
        key_notes = 7'b111_1111; 

        #(`clk_period)
        rst_n = 1'b1;

        #(`clk_period)
        key_notes = 7'b111_1110;

        #(`clk_period)
        key_notes = 7'b111_1111;

        #(`clk_period)
        key_notes = 7'b111_1110;

        #(`clk_period)
        key_notes = 7'b111_1111;

        #(`clk_period)
        key_notes = 7'b111_1110;  // key note 1 pressed

        #(`clk_period * 100) 

        #(`clk_period)
        key_notes = 7'b111_1111;

        #(`clk_period)
        key_notes = 7'b111_1110;

        #(`clk_period)
        key_notes = 7'b111_1111;

        #(`clk_period)
        key_notes = 7'b111_1110;

        #(`clk_period)
        key_notes = 7'b111_1111;  // key note 1 released

        #(`clk_period * 100)
        key_notes = 7'b111_1101;  // key note 2 pressed 

        #(`clk_period * 100)
        key_notes = 7'b111_1111;  // key note 2 released

        #(`clk_period * 100)
        key_notes = 7'b111_1011;  // key note 3 pressed 

        #(`clk_period * 100)
        key_notes = 7'b111_1111;  // key note 3 released
        
        #(`clk_period * 100)
        key_notes = 7'b111_0111;  // key note 4 pressed 

        #(`clk_period * 100)
        key_notes = 7'b111_1111;  // key note 4 released

        #(`clk_period * 100)
        key_notes = 7'b110_1111;  // key note 5 pressed 

        #(`clk_period * 100)
        key_notes = 7'b111_1111;  // key note 5 released

        #(`clk_period * 100)
        key_notes = 7'b101_1111;  // key note 6 pressed 

        #(`clk_period * 100)
        key_notes = 7'b111_1111;  // key note 6 released

        #(`clk_period * 100)
        key_notes = 7'b011_1111;  // key note 7 pressed 

        #(`clk_period * 100)
        key_notes = 7'b111_1111;  // key note 7 released

        #(`clk_period * 100)
        $stop;
    end
endmodule
