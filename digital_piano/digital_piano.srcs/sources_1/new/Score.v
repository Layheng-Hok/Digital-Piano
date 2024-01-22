`timescale 1ns / 1ps
`include "constants.vh"
  
module Score(
        input clk,            
        input rst_n,           
        input count_on,          
        input count_off,         
        input finish,            
        output tub_sel,       
        output [`SEG_WIDTH -1:0] tub_control,  
        output [`BCD_WIDTH -1:0] new_record   // new record BCD output
    );
    
    reg[`BCD_WIDTH -1:0] BCD;
    reg[`STATE_SCORE_WIDTH -1:0] state; //state for controlling score counting
    reg[`MISTAKES_WIDTH -1:0] mistakes; //mistakes counter
    
    BCDto7Segment bcd(BCD, tub_control);
    assign tub_sel = finish;
    
     // state machine for counting mistakes
       always @(posedge clk or negedge rst_n) begin
           if (!rst_n) begin
               state <= 2'd0;
               mistakes <= 0;
           end
           else begin
               case (state)
                   2'd0:
                       begin
                           if (count_on) state <= state + 1;
                       end
                   2'd1:
                       begin
                           state <= state + 1;
                           mistakes <= mistakes + 1;
                       end
                   2'd2:
                       begin
                           if (count_off) state <= 2'd0;
                       end
               endcase
           end
       end
       
    always@(*)begin
        if(mistakes <= 9'd2)BCD = 8;
        else if(mistakes <= 9'd3)BCD = 7;
        else if(mistakes <= 9'd4)BCD = 6;
        else if(mistakes <= 9'd5)BCD = 5;
        else if(mistakes <= 9'd6)BCD = 4;
        else if(mistakes <= 9'd7)BCD = 3;
        else BCD = 2;
    end
    
    assign new_record = BCD;
endmodule
