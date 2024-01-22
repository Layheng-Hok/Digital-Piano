`timescale 1ns / 1ps
`include "constants.vh"

module PixelMapper (
    input wire clk,
    input wire vga_clk,
    input wire rst_n,
    input wire [`PIX_X_WIDTH -1:0] pix_x,
    input wire [`PIX_Y_WIDTH -1:0] pix_y,
    input wire [`MODE_WIDTH -1:0] mode,
    input wire key_on_in,
    input wire key_off_in,
    input wire [`NOTE_IN_WIDTH -1:0] note_in, 
    input wire [`SELECTED_NOTE_WIDTH -1:0] selected_note,
    input wire [`TRACK_NUM_AUTO_WIDTH -1:0] track_number_auto,
    input wire [`TRACK_NUM_LEARNING_WIDTH -1:0] track_number_learning,
    input wire [`CURRENT_OCTAVE_WIDTH -1:0] current_octave,
    input wire [`REACTION_RATE_WIDTH -1:0] reaction_rate,
    input wire finish,
    output reg [`PIX_DATA_WIDTH -1:0] pix_data
);

    reg [`STATE_PIXEL_MAPPER_WIDTH -1:0] state;
    wire [`KEY_COLOR_WIDTH -1:0] key_color = (mode == `AUTO_PLAY_PIXEL_MAPPER ) ? `MAGENTA : (mode == `FREE_MODE_PIXEL_MAPPER  ) ? `BLUE : (mode == `LEARNING_PIXEL_MAPPER) ?  `GREEN : `WHITE;
    reg key_on;
    reg [`TRACK_NUM_WIDTH -1:0]  track_number;
    wire [`ROM_ADDR_TWO_TIGERS_WIDTH -1:0] rom_addr_two_tigers;           // 11-bit text ROM address
    wire [`ASCII_CHAR_TWO_TIGERS_WIDTH -1:0] ascii_char_two_tigers;          // 7-bit ASCII character code
    wire [`CHAR_ROW_TWO_TIGERS_WIDTH -1:0] char_row_two_tigers;            // 4-bit row of ASCII character
    wire [`BIT_ADDR_TWO_TIGERS_WIDTH -1:0] bit_addr_two_tigers;            // column number of ROM data
    wire [`ROM_DATA_TWO_TIGERS_WIDTH -1:0] rom_data_two_tigers;            // 8-bit row data from text ROM
    wire ascii_bit_two_tigers, ascii_bit_on_two_tigers;     // ROM bit and status signal
    
    ASCII_ROM ascii_rom_two_tigers(
        .clk(vga_clk), 
        .addr(rom_addr_two_tigers),
        .data(rom_data_two_tigers)
    );
    
    assign rom_addr_two_tigers = {ascii_char_two_tigers, char_row_two_tigers};   // ROM address is ascii code + row
    assign ascii_bit_two_tigers = rom_data_two_tigers[~bit_addr_two_tigers];     // reverse bit order
    
    assign ascii_char_two_tigers = (pix_x >= 51 && pix_x <= 59) ? 7'h54 :  // 'T'
                        (pix_x >= 59 && pix_x <= 67) ? 7'h57 :  // 'W'
                        (pix_x >= 67  && pix_x <= 75) ? 7'h4F :  // 'O'
                        (pix_x >= 75  && pix_x <= 83) ? 7'h20 :  // ' '
                        (pix_x >= 83  && pix_x <= 91) ? 7'h54 :  // 'T'
                        (pix_x >= 91  && pix_x <= 99) ? 7'h49 :  // 'I'
                        (pix_x >=99  && pix_x <= 107) ? 7'h47 :  // 'G'
                        (pix_x >=107  && pix_x <= 115) ? 7'h45 :  // 'E'
                        (pix_x >=115  && pix_x <= 123) ? 7'h52 :  // 'R'
                        (pix_x >=123  && pix_x <= 134) ? 7'h53 :  // 'S'
                        7'h20;  // ' '
        
    assign char_row_two_tigers = pix_y[3:0];               // row number of ascii character rom
    assign bit_addr_two_tigers = pix_x[2:0];               // column number of ascii character rom
    
    assign ascii_bit_on_two_tigers = (pix_x >= 51 && pix_x <= 147 && pix_y >= 110 && pix_y <= 127) ? ascii_bit_two_tigers : 1'b0;
    
    wire [`ROM_ADDR_TWO_TIGERS_WIDTH -1:0] rom_addr_little_star;           // 11-bit text ROM address
    wire [`ASCII_CHAR_TWO_TIGERS_WIDTH -1:0] ascii_char_little_star;          // 7-bit ASCII character code
    wire [`CHAR_ROW_TWO_TIGERS_WIDTH -1:0] char_row_little_star;            // 4-bit row of ASCII character
    wire [`BIT_ADDR_TWO_TIGERS_WIDTH -1:0] bit_addr_little_star;            // column number of ROM data
    wire [`ROM_DATA_TWO_TIGERS_WIDTH -1:0] rom_data_little_star;            // 8-bit row data from text ROM
    wire ascii_bit_little_star, ascii_bit_on_little_star;     // ROM bit and status signal
    
    ASCII_ROM ascii_rom_little_star(
        .clk(vga_clk), 
        .addr(rom_addr_little_star),
        .data(rom_data_little_star)
    );
    
    assign rom_addr_little_star = {ascii_char_little_star, char_row_little_star};   // ROM address is ascii code + row
    assign ascii_bit_little_star = rom_data_little_star[~bit_addr_little_star];     // reverse bit order
    
    assign ascii_char_little_star = (pix_x >= 51 && pix_x <= 59) ? 7'h4C :  // 'L'
                        (pix_x >= 59 && pix_x <= 67) ? 7'h49 :  // 'I'
                        (pix_x >= 67  && pix_x <= 75) ? 7'h54 :  // 'T'
                        (pix_x >= 75  && pix_x <= 83) ? 7'h54 :  // 'T'
                        (pix_x >= 83  && pix_x <= 91) ? 7'h4C :  // 'L'
                        (pix_x >= 91  && pix_x <= 99) ? 7'h45 :  // 'E'
                        (pix_x >=99  && pix_x <= 107) ? 7'h20 :  // ' '
                        (pix_x >=107  && pix_x <= 115) ? 7'h53 :  // 'S'
                        (pix_x >=115  && pix_x <= 123) ? 7'h54 :  // 'T'
                        (pix_x >=123  && pix_x <= 131) ? 7'h41 :  // 'A'
                        (pix_x >=131  && pix_x <= 142) ? 7'h52 :  // 'R'
                        7'h20;  // ' '
    
    assign char_row_little_star = pix_y[3:0];               // row number of ascii character rom
    assign bit_addr_little_star = pix_x[2:0];               // column number of ascii character rom
    
    assign ascii_bit_on_little_star = (pix_x >= 51 && pix_x <= 150 && pix_y >= 110 && pix_y <= 127) ? ascii_bit_little_star : 1'b0;

    wire [`ROM_ADDR_ODE_TO_JOY_WIDTH -1:0] rom_addr_ode_to_joy;           // 11-bit text ROM address
    wire [`ASCII_CHAR_ODE_TO_JOY_WIDTH -1:0] ascii_char_ode_to_joy;          // 7-bit ASCII character code
    wire [`CHAR_ROW_ODE_TO_JOY_WIDTH -1:0] char_row_ode_to_joy;            // 4-bit row of ASCII character
    wire [`BIT_ADDR_ODE_TO_JOY_WIDTH -1:0] bit_addr_ode_to_joy;            // column number of ROM data
    wire [`ROM_DATA_ODE_TO_JOY_WIDTH -1:0] rom_data_ode_to_joy;            // 8-bit row data from text ROM
    wire ascii_bit_ode_to_joy, ascii_bit_on_ode_to_joy;     // ROM bit and status signal

    ASCII_ROM ascii_rom_ode_to_joy(
        .clk(vga_clk), 
        .addr(rom_addr_ode_to_joy),
        .data(rom_data_ode_to_joy)
    );

    assign rom_addr_ode_to_joy = {ascii_char_ode_to_joy, char_row_ode_to_joy};   // ROM address is ascii code + row
    assign ascii_bit_ode_to_joy = rom_data_ode_to_joy[~bit_addr_ode_to_joy];     // reverse bit order

    assign ascii_char_ode_to_joy = (pix_x >= 51 && pix_x <= 59) ? 7'h4F :  // 'O'
                        (pix_x >= 59 && pix_x <= 67) ? 7'h44 :  // 'D'
                        (pix_x >= 67  && pix_x <= 75) ? 7'h45 :  // 'E'
                        (pix_x >= 75  && pix_x <= 83) ? 7'h20 :  // ' '
                        (pix_x >= 83  && pix_x <= 91) ? 7'h54 :  // 'T'
                        (pix_x >= 91  && pix_x <= 99) ? 7'h4F :  // 'O'
                        (pix_x >=99  && pix_x <= 107) ? 7'h20 :  // ' '
                        (pix_x >=107  && pix_x <= 115) ? 7'h4A :  // 'J'
                        (pix_x >=115  && pix_x <= 123) ? 7'h4F :  // 'O'
                        (pix_x >=123  && pix_x <= 134) ? 7'h59 :  // 'Y'
                        7'h20;  // ' '

    assign char_row_ode_to_joy = pix_y[3:0];               // row number of ascii character rom
    assign bit_addr_ode_to_joy = pix_x[2:0];               // column number of ascii character rom

    assign ascii_bit_on_ode_to_joy = (pix_x >= 51 && pix_x <= 142 && pix_y >= 110 && pix_y <= 127) ? ascii_bit_ode_to_joy : 1'b0;

    // logic for track number
    always @(*) begin
            if (mode == `AUTO_PLAY_PIXEL_MAPPER) begin
                case (track_number_auto)
                    `LITTLE_STAR_PIXEL_MAPPER: track_number <= `LITTLE_STAR_PIXEL_MAPPER;
                    `TWO_TIGERS_PIXEL_MAPPER: track_number <= `TWO_TIGERS_PIXEL_MAPPER;
                    `ODE_TO_JOY_PIXEL_MAPPER: track_number <= `ODE_TO_JOY_PIXEL_MAPPER;
                endcase
            end
            else if (mode == `LEARNING_PIXEL_MAPPER) begin
                case (track_number_learning)
                    `LITTLE_STAR_PIXEL_MAPPER: track_number <= `LITTLE_STAR_PIXEL_MAPPER;
                    `TWO_TIGERS_PIXEL_MAPPER: track_number <= `TWO_TIGERS_PIXEL_MAPPER;
                    `ODE_TO_JOY_PIXEL_MAPPER: track_number <= `ODE_TO_JOY_PIXEL_MAPPER;
                endcase
            end
            else if (mode == `FREE_MODE_PIXEL_MAPPER) begin
                track_number = 2'd0;
            end    
    end

    wire [`ROM_ADDR_LOW_WIDTH -1:0] rom_addr_low;           // 11-bit text ROM address
    wire [`ASCII_CHAR_LOW_WIDTH -1:0] ascii_char_low;          // 7-bit ASCII character code
    wire [`CHAR_ROW_LOW_WIDTH -1:0] char_row_low;            // 4-bit row of ASCII character
    wire [`BIT_ADDR_LOW_WIDTH -1:0] bit_addr_low;            // column number of ROM data
    wire [`ROM_DATA_LOW_WIDTH -1:0] rom_data_low;            // 8-bit row data from text ROM
    wire ascii_bit_low, ascii_bit_on_low;     // ROM bit and status signal

    ASCII_ROM ascii_rom_low(
        .clk(vga_clk), 
        .addr(rom_addr_low),
        .data(rom_data_low)
    );

    assign rom_addr_low = {ascii_char_low, char_row_low};   // ROM address is ascii code + row
    assign ascii_bit_low = rom_data_low[~bit_addr_low];     // reverse bit order

    assign ascii_char_low = (pix_x >= 51 && pix_x <= 59) ? 7'h4C :  // 'L'
                        (pix_x >= 59 && pix_x <= 67) ? 7'h4F :  // 'O'
                        (pix_x >= 67  && pix_x <= 78) ? 7'h57 :  // 'W'
                        7'h20;  // ' '

    assign char_row_low = pix_y[3:0];               // row number of ascii character rom
    assign bit_addr_low = pix_x[2:0];               // column number of ascii character rom

    assign ascii_bit_on_low = (pix_x >= 51 && pix_x <= 86 && pix_y >= 353 && pix_y <= 369) ? ascii_bit_low : 1'b0;

    wire [`ROM_ADDR_NORMAL_WIDTH -1:0] rom_addr_normal;           // 11-bit text ROM address
    wire [`ASCII_CHAR_NORMAL_WIDTH -1:0] ascii_char_normal;          // 7-bit ASCII character code
    wire [`CHAR_ROW_NORMAL_WIDTH -1:0] char_row_normal;            // 4-bit row of ASCII character
    wire [`BIT_ADDR_NORMAL_WIDTH -1:0] bit_addr_normal;            // column number of ROM data
    wire [`ROM_DATA_NORMAL_WIDTH -1:0] rom_data_normal;            // 8-bit row data from text ROM
    wire ascii_bit_normal, ascii_bit_on_normal;     // ROM bit and status signal

    ASCII_ROM ascii_rom_normal(
        .clk(vga_clk), 
        .addr(rom_addr_normal),
        .data(rom_data_normal)
    );

    assign rom_addr_normal = {ascii_char_normal, char_row_normal};   // ROM address is ascii code + row
    assign ascii_bit_normal = rom_data_normal[~bit_addr_normal];     // reverse bit order

    assign ascii_char_normal = (pix_x >= 51 && pix_x <= 59) ? 7'h4E :  // 'N'
                        (pix_x >= 59 && pix_x <= 67) ? 7'h4F :  // 'O'
                        (pix_x >= 67  && pix_x <= 75) ? 7'h52 :  // 'R'
                        (pix_x >= 75  && pix_x <= 83) ? 7'h4D :  // 'M'
                        (pix_x >= 83  && pix_x <= 91) ? 7'h41 :  // 'A'
                        (pix_x >= 91  && pix_x <= 102) ? 7'h4C :  // 'L'
                        7'h20;  // ' '

    assign char_row_normal = pix_y[3:0];               // row number of ascii character rom
    assign bit_addr_normal = pix_x[2:0];               // column number of ascii character rom

    assign ascii_bit_on_normal = (pix_x >= 51 && pix_x <= 110 && pix_y >= 353 && pix_y <= 369) ? ascii_bit_normal : 1'b0;

    wire [`ROM_ADDR_HIGH_WIDTH -1:0] rom_addr_high;           // 11-bit text ROM address
    wire [`ASCII_CHAR_HIGH_WIDTH -1:0] ascii_char_high;          // 7-bit ASCII character code
    wire [`CHAR_ROW_HIGH_WIDTH -1:0] char_row_high;            // 4-bit row of ASCII character
    wire [`BIT_ADDR_HIGH_WIDTH -1:0] bit_addr_high;            // column number of ROM data
    wire [`ROM_DATA_HIGH_WIDTH -1:0] rom_data_high;            // 8-bit row data from text ROM
    wire ascii_bit_high, ascii_bit_on_high;     // ROM bit and status signal

    ASCII_ROM ascii_rom_high(
        .clk(vga_clk), 
        .addr(rom_addr_high),
        .data(rom_data_high)
    );

    assign rom_addr_high = {ascii_char_high, char_row_high};   // ROM address is ascii code + row
    assign ascii_bit_high = rom_data_high[~bit_addr_high];     // reverse bit order

    assign ascii_char_high = (pix_x >= 51 && pix_x <= 59) ? 7'h48 :  // 'H'
                        (pix_x >= 59 && pix_x <= 67) ? 7'h49 :  // 'I'
                        (pix_x >= 67  && pix_x <= 75) ? 7'h47 :  // 'G'
                        (pix_x >= 75  && pix_x <= 86) ? 7'h48 :  // 'H'
                        7'h20;  // ' '

    assign char_row_high = pix_y[3:0];               // row number of ascii character rom
    assign bit_addr_high = pix_x[2:0];               // column number of ascii character rom

    assign ascii_bit_on_high = (pix_x >= 51 && pix_x <= 94 && pix_y >= 353 && pix_y <= 369) ? ascii_bit_high : 1'b0;

    wire [`ROM_ADDR_1_WIDTH -1:0] rom_addr_1;           // 11-bit text ROM address
    wire [`ASCII_CHAR_1_WIDTH -1:0] ascii_char_1;          // 7-bit ASCII character code
    wire [`CHAR_ROW_1_WIDTH -1:0] char_row_1;            // 4-bit row of ASCII character
    wire [`BIT_ADDR_1_WIDTH -1:0] bit_addr_1;            // column number of ROM data
    wire [`ROM_DATA_1_WIDTH -1:0] rom_data_1;            // 8-bit row data from text ROM
    wire ascii_bit_1, ascii_bit_on_1;     // ROM bit and status signal

    ASCII_ROM ascii_rom_1(
        .clk(vga_clk), 
        .addr(rom_addr_1),
        .data(rom_data_1)
    );

    assign rom_addr_1 = {ascii_char_1, char_row_1};   // ROM address is ascii code + row
    assign ascii_bit_1 = rom_data_1[~bit_addr_1];     // reverse bit order

    assign ascii_char_1 = (pix_x >= 581 && pix_x <= 591) ? 7'h31 :  // '1'
                        7'h20;  // ' '
    
    assign char_row_1 = pix_y[3:0];               // row number of ascii character rom
    assign bit_addr_1 = pix_x[2:0];               // column number of ascii character rom

    assign ascii_bit_on_1 = (pix_x >= 581 && pix_x <= 591 && pix_y >= 353 && pix_y <= 369) ? ascii_bit_1 : 1'b0;

   wire [`ROM_ADDR_2_WIDTH -1:0] rom_addr_2;           // 11-bit text ROM address
   wire [`ASCII_CHAR_2_WIDTH -1:0] ascii_char_2;          // 7-bit ASCII character code    wire [`CHAR_ROW_1_WIDTH -1:0] char_row_1;           
   wire [`CHAR_ROW_2_WIDTH -1:0] char_row_2;            // 4-bit row of ASCII character
   wire [`BIT_ADDR_2_WIDTH -1:0] bit_addr_2;            // column number of ROM data
   wire [`ROM_DATA_2_WIDTH -1:0] rom_data_2;            // 8-bit row data from text ROM
   wire ascii_bit_1, ascii_bit_on_1;     // ROM bit and status signal

    ASCII_ROM ascii_rom_2(
        .clk(vga_clk), 
        .addr(rom_addr_2),
        .data(rom_data_2)
    );

    assign rom_addr_2 = {ascii_char_2, char_row_2};   // ROM address is ascii code + row
    assign ascii_bit_2 = rom_data_2[~bit_addr_2];     // reverse bit order

    assign ascii_char_2 = (pix_x >= 581 && pix_x <= 591) ? 7'h32 :  // '2'
                        7'h20;  // ' '

    assign char_row_2 = pix_y[3:0];               // row number of ascii character rom
    assign bit_addr_2 = pix_x[2:0];               // column number of ascii character rom

    assign ascii_bit_on_2 = (pix_x >= 581 && pix_x <= 591 && pix_y >= 353 && pix_y <= 369) ? ascii_bit_2 : 1'b0;

    wire [`ROM_ADDR_3_WIDTH -1:0] rom_addr_3;           // 11-bit text ROM address
    wire [`ASCII_CHAR_3_WIDTH -1:0] ascii_char_3;          // 7-bit ASCII character code
    wire [`CHAR_ROW_3_WIDTH -1:0] char_row_3;            // 4-bit row of ASCII character
    wire [`BIT_ADDR_3_WIDTH -1:0] bit_addr_3;            // column number of ROM data
    wire [`ROM_DATA_3_WIDTH -1:0] rom_data_3;            // 8-bit row data from text ROM
    wire ascii_bit_1, ascii_bit_on_1;     // ROM bit and status signal

    ASCII_ROM ascii_rom_3(
        .clk(vga_clk), 
        .addr(rom_addr_3),
        .data(rom_data_3)
    );

    assign rom_addr_3 = {ascii_char_3, char_row_3};   // ROM address is ascii code + row
    assign ascii_bit_3 = rom_data_3[~bit_addr_3];     // reverse bit order

    assign ascii_char_3 = (pix_x >= 581 && pix_x <= 591) ? 7'h33 :  // '3'
                        7'h20;  // ' '

    assign char_row_3 = pix_y[3:0];               // row number of ascii character rom
    assign bit_addr_3 = pix_x[2:0];               // column number of ascii character rom

    assign ascii_bit_on_3 = (pix_x >= 581 && pix_x <= 591 && pix_y >= 353 && pix_y <= 369) ? ascii_bit_3 : 1'b0;

    wire [`ROM_ADDR_4_WIDTH -1:0] rom_addr_4;           // 11-bit text ROM address
    wire [`ASCII_CHAR_4_WIDTH -1:0] ascii_char_4;          // 7-bit ASCII character code
    wire [`CHAR_ROW_4_WIDTH -1:0] char_row_4;            // 4-bit row of ASCII character
    wire [`BIT_ADDR_4_WIDTH -1:0] bit_addr_4;            // column number of ROM data
    wire [`ROM_DATA_4_WIDTH -1:0] rom_data_4;            // 8-bit row data from text ROM
    wire ascii_bit_1, ascii_bit_on_1;     // ROM bit and status signal

    ASCII_ROM ascii_rom_4(
        .clk(vga_clk), 
        .addr(rom_addr_4),
        .data(rom_data_4)
    );

    assign rom_addr_4 = {ascii_char_4, char_row_4};   // ROM address is ascii code + row
    assign ascii_bit_4 = rom_data_4[~bit_addr_4];     // reverse bit order

    assign ascii_char_4 = (pix_x >= 581 && pix_x <= 591) ? 7'h34 :  // '4'
                        7'h20;  // ' '

    assign char_row_4 = pix_y[3:0];               // row number of ascii character rom
    assign bit_addr_4 = pix_x[2:0];               // column number of ascii character rom

    assign ascii_bit_on_4 = (pix_x >= 581 && pix_x <= 591 && pix_y >= 353 && pix_y <= 369) ? ascii_bit_4 : 1'b0;

    wire [`ROM_ADDR_5_WIDTH -1:0] rom_addr_5;           // 11-bit text ROM address
    wire [`ASCII_CHAR_5_WIDTH -1:0] ascii_char_5;          // 7-bit ASCII character code
    wire [`CHAR_ROW_5_WIDTH -1:0] char_row_5;            // 4-bit row of ASCII character
    wire [`BIT_ADDR_5_WIDTH -1:0] bit_addr_5;            // column number of ROM data
    wire [`ROM_DATA_5_WIDTH -1:0] rom_data_5;            // 8-bit row data from text ROM
    wire ascii_bit_1, ascii_bit_on_1;     // ROM bit and status signal

    ASCII_ROM ascii_rom_5(
        .clk(vga_clk), 
        .addr(rom_addr_5),
        .data(rom_data_5)
    );

    assign rom_addr_5 = {ascii_char_5, char_row_5};   // ROM address is ascii code + row
    assign ascii_bit_5 = rom_data_5[~bit_addr_5];     // reverse bit order

    assign ascii_char_5 = (pix_x >= 581 && pix_x <= 591) ? 7'h35 :  // '5'
                        7'h20;  // ' '
    
    assign char_row_5 = pix_y[3:0];               // row number of ascii character rom
    assign bit_addr_5 = pix_x[2:0];               // column number of ascii character rom

    assign ascii_bit_on_5 = (pix_x >= 581 && pix_x <= 591 && pix_y >= 353 && pix_y <= 369) ? ascii_bit_5 : 1'b0;

    wire [`ROM_ADDR_6_WIDTH -1:0] rom_addr_6;           // 11-bit text ROM address
    wire [`ASCII_CHAR_6_WIDTH -1:0] ascii_char_6;          // 7-bit ASCII character code
    wire [`CHAR_ROW_6_WIDTH -1:0] char_row_6;            // 4-bit row of ASCII character
    wire [`BIT_ADDR_6_WIDTH -1:0] bit_addr_6;            // column number of ROM data
    wire [`ROM_DATA_6_WIDTH -1:0] rom_data_6;            // 8-bit row data from text ROM
    wire ascii_bit_1, ascii_bit_on_1;     // ROM bit and status signal

    ASCII_ROM ascii_rom_6(
        .clk(vga_clk), 
        .addr(rom_addr_6),
        .data(rom_data_6)
    );

    assign rom_addr_6 = {ascii_char_6, char_row_6};   // ROM address is ascii code + row
    assign ascii_bit_6 = rom_data_6[~bit_addr_6];     // reverse bit order

    assign ascii_char_6 = (pix_x >= 581 && pix_x <= 591) ? 7'h36 :  // '6'
                        7'h20;  // ' '

    assign char_row_6 = pix_y[3:0];               // row number of ascii character rom
    assign bit_addr_6 = pix_x[2:0];               // column number of ascii character rom

    assign ascii_bit_on_6 = (pix_x >= 581 && pix_x <= 591 && pix_y >= 353 && pix_y <= 369) ? ascii_bit_6 : 1'b0;

   wire [`ROM_ADDR_7_WIDTH -1:0] rom_addr_7;           // 11-bit text ROM address
   wire [`ASCII_CHAR_7_WIDTH -1:0] ascii_char_7;          // 7-bit ASCII character code
   wire [`CHAR_ROW_7_WIDTH -1:0] char_row_7;            // 4-bit row of ASCII character
   wire [`BIT_ADDR_7_WIDTH -1:0] bit_addr_7;            // column number of ROM data
   wire [`ROM_DATA_7_WIDTH -1:0] rom_data_7;            // 8-bit row data from text ROM
   wire ascii_bit_1, ascii_bit_on_1;     // ROM bit and status signal
       
    ASCII_ROM ascii_rom_7(
        .clk(vga_clk), 
        .addr(rom_addr_7),
        .data(rom_data_7)
    );

    assign rom_addr_7 = {ascii_char_7, char_row_7};   // ROM address is ascii code + row
    assign ascii_bit_7 = rom_data_7[~bit_addr_7];     // reverse bit order

    assign ascii_char_7 = (pix_x >= 581 && pix_x <= 591) ? 7'h37 :  // '7'
                        7'h20;  // ' '

    assign char_row_7 = pix_y[3:0];               // row number of ascii character rom
    assign bit_addr_7 = pix_x[2:0];               // column number of ascii character rom

    assign ascii_bit_on_7 = (pix_x >= 581 && pix_x <= 591 && pix_y >= 353 && pix_y <= 369) ? ascii_bit_7 : 1'b0;

   wire [`ROM_ADDR_8_WIDTH -1:0] rom_addr_8;           // 11-bit text ROM address
   wire [`ASCII_CHAR_8_WIDTH -1:0] ascii_char_8;          // 7-bit ASCII character code
   wire [`CHAR_ROW_8_WIDTH -1:0] char_row_8;            // 4-bit row of ASCII character
   wire [`BIT_ADDR_8_WIDTH -1:0] bit_addr_8;            // column number of ROM data
   wire [`ROM_DATA_8_WIDTH -1:0] rom_data_8;            // 8-bit row data from text ROM
   wire ascii_bit_1, ascii_bit_on_1;     // ROM bit and status signal
    ASCII_ROM ascii_rom_8(
        .clk(vga_clk), 
        .addr(rom_addr_8),
        .data(rom_data_8)
    );

    assign rom_addr_8 = {ascii_char_8, char_row_8};   // ROM address is ascii code + row
    assign ascii_bit_8 = rom_data_8[~bit_addr_8];     // reverse bit order

    assign ascii_char_8 = (pix_x >= 581 && pix_x <= 591) ? 7'h38 :  // '8'
                        7'h20;  // ' '

    assign char_row_8 = pix_y[3:0];               // row number of ascii character rom
    assign bit_addr_8 = pix_x[2:0];               // column number of ascii character rom

    assign ascii_bit_on_8 = (pix_x >= 581 && pix_x <= 591 && pix_y >= 353 && pix_y <= 369) ? ascii_bit_8 : 1'b0;

    wire [`ROM_ADDR_SMILEY_FACE_WIDTH -1:0] rom_addr_smiley_face;           // 11-bit text ROM address
    wire [`ASCII_CHAR_SMILEY_FACE_WIDTH -1:0] ascii_char_smiley_face;          // 7-bit ASCII character code
    wire [`CHAR_ROW_SMILEY_FACE_WIDTH -1:0] char_row_smiley_face;            // 4-bit row of ASCII character
    wire [`BIT_ADDR_SMILEY_FACE_WIDTH -1:0] bit_addr_smiley_face;            // column number of ROM data
    wire [`ROM_DATA_SMILEY_FACE_WIDTH -1:0] rom_data_smiley_face;            // 8-bit row data from text ROM
    wire ascii_bit_smiley_face, ascii_bit_on_smiley_face;     // ROM bit and status signal

    ASCII_ROM ascii_rom_smiley_face(
        .clk(vga_clk), 
        .addr(rom_addr_smiley_face),
        .data(rom_data_smiley_face)
    );

    assign rom_addr_smiley_face = {ascii_char_smiley_face, char_row_smiley_face};   // ROM address is ascii code + row
    assign ascii_bit_smiley_face = rom_data_smiley_face[~bit_addr_smiley_face];     // reverse bit order

    assign ascii_char_smiley_face = (pix_x >= 310 && pix_x <= 328) ? 7'h01 :  // '?'
                        7'h20;  // ' '

    assign char_row_smiley_face = pix_y[3:0];               // row number of ascii character rom
    assign bit_addr_smiley_face = pix_x[2:0];               // column number of ascii character rom

    assign ascii_bit_on_smiley_face = (pix_x >= 310 && pix_x <= 328 && pix_y >= 110 && pix_y <= 127) ? ascii_bit_smiley_face : 1'b0;

    // state machine for key light
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= `LIGHT_OFF;
            key_on <= 1'b0;
        end
        else begin
            case (state)
                `LIGHT_OFF:
                    begin
                        if (key_on_in) begin
                            state <= `LIGHT_ON;
                        end
                        else
                            state <= `LIGHT_OFF;
                    end
                `LIGHT_ON:
                    begin
                        key_on <= 1'b1;
                        if (key_off_in) begin
                            key_on <= 1'b0;
                            state <= `LIGHT_OFF;
                        end
                        else
                            state <= `LIGHT_ON;
                    end
                default:
                    state <= `LIGHT_OFF;
            endcase
        end    
    end

    always @(posedge vga_clk or negedge rst_n) begin
        if (~rst_n) begin
            pix_data <= `BLACK;
        end 
        else begin
            if (mode == `AUTO_PLAY_PIXEL_MAPPER || mode == `LEARNING_PIXEL_MAPPER) begin
                // key 1 - 1
                if (pix_x > 10'd66 && pix_x <= 10'd121 && pix_y > 10'd160 && pix_y < 10'd320) begin
                    if (note_in == 6'd1) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 1 - 2
                else if (pix_x > 10'd121 && pix_x < 10'd136 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (note_in == 6'd1) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end
            
                // key 2 - 1
                else if (pix_x >= 10'd139 && pix_x < 10'd154 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (note_in == 6'd2) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 2 - 2    
                else if (pix_x >= 10'd154 && pix_x < 10'd194 && pix_y > 10'd160 && pix_y < 10'd320) begin
                    if (note_in == 6'd2) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                    end

                // key 2 - 3    
                else if (pix_x >= 10'd194 && pix_x < 10'd209 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (note_in == 6'd2) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 3 - 1
                else if (pix_x > 10'd212 && pix_x <= 10'd227 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (note_in == 6'd3) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 3 - 2
                else if (pix_x > 10'd227 && pix_x < 10'd282 && pix_y > 10'd160 && pix_y < 10'd320) begin
                    if (note_in == 6'd3) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end
            
                // key 4 - 1
                else if (pix_x > 10'd285 && pix_x <= 10'd340 && pix_y > 10'd160 && pix_y < 10'd320) begin
                    if (note_in == 6'd4) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 4 - 2
                else if (pix_x > 10'd340 && pix_x < 10'd355 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (note_in == 6'd4) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 5 - 1
                else if (pix_x >= 10'd358 && pix_x < 10'd373 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (note_in == 6'd5) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 5 - 2
                else if (pix_x >= 10'd373 && pix_x < 10'd413 && pix_y > 10'd160 && pix_y < 10'd320) begin
                    if (note_in == 6'd5) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 5 - 3
                else if (pix_x >= 10'd413 && pix_x < 10'd428 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (note_in == 6'd5) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 6 - 1
                else if (pix_x >= 10'd431 && pix_x < 10'd446 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (note_in == 6'd6) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end
            
                // key 6 - 2
                else if (pix_x >= 10'd446 && pix_x < 10'd486 && pix_y > 10'd160 && pix_y < 10'd320) begin
                    if (note_in == 6'd6) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end
            
                // key 6 - 3
                else if (pix_x >= 10'd486 && pix_x < 10'd501 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (note_in == 6'd6) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end
    
                // key 7 - 1
                else if (pix_x > 10'd504 && pix_x < 10'd519 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (note_in == 6'd7) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end
        
                // key 7 - 2
                else if (pix_x >= 10'd519 && pix_x < 10'd574 && pix_y > 10'd160 && pix_y < 10'd320) begin
                    if (note_in == 6'd7) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end
                
                // mode indicator
                else if (pix_x >= 10'd572 && pix_x <= 10'd589 && pix_y >= 10'd110 && pix_y <= 10'd127) begin
                    case (mode)
                        `AUTO_PLAY_PIXEL_MAPPER: pix_data <= `MAGENTA;
                        `LEARNING_PIXEL_MAPPER: pix_data <= `GREEN;
                    endcase
                end

                // left border
                else if (pix_x >= 10'd51 && pix_x <= 10'd55 && pix_y >= 10'd150 && pix_y <= 10'd330) begin
                    if (mode == `LEARNING_PIXEL_MAPPER && (reaction_rate == 8'b00000001 || reaction_rate == 8'b00000011 || reaction_rate == 8'b00000111 || reaction_rate == 8'b00001111 || reaction_rate == 8'b00011111 || reaction_rate == 8'b00111111 || reaction_rate == 8'b01111111 || reaction_rate == 8'b11111111))
                        pix_data <= `GREEN;
                    else
                        pix_data <= `WHITE;
                end
                        
                // right border
                else if (pix_x >= 10'd585 && pix_x <= 10'd589 && pix_y >= 10'd150 && pix_y <= 10'd330) begin
                    if (mode == `LEARNING_PIXEL_MAPPER && (reaction_rate == 8'b00000001 || reaction_rate == 8'b00000011 || reaction_rate == 8'b00000111 || reaction_rate == 8'b00001111 || reaction_rate == 8'b00011111 || reaction_rate == 8'b00111111 || reaction_rate == 8'b01111111 || reaction_rate == 8'b11111111))
                        pix_data <= `GREEN;
                    else
                        pix_data <= `WHITE;
                end
            
                // top border
                else if (pix_x >= 10'd51 && pix_x <= 10'd589 && pix_y >= 10'd145 && pix_y <= 10'd149) begin
                    if (mode == `LEARNING_PIXEL_MAPPER && (reaction_rate == 8'b00000001 || reaction_rate == 8'b00000011 || reaction_rate == 8'b00000111 || reaction_rate == 8'b00001111 || reaction_rate == 8'b00011111 || reaction_rate == 8'b00111111 || reaction_rate == 8'b01111111 || reaction_rate == 8'b11111111))
                        pix_data <= `GREEN;
                    else
                        pix_data <= `WHITE;
                end
            
                // bottom border
                else if (pix_x >= 10'd51 && pix_x <= 10'd589 && pix_y >= 10'd331 && pix_y <= 10'd335) begin
                    if (mode == `LEARNING_PIXEL_MAPPER && (reaction_rate == 8'b00000001 || reaction_rate == 8'b00000011 || reaction_rate == 8'b00000111 || reaction_rate == 8'b00001111 || reaction_rate == 8'b00011111 || reaction_rate == 8'b00111111 || reaction_rate == 8'b01111111 || reaction_rate == 8'b11111111))
                        pix_data <= `GREEN;
                    else
                        pix_data <= `WHITE;
                end

                // track title
                else if (track_number == `LITTLE_STAR_PIXEL_MAPPER && ascii_bit_on_little_star) begin
                    pix_data <= `WHITE;
                end   
                else if (track_number == `TWO_TIGERS_PIXEL_MAPPER && ascii_bit_on_two_tigers) begin
                    pix_data <= `WHITE;
                end

                else if (track_number == `ODE_TO_JOY_PIXEL_MAPPER && ascii_bit_on_ode_to_joy) begin
                    pix_data <= `WHITE;
                end

                // octave indicator
                else if (current_octave == `LOW_PIXEL_MAPPER && ascii_bit_on_low) begin
                    pix_data <= `WHITE;
                end  
                 
                else if (current_octave == `NORMAL_PIXEL_MAPPER && ascii_bit_on_normal) begin
                    pix_data <= `WHITE;
                end

                else if (current_octave == `HIGH_PIXEL_MAPPER && ascii_bit_on_high) begin
                    pix_data <= `WHITE;
                end

                // rating indicator
                else if (mode == `LEARNING_PIXEL_MAPPER && reaction_rate == 8'b00000001 && ascii_bit_on_1) begin
                    pix_data <= `WHITE;
                end

                else if (mode == `LEARNING_PIXEL_MAPPER && reaction_rate == 8'b00000011 && ascii_bit_on_2) begin
                    pix_data <= `WHITE;
                end

                else if (mode == `LEARNING_PIXEL_MAPPER && reaction_rate == 8'b00000111 && ascii_bit_on_3) begin
                    pix_data <= `WHITE;
                end

                else if (mode == `LEARNING_PIXEL_MAPPER && reaction_rate == 8'b00001111 && ascii_bit_on_4) begin
                    pix_data <= `WHITE;
                end

                else if (mode == `LEARNING_PIXEL_MAPPER && reaction_rate == 8'b00011111 && ascii_bit_on_5) begin
                    pix_data <= `WHITE;
                end

                else if (mode == `LEARNING_PIXEL_MAPPER && reaction_rate == 8'b00111111 && ascii_bit_on_6) begin
                    pix_data <= `WHITE;
                end

                else if (mode == `LEARNING_PIXEL_MAPPER && reaction_rate == 8'b01111111 && ascii_bit_on_7) begin
                    pix_data <= `WHITE;
                end

                else if (mode == `LEARNING_PIXEL_MAPPER && reaction_rate == 8'b11111111 && ascii_bit_on_8) begin
                    pix_data <= `WHITE;
                end

                // complete a song indicator
                else if (mode == `LEARNING_PIXEL_MAPPER && finish && ascii_bit_on_smiley_face) begin
                    pix_data <= `WHITE;
                end

                // background
                else begin
                    pix_data <= `BLACK;  
                end
            end
            
            else if (mode == `FREE_MODE_PIXEL_MAPPER) begin
                // key 1 - 1
                if (pix_x > 10'd66 && pix_x <= 10'd121 && pix_y > 10'd160 && pix_y < 10'd320) begin
                    if (key_on && selected_note == 6'd1) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 1 - 2
                else if (pix_x > 10'd121 && pix_x < 10'd136 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (key_on && selected_note == 6'd1) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end
            
                // key 2 - 1
                else if (pix_x >= 10'd139 && pix_x < 10'd154 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (key_on && selected_note == 6'd2) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 2 - 2    
                else if (pix_x >= 10'd154 && pix_x < 10'd194 && pix_y > 10'd160 && pix_y < 10'd320) begin
                    if (key_on && selected_note == 6'd2) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 2 - 3    
                else if (pix_x >= 10'd194 && pix_x < 10'd209 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (key_on && selected_note == 6'd2) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 3 - 1
                else if (pix_x > 10'd212 && pix_x <= 10'd227 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (key_on && selected_note == 6'd3) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 3 - 2
                else if (pix_x > 10'd227 && pix_x < 10'd282 && pix_y > 10'd160 && pix_y < 10'd320) begin
                    if (key_on && selected_note == 6'd3) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end
            
                // key 4 - 1
                else if (pix_x > 10'd285 && pix_x <= 10'd340 && pix_y > 10'd160 && pix_y < 10'd320) begin
                    if (key_on && selected_note == 6'd4) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 4 - 2
                else if (pix_x > 10'd340 && pix_x < 10'd355 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (key_on && selected_note == 6'd4) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 5 - 1
                else if (pix_x >= 10'd358 && pix_x < 10'd373 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (key_on && selected_note == 6'd5) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 5 - 2
                else if (pix_x >= 10'd373 && pix_x < 10'd413 && pix_y > 10'd160 && pix_y < 10'd320) begin
                    if (key_on && selected_note == 6'd5) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 5 - 3
                else if (pix_x >= 10'd413 && pix_x < 10'd428 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (key_on && selected_note == 6'd5) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // key 6 - 1
                else if (pix_x >= 10'd431 && pix_x < 10'd446 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (key_on && selected_note == 6'd6) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end
            
                // key 6 - 2
                else if (pix_x >= 10'd446 && pix_x < 10'd486 && pix_y > 10'd160 && pix_y < 10'd320) begin
                    if (key_on && selected_note == 6'd6) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end
            
                // key 6 - 3
                else if (pix_x >= 10'd486 && pix_x < 10'd501 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (key_on && selected_note == 6'd6) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end
    
                // key 7 - 1
                else if (pix_x > 10'd504 && pix_x < 10'd519 && pix_y > 10'd240 && pix_y < 10'd320) begin
                    if (key_on && selected_note == 6'd7) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end
        
                // key 7 - 2
                else if (pix_x >= 10'd519 && pix_x < 10'd574 && pix_y > 10'd160 && pix_y < 10'd320) begin
                    if (key_on && selected_note == 6'd7) 
                        pix_data <= key_color;
                    else
                        pix_data <= `WHITE;
                end

                // left border
                else if (pix_x >= 10'd51 && pix_x <= 10'd55 && pix_y >= 10'd150 && pix_y <= 10'd330) begin
                    pix_data <= `WHITE;
                end
                        
                // right border
                else if (pix_x >= 10'd585 && pix_x <= 10'd589 && pix_y >= 10'd150 && pix_y <= 10'd330) begin
                    pix_data <=`WHITE;
                end
            
                // top border
                else if (pix_x >= 10'd51 && pix_x <= 10'd589 && pix_y >= 10'd145 && pix_y <= 10'd149) begin
                    pix_data <= `WHITE;
                end
            
                // bottom border
                else if (pix_x >= 10'd51 && pix_x <= 10'd589 && pix_y >= 10'd331 && pix_y <= 10'd335) begin
                    pix_data <= `WHITE;
                end

                // octave indicator
                else if (current_octave == `LOW_PIXEL_MAPPER && ascii_bit_on_low) begin
                    pix_data <= `WHITE;
                end  

                else if (current_octave == `NORMAL_PIXEL_MAPPER && ascii_bit_on_normal) begin
                    pix_data <= `WHITE;
                end

                else if (current_octave == `HIGH_PIXEL_MAPPER && ascii_bit_on_high) begin
                    pix_data <= `WHITE;
                end

                // mode indicator
                else if (pix_x >= 10'd572 && pix_x <= 10'd589 && pix_y >= 10'd110 && pix_y <= 10'd127) begin
                    pix_data <= `BLUE;
                end

                // background
                else begin
                    pix_data <= `BLACK;  
                end
            end
        end
    end

endmodule
