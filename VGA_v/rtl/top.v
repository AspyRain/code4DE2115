module	top(
input						clk,
input						rst_n,
	
 output	 				vsync,	
 output 					hsync,		
 output  	[4:0]		vga_r,		
 output  	[5:0]		vga_g,		
 output  	[4:0]		vga_b,		
 output					vga_clk,
 output					vga_blk,
 output					sync
);





wire	[11:0]   h_addr;
wire	[11:0]   v_addr;
wire	[15:0]	data_display;



vga_drive  inst_vga_drive(
.clk				(clk), //640*480--25.2M
.rst_n			(rst_n),
.data_display	(
),

.h_addr			(h_addr),//数据有效显示区域行地址
.v_addr			(v_addr),//数据有效显示区域场地址

.vsync			(vsync),
.hsync			(hsync),
.vga_r			(vga_r),
.vga_g			(vga_g),
.vga_b			(vga_b),
.vga_blk			(vga_blk),
.vga_clk     	(vga_clk),
.sync				(sync)
	
);

data_gen		inst_data_gen(	
.clk				(vga_clk), //640*480--25.2M
.rst_n			(rst_n),
.h_addr			(h_addr),//数据有效显示区域行地址
.v_addr			(v_addr),//数据有效显示区域场地output	

.data_disp	(data_display)
);





endmodule

