`timescale 1ns / 1ps
module UART_SSD(
    input CLOCK,
    input UART_IN,
    output RX_VALID,
    output [6:0] CATHODE_OUT,
    output [3:0] ANODE_OUT,
    output [7:0] LED_OUT
    );
    
wire [7:0] out_rx, hex_out;
wire [3:0] cath_digit;
wire rxval;
UART_RX          uart_recvr(.clkin(CLOCK), .serial_in(UART_IN), .rx_valid(rx_val), 
                 .bit_out(out_rx));
assign LED_OUT = out_rx;
PW_Check         passwd(out_rx, RX_VALID);
/*assign LED_OUT = out_rx;            

UART_ASCII_Map   uart_mapping(.UART_bit_in(out_rx), .Hex_Out(hex_out));

Bin_Control      binary_ctrl(.clkin(CLOCK), .uart_in(hex_out), .cath_digit(cath_digit));

Cathode_Control  cathode_ctrl(.Digit(cath_digit), .Cathode(CATHODE_OUT));

Anode_Control    anode_ctrl(.Clk_in(CLOCK), .Anode(ANODE_OUT));*/

endmodule
