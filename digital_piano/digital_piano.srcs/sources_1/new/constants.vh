`define FREE_MODE         0
`define AUTO_MODE         1
`define LEARNING_MODE     2 

`define NOTE_A_WIDTH         6  
`define NOTE_B_WIDTH         6 
`define NOTE_C_WIDTH         6
`define KEY_ON_OUT_WIDTH     1
`define KEY_OFF_OUT_WIDTH    1
`define NOTE_WIDTH           6 
`define NOTE_OUT_WIDTH       6  
`define NOTE_INPUT_WIDTH     6  
`define NOTE_CURRENT_WIDTH   6  
`define KEY_NOTES_WIDTH      7

`define CURRENT_STATE_WIDTH         2
`define OUTPUTCOUNT_WIDTH           32
`define FREQUENCY_DIVIDER_COUNT     28

`define KEY_NOTES_WIDTH         7
`define NOTE_OUT_WIDTH          6
`define KEY_ON_WIDTH            7
`define KEY_OFF_WIDTH           7
`define SEG_WIDTH               8
`define SONG_NUM_WIDTH          2 
`define SONGNM                  2'b00
`define SPEED_WIDTH             2
`define SPEED                   2'b10
`define SONG_BCD_CODE_WIDTH     4
`define REACTION_RATE_WIDTH     8

`define SLOW_CLK_INIT_VALUE    1'b0
`define COUNTER_INIT_VALUE     28'd0
`define FREQUENCY_DIVIDER      50000

`define OUTPUTCOUNT_INIT_VALUE   32'd0
`define OUTPUT_INCR              32'd1

`define LIGHT_WIDTH                7
`define KEY_NOTES_WIDTH            7
`define INDEX_WIDTH                 10
`define DUMMY_WIRE_WIDTH           4
`define BCD_WIDTH                  4
`define TUB_CONTROL_B              8
`define TUB_CONTROL_C              8
`define TUB_CONTROL                8 
`define MODE_MODE_SELECTOR_WIDTH   2
`define TUB_CONTROL_USER           8

`define LITTLE_STAR_MODE      0
`define LITTLE_STAR   288'b000001_000001_000010_000010_000011_000011_000100_000100_000101_000101_000110_000110_000101_000101_000001_000001_000010_000010_000011_000011_000100_000100_000101_000101_000010_000010_000011_000011_000100_000100_000101_000101_000001_000001_000010_000010_000011_000011_000100_000100_000101_000101_000110_000110_000101_000101_000001_000001    
`define TWO_TIGERS_MODE       1
`define TWO_TIGERS  216'b000001_000001_001100_000011_000001_000001_001100_000011_000001_000011_000100_000101_000110_000101_000001_000011_000100_000101_000110_000101_000101_000101_000100_000011_000101_000101_000100_000011_000001_000011_000010_000001_000001_000011_000010_000001
`define LITTLE_STAR_LENGTH    47
`define TWO_TIGERS_LENGTH     36
`define ODE_TO_JOY_MODE       2 
`define ODE_TO_JOY 180'b000001_000001_000010_000011_000010_000001_000001_000010_000011_000100_000101_000101_000100_000011_000011_000010_000010_000011_000011_000010_000001_000001_000010_000011_000100_000101_000101_000100_000011_000011
`define ODE_TO_JOY_LENGTH     30
`define SONG_MODE_WIDTH       2
`define NOTE_SEQUENCE_WIDTH   301

`define MAX_COUNT 1_000_000 - 1 
`define KEY_COUNTER_WIDTH       32
`define STATE_WIDTH             2
`define KEY_COUNTER_INIT_STATE  32'd0

`define SLOW_MODE                0
`define SLOW                     40000000
`define SLOW_IDLE                10000000
`define NORMAL_MODE              1
`define NORMAL                   20000000
`define NORMAL_IDLE              5000000
`define FAST_MODE                2
`define FAST                     10000000 
`define FAST_IDLE                2500000
`define COUNT_WIDTH              32
`define MAX_COUNT_WIDTH          32
`define COUNTER_MAX_WIDTH        32
`define MAX_IDLE_COUNT_WIDTH     32
`define SPEED_MODE_WIDTH         2

`define BUZZER_NOTE_IN_WIDTH    6
`define OCTAVE_LOW              2'b00
`define OCTAVE_NORMAL           2'b01
`define OCTAVE_HIGH             2'b10
`define CURRENT_OCTAVE_WIDTH    2

`define NOTES_WIDTH     32
`define NOTES_SIZE      22
`define MODE_WIDTH      2

`define BUZZER_NOTE_0   32'd1650065408
`define BUZZER_NOTE_1   32'd93941
`define BUZZER_NOTE_2   32'd85136
`define BUZZER_NOTE_3   32'd75838
`define BUZZER_NOTE_4   32'd71582
`define BUZZER_NOTE_5   32'd63776
`define BUZZER_NOTE_6   32'd56818
`define BUZZER_NOTE_7   32'd50618
`define BUZZER_NOTE_8   32'd191110
`define BUZZER_NOTE_9   32'd170259
`define BUZZER_NOTE_10  32'd151685
`define BUZZER_NOTE_11  32'd143172
`define BUZZER_NOTE_12  32'd127554
`define BUZZER_NOTE_13  32'd113636
`define BUZZER_NOTE_14  32'd101239
`define BUZZER_NOTE_15  32'd47778
`define BUZZER_NOTE_16  32'd42567
`define BUZZER_NOTE_17  32'd37921
`define BUZZER_NOTE_18  32'd36498
`define BUZZER_NOTE_19  32'd31888
`define BUZZER_NOTE_20  32'd28409
`define BUZZER_NOTE_21  32'd25309

//VGA
`define PIX_DATA_WIDTH   12
`define PIX_X_WIDTH      10
`define PIX_Y_WIDTH      10
`define VGA_RGB_WIDTH    12
`define H_SYNC           10'd96
`define H_BACK           10'd40
`define H_LEFT           10'd8
`define H_VALID          10'd640
`define H_RIGHT          10'd8
`define H_FRONT          10'd8
`define H_TOTAL          10'd800
`define V_SYNC           10'd2  
`define V_BACK           10'd25
`define V_TOP            10'd8
`define V_VALID          10'd480
`define V_BOTTOM         10'd8
`define V_FRONT          10'd2
`define V_TOTAL          10'd525

`define COUNTER_H_WIDTH  10
`define COUNTER_V_WIDTH  10

`define ADDR_WIDTH                11
`define DATA_WIDTH                8
`define ADDR_REG_WIDTH            11
`define MODE_WIDTH                2
`define NOTE_IN_WIDTH             6
`define SELECTED_NOTE_WIDTH       6
`define TRACK_NUM_AUTO_WIDTH      2
`define TRACK_NUM_LEARNING_WIDTH  2
`define STATE_WIDTH               2
`define KEY_COLOR_WIDTH           12

`define BLUE        12'hF80
`define GREEN       12'b0000_1101_0011
`define ORANGE      12'h07F
`define RED         12'h01F
`define BLACK       12'h000
`define WHITE       12'hFFF
`define PURPLE      12'hD69
`define MAGENTA     12'hF0F
             
`define FREE_MODE_PIXEL_MAPPER       2'd1
`define AUTO_PLAY_PIXEL_MAPPER       2'd0
`define LEARNING_PIXEL_MAPPER         2'd2
`define LITTLE_STAR_PIXEL_MAPPER       0
`define TWO_TIGERS_PIXEL_MAPPER      1   
`define ODE_TO_JOY_PIXEL_MAPPER       2 
`define LOW_PIXEL_MAPPER                    2'b00
`define NORMAL_PIXEL_MAPPER            2'b01
`define HIGH_PIXEL_MAPPER                   2'b10
`define STATE_PIXEL_MAPPER_WIDTH    2

`define LIGHT_OFF   2'd01
`define LIGHT_ON    2'd10
 
`define ROM_ADDR_TWO_TIGERS_WIDTH       11
`define ASCII_CHAR_TWO_TIGERS_WIDTH     7
`define CHAR_ROW_TWO_TIGERS_WIDTH       4 
`define BIT_ADDR_TWO_TIGERS_WIDTH       3
`define ROM_DATA_TWO_TIGERS_WIDTH       8        

`define ROM_ADDR_LITTLE_STAR_WIDTH      11
`define ASCII_CHAR_LITTLE_STAR_WIDTH    7
`define CHAR_ROW_LITTLE_STAR_WIDTH      4 
`define BIT_ADDR_LITTLE_STAR_WIDTH      3
`define ROM_DATA_LITTLE_STAR_WIDTH      8 

`define ROM_ADDR_ODE_TO_JOY_WIDTH       11
`define ASCII_CHAR_ODE_TO_JOY_WIDTH     7
`define CHAR_ROW_ODE_TO_JOY_WIDTH       4 
`define BIT_ADDR_ODE_TO_JOY_WIDTH       3
`define ROM_DATA_ODE_TO_JOY_WIDTH       8 

`define ROM_ADDR_LOW_WIDTH         11
`define ASCII_CHAR_LOW_WIDTH       7
`define CHAR_ROW_LOW_WIDTH         4 
`define BIT_ADDR_LOW_WIDTH         3
`define ROM_DATA_LOW_WIDTH         8 

`define ROM_ADDR_NORMAL_WIDTH      11
`define ASCII_CHAR_NORMAL_WIDTH    7
`define CHAR_ROW_NORMAL_WIDTH      4 
`define BIT_ADDR_NORMAL_WIDTH      3
`define ROM_DATA_NORMAL_WIDTH      8 

`define ROM_ADDR_HIGH_WIDTH        11
`define ASCII_CHAR_HIGH_WIDTH      7
`define CHAR_ROW_HIGH_WIDTH        4 
`define BIT_ADDR_HIGH_WIDTH        3
`define ROM_DATA_HIGH_WIDTH        8

`define ROM_ADDR_1_WIDTH       11
`define ASCII_CHAR_1_WIDTH     7
`define CHAR_ROW_1_WIDTH       4 
`define BIT_ADDR_1_WIDTH       3
`define ROM_DATA_1_WIDTH       8

`define ROM_ADDR_2_WIDTH       11
`define ASCII_CHAR_2_WIDTH     7
`define CHAR_ROW_2_WIDTH       4 
`define BIT_ADDR_2_WIDTH       3
`define ROM_DATA_2_WIDTH       8

`define ROM_ADDR_3_WIDTH       11
`define ASCII_CHAR_3_WIDTH     7
`define CHAR_ROW_3_WIDTH       4 
`define BIT_ADDR_3_WIDTH       3
`define ROM_DATA_3_WIDTH       8

`define ROM_ADDR_4_WIDTH       11
`define ASCII_CHAR_4_WIDTH     7
`define CHAR_ROW_4_WIDTH       4 
`define BIT_ADDR_4_WIDTH       3
`define ROM_DATA_4_WIDTH       8

`define ROM_ADDR_5_WIDTH       11
`define ASCII_CHAR_5_WIDTH     7
`define CHAR_ROW_5_WIDTH       4 
`define BIT_ADDR_5_WIDTH       3
`define ROM_DATA_5_WIDTH       8

`define ROM_ADDR_6_WIDTH       11
`define ASCII_CHAR_6_WIDTH     7
`define CHAR_ROW_6_WIDTH       4 
`define BIT_ADDR_6_WIDTH       3
`define ROM_DATA_6_WIDTH       8

`define ROM_ADDR_7_WIDTH       11
`define ASCII_CHAR_7_WIDTH     7
`define CHAR_ROW_7_WIDTH       4 
`define BIT_ADDR_7_WIDTH       3
`define ROM_DATA_7_WIDTH       8

`define ROM_ADDR_8_WIDTH       11
`define ASCII_CHAR_8_WIDTH     7
`define CHAR_ROW_8_WIDTH       4 
`define BIT_ADDR_8_WIDTH       3
`define ROM_DATA_8_WIDTH       8

`define ROM_ADDR_SMILEY_FACE_WIDTH       11
`define ASCII_CHAR_SMILEY_FACE_WIDTH     7
`define CHAR_ROW_SMILEY_FACE_WIDTH       4 
`define BIT_ADDR_SMILEY_FACE_WIDTH       3
`define ROM_DATA_SMILEY_FACE_WIDTH       8

`define IDLE_BUZZER  1'b0
`define BUZZ_BUZZER  1'b1
 
`define IDLE  1'b0
`define SET   1'b1

`define IDLE_KEY        2'b00
`define FILTER0_KEY     2'b01
`define DOWN_KEY        2'b10
`define FILTER1_KEY     2'b11

`define TRACK_NUM_LEARNING_WIDTH    2 
`define NEW_RECORD_WIDTH            4
`define TUB_CONTROL_USER            8
`define CURRENT_RECORD_WIDTH        4
`define CURRENT_USER_WIDTH          2
`define RECORD123_WIDTH             4
`define STATE_SCORE_WIDTH           3
`define MISTAKES_WIDTH              9
`define STATE_REACTION_RATING_WIDTH 3

`define COUNT1           560000000
`define COUNT2           60000000
`define COUNT2_GREATER   20000000
`define COUNT_DIFF_12_1  20000000
`define COUNT_DIFF_12_2  80000000 
`define COUNT_DIFF_12_3  140000000
`define COUNT_DIFF_12_4  250000000
`define COUNT_DIFF_12_5  400000000
`define COUNT_DIFF_12_6  480000000
`define COUNT_DIFF_12_7  560000000

`define TRACK_NUM_WIDTH           2
`define STATE_MUSIC_CHECKER_WIDTH 3
`define STATE_LEARNING_MODE_WIDTH 3