`timescale 1ns / 1ps
`include "constants.vh"

module Record(
    input clk,               
    input rst_n,          
    input set_user,       
    input set_record,    
    input [`NEW_RECORD_WIDTH -1:0] new_record,  // new record input
    output [`TUB_CONTROL_USER -1:0] tub_control_user 
);

    wire key_on,key_off;
    reg[`CURRENT_RECORD_WIDTH -1:0] current_record;
    Key key(clk,rst_n,set_user,key_on,key_off);
    reg[`CURRENT_USER_WIDTH -1:0] current_user;
    reg[`RECORD123_WIDTH -1:0] record1 = 0,record2 = 1,record3 = 2;
    BCDto7Segment bcd(current_record,tub_control_user);
    
    always@(posedge clk)begin
        if(set_record)begin
            case (current_user)
            2'd1:record1 <= new_record;
            2'd2:record2 <= new_record;
            2'd3:record3<=new_record;
            endcase
        end
    end
    
    // state machine for managing user switching
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
                                case (current_user)
                                    2'd1: begin current_user <= 2'd2; end
                                    2'd2: begin current_user <= 2'd3; end
                                    2'd3: begin current_user <= 2'd1; end
                                    default: begin current_user <= 2'd1;end
                                endcase
                                state <= `SET;
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
        
  // logic for updating current record based on current user
          always @(*) begin
              case (current_user)
                  2'd1: current_record = record1;
                  2'd2: current_record = record2;
                  2'd3: current_record = record3;
                  default: current_record = record1;
              endcase
          end
endmodule
