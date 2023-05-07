module PW_Check(
    input [7:0] Uart_in,
    input Clkin,
    output reg Valid_out
    );
    
parameter S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;
reg [1:0] pstate, nstate;

reg [15:0] count = 0;
reg Clk_out = 0;
always@(posedge Clkin)
begin
    if(count == 16'd8246)
        begin
            Clk_out = ~Clk_out;
            count = 0;
        end
    else
        count = count + 1;    
end

always@(posedge Clk_out)
begin
        pstate=nstate;
end

always@(Uart_in,pstate)
begin
    case(pstate)
        S0: begin               //check for _
            Valid_out = 0;
                if(Uart_in == 8'h61)
                    nstate = S1;
                else
                    nstate = S0;
            end
            
        S1: begin               //check for a_
            Valid_out = 0;
                if(Uart_in == 8'h62)
                    nstate = S2;
                else
                    nstate = S0;
            end
            
        S2: begin               //check for ab_
            Valid_out = 0;
                if(Uart_in == 8'h63)
                    nstate = S3;
                else
                    nstate = S0;
            end
            
        S3: begin               //check for abc_
                if(Uart_in == 8'h64)
                    Valid_out = 1;
                    
                else begin
                    Valid_out = 0;
                    nstate = S0;end
            end
            
    default: nstate=S0;
    endcase  
end
endmodule
