module CHARADDR_GENERATOR(
    input [9:0] x, y,
    output reg [6:0] char_addr=0
    );
    
always@(x,y)
begin
    if((x>=16 && x<32) && (y>=160 && y<192))
        char_addr=7'h4a;
        
    else if((x>=48 && x<64) && (y>=160 && y<192))
        char_addr=7'h4b;
        
    else if((x>=80 && x<96) && (y>=160 && y<192))
        char_addr=7'h4c;
        
    else if((x>=112 && x<128) && (y>=160 && y<192))
        char_addr=7'h4d;
    
    else if((x>=144 && x<160) && (y>=160 && y<192))
        char_addr=7'h4e;
        
    else if((x>=176 && x<192) && (y>=160 && y<192))
        char_addr=7'h4f;
        
    else if((x>=208 && x<224) && (y>=160 && y<192))
        char_addr=7'h36;
        
    else if((x>=240 && x<256) && (y>=160 && y<192))
        char_addr=7'h39;
    else
        char_addr=7'h0;
end
endmodule
