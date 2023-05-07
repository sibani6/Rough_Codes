module PASS_GENERATOR(
    input [9:0] x, y,
    input main_clk,
    output reg [6:0] char_addr
    );

reg [28:0] count;
reg clk_out;
//1s clock for toggling 'PASSWORD' and '----'
always@(posedge main_clk)
begin
    if(count == 29'd99_999_999)
    begin
        clk_out=~clk_out;
        count=0;
    end
    else
        count=count+1;
end


always@(x,y,clk_out)
begin
    if(clk_out)
    begin
    if((x>=80 && x<96) && (y>=192 && y<224))
        char_addr=7'h2d;    //2e => -
        
    else if((x>=112 && x<128) && (y>=192 && y<224))
        char_addr=7'h2d;
        
    else if((x>=144 && x<160) && (y>=192 && y<224))
        char_addr=7'h2d;
        
    else if((x>=176 && x<192) && (y>=192 && y<224))
        char_addr=7'h2d;
        
    else   
        char_addr=7'h0;    
    end
    
    else
    begin
        if((x>=16 && x<32) && (y>=192 && y<224))
        char_addr=7'h50;     //P 
        
    else if((x>=48 && x<64) && (y>=192 && y<224))
        char_addr=7'h41;     //A
        
    else if((x>=80 && x<96) && (y>=192 && y<224))
        char_addr=7'h53;     //S
        
    else if((x>=112 && x<128) && (y>=192 && y<224))
        char_addr=7'h53;     //S
    
    else if((x>=144 && x<160) && (y>=192 && y<224))
        char_addr=7'h57;     //W
    
    else if((x>=176 && x<192) && (y>=192 && y<224))
        char_addr=7'h4f;     //O
    
    else if((x>=208 && x<224) && (y>=192 && y<224))
        char_addr=7'h52;     //R
    
    else if((x>=240 && x<256) && (y>=192 && y<224))
        char_addr=7'h44;     //D
    
    else
        char_addr=7'h0;
    end
end
endmodule
