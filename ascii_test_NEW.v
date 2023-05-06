module ascii_test_NEW(
    input clk, reset,
    input video_on,
    input [9:0] x, y,
    output reg [11:0] rgb
    );
    
// signal declarations
    wire [10:0] rom_addr;           // 11-bit text ROM address
    wire [6:0] char_addr;          // 7-bit ASCII character code
    wire [3:0] row_addr;            // 4-bit row of ASCII character
    wire [2:0] bit_addr;            // column number of ROM data
    wire [7:0] rom_data;            // 8-bit row data from text ROM
    wire ascii_bit, ascii_bit_on;     // ROM bit and status signal
    
    
    // instantiate ASCII ROM
    ascii_rom rom(.addr(rom_addr), .data(rom_data));
      
    // ASCII ROM interface
    assign rom_addr = {char_addr, row_addr};   // ROM address is ascii code + row
    assign ascii_bit = rom_data[~bit_addr];     // reverse bit order to go from 7 to 0

    //assign char_addr = 7'h4e;                 // 7-bit ascii code for rom_addr
    //assign char_addr = {y[5:4], x[7:3]};    // 7-bit ascii code for rom_addr
    
    //wire [9:0] x_val_lower, x_val_upper;
    //CHAR_ADDR_GEN cag(clk, reset, char_addr, x_val_lower, x_val_upper);
    
    CHARADDR_GENERATOR chargen(x, y, char_addr);
    
    //taking 4:1 to perform font scaling
    assign row_addr = y[4:1];               // row number of ascii character rom
    assign bit_addr = x[3:1];               // column number of ascii character rom
    
    // "on" region in center of screen
    //assign ascii_bit_on = ((x >= 8 && x < 16) && (y >= 128 && y < 144)) ? ascii_bit : 1'b0;
    //assign ascii_bit_on_2 = ((x >= 24 && x < 32) && (y >= 128 && y < 144)) ? ascii_bit : 1'b0;
    
    assign ascii_bit_on = ((x >=0 && x < 272) && (y >= 192 && y < 208)) ? ascii_bit : 1'b0;
    
    // rgb multiplexing circuit
    always @*
        if(~video_on)
            rgb = 12'h000;      // blank
        else
            if(ascii_bit_on)
                rgb = 12'hF05;  // blue letters
            else
                rgb = 12'hFFF;  // white background
   
endmodule
