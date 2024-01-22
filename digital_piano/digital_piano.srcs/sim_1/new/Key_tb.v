`timescale 1ns / 1ps
`define clk_period 10

module Key_tb();
    reg clk;
    reg rst_n;
    reg key_note;
    wire key_on_out;
    wire key_off_out;

    Key DUT (
        .clk(clk),
        .rst_n(rst_n),
        .key_note(key_note),
        .key_on_out(key_on_out),
        .key_off_out(key_off_out)
    );

    initial clk = 1'b1;
    always #(`clk_period / 2) clk = ~clk; 

    initial begin
        rst_n = 1'b0;
        key_note = 1'b1;

        #(`clk_period)
        rst_n = 1'b1;

        // pressing
        #(`clk_period)
        key_note = 1'b0;

        #(`clk_period)
        key_note = 1'b1;

        #(`clk_period)
        key_note = 1'b0;

        #(`clk_period)
        key_note = 1'b1;

        #(`clk_period)
        key_note = 1'b0;  // finish edge drop

        // pressed
        #(`clk_period * 100)

        // releasing
        #(`clk_period)
        key_note = 1'b1;

        #(`clk_period)
        key_note = 1'b0;

        #(`clk_period)
        key_note = 1'b1;

        #(`clk_period)
        key_note = 1'b0;

        #(`clk_period)
        key_note = 1'b1;  // finish edge rise

        #(`clk_period * 100)
        $stop;
    end
endmodule