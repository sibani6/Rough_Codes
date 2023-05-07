`timescale 1ns / 1ps
//UART is asynchronous as Rx and Tx are not synchronised by a clock
/*
-RX module takes serial data from the devices and outputs parallel data
-parallel data feeded to bcd-to-seven segment decoder
-Baud rate = 115200 bits/sec
-clk_per_bit = 100,000,000/115200 = 868 clock cycles per bit
-Data sampled at each mid bit period to check for proper reception
-RxValid = High after successful data reception
*/
module UART_RX
#(parameter CLK_PER_BIT = 868)
   (input clkin,
    input serial_in,
    output rx_valid,
    output [7:0] bit_out    
    );

//FSM has 4 states
parameter IDLE      =  3'b000;   //Default state 
parameter START_BIT =  3'b001;   //Initiated if falling edge occurs
parameter DATA_BIT  =  3'b010;   //State where 8 data bits(0 to 7) are received
parameter STOP_BIT  =  3'b011;   //Initiated after all data bits are received
parameter CLEARING  =  3'b100;
          
reg [10:0]    clks_per_bit  = 0;         //to count the clk cycle for sampling
reg [2:0]     r_Bit_Index   = 0;         //[2:0] as we have to count from 000 to 111
reg [7:0]     r_RX_Byte     = 0;         //for taking the serial input from the user for each bit
reg           r_rx_valid    = 0;
reg [2:0]     r_SM_Main     = 0;

always@(posedge clkin)
begin
case(r_SM_Main)
    
    IDLE: begin                     //to check for starting pulse
        r_rx_valid = 1'b0;
        clks_per_bit = 1'b0;
        
        if(serial_in==1'b0)
            r_SM_Main = START_BIT;
        else    
            r_SM_Main = IDLE;
          end
          
          
    START_BIT: begin
               if(clks_per_bit == (CLK_PER_BIT/2))      //434 as half of the pulses checked for sampling the start bit
               begin
                    if(serial_in == 1'b0)
                    begin
                        clks_per_bit = 0;
                        r_SM_Main = DATA_BIT;
                    end
                    else
                        r_SM_Main = IDLE;
               end
               else
                    begin
                    clks_per_bit = clks_per_bit+1;
                    r_SM_Main = START_BIT;
                    end
               end
               
               
    DATA_BIT: begin
              if(clks_per_bit < CLK_PER_BIT-1)
              begin
                  clks_per_bit <= clks_per_bit+1;
                  r_SM_Main <= DATA_BIT;
              end
              
              else 
                begin
                clks_per_bit = 0;
                r_RX_Byte[r_Bit_Index] = serial_in;
                
                    if(r_Bit_Index < 7)
                    begin
                        r_Bit_Index = r_Bit_Index+1;
                        r_SM_Main <= DATA_BIT;
                    end
                    else
                    begin
                        r_Bit_Index <= 0;
                        r_SM_Main <= STOP_BIT;
                    end                    
                end
              end        
              
                 
    STOP_BIT: begin
                  if (clks_per_bit < CLK_PER_BIT-1)
          begin
            clks_per_bit <= clks_per_bit + 1;
     	    r_SM_Main    <= STOP_BIT;
          end
          
          else
          begin
       	    r_rx_valid     <= 1'b1;
            clks_per_bit   <= 0;
            r_SM_Main      <= CLEARING;
          end
        end
        
        
    CLEARING :
        begin
          r_SM_Main   <= IDLE;
          r_rx_valid  <= 1'b0;
        end

        default: r_SM_Main = IDLE;
endcase
end

assign bit_out = r_RX_Byte;
assign rx_valid = r_rx_valid;
endmodule
