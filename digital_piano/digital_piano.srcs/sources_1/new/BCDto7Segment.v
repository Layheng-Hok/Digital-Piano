`timescale 1ns / 1ps
`include "constants.vh"

module BCDto7Segment(
    input[`BCD_WIDTH -1:0] BCD,
    output reg[`SEG_WIDTH -1:0] segment
    );
    always @ * begin
    case(BCD)
    4'b0000: segment = 8'b1111_1100; //"0" : abcdef_ _
    4'b0001: segment = 8'b0110_0000; //"1": _bc_ _ _ _ _ _
    4'b0010: segment = 8'b1101_1010; //"2": ab_de_g_
    4'b0011: segment = 8'b1111_0010; //"3": abcd_ _ g _
    4'b0100: segment = 8'b0110_0110; //"4": _bc _ _fg_
    4'b0101: segment = 8'b1011_0110; //"5": a_cd_fg_
    4'b0110: segment = 8'b1011_1110; //"6": a_cdefg_
    4'b0111: segment = 8'b1110_0000; //"7": abc_ _ _ _ _
    4'b1000: segment = 8'b1111_1110; //"8": abcdefg_
    4'b1001: segment = 8'b1110_0110; //"9": abc_ _ fg_
    default:
    segment = 8'b1001_1110; //"E": a_ _ defg_
    endcase
    end

endmodule
