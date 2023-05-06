module vga_test(
    input CLKIN, RESET,
    input [1:0] RGB,
    output HSYNC, VSYNC,
    output [11:0] RGBOUT
    );

wire video_on, pixeltick;
reg [11:0] rgbreg;
wire [11:0] rgbregnext;
wire [9:0] pixel_x, pixel_y;

VGA_Controller vgacontrol(
        CLKIN, RESET,
        video_on,
        HSYNC, VSYNC,
        pixeltick, 
        pixel_x,
        pixel_y
        );

ascii_test_NEW atnew(CLKIN, RESET, video_on, pixel_x, pixel_y, rgbregnext);

always@(posedge CLKIN)
begin
    if(pixeltick)
        rgbreg=rgbregnext;     
end
assign RGBOUT=rgbreg;
endmodule
