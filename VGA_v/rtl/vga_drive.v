//`define 	vga_1920_1080L
`include "vga_para.v"

module vga_drive(

	input						clk			, //640*480--25.2M
	input						rst_n			,
	input	 		[15:0]	data_display,
	
	output reg	[11:0] 	h_addr		,//数据有效显示区域行地址
	output reg	[11:0]	v_addr		,//数据有效显示区域场地址
	
	output reg				vsync			,
	output reg				hsync			,
	output reg 	[4:0]		vga_r			,
	output reg 	[5:0]		vga_g			,
	output reg 	[4:0]		vga_b			,
	output reg				vga_blk		,//消隐信号
	output					vga_clk		,
	output 					sync			
	
);

wire				clk_25M;	
wire				locked;

pll	pll_inst (
	.areset 		( ~rst_n ),
	.inclk0     ( clk ),
	.c0 		   ( clk_25M ),
	);
	


assign	vga_clk = clk_25M;

assign	sync = hsync && vsync;

parameter	H_SYNC_STA = 1;
parameter   H_SYNC_STO = `H_Sync_Time;
parameter   H_Data_STA = `H_Right_Border + `H_Front_Porch + `H_Sync_Time;
parameter   H_Data_STO = `H_Right_Border + `H_Front_Porch + `H_Sync_Time + `H_Data_Time;

parameter   V_SYNC_STA = 1;
parameter   V_SYNC_STO = `V_Sync_Time;
parameter   V_Data_STA = `V_Bottom_Border + `V_Front_Porch + `V_Sync_Time;
parameter   V_Data_STO = `V_Bottom_Border + `V_Front_Porch + `V_Sync_Time + `V_Data_Time;


wire				add_h_addr		;
wire				end_h_addr		;


reg	[11:0]	cnt_v_addr;//行地址寄存器
wire				add_cnt_v_addr	;
wire				end_cnt_v_addr	;

reg	[11:0]	cnt_h_addr		;//场地址寄存器
wire				add_cnt_h_addr ;
wire				end_cnt_h_addr ;

always@(posedge	vga_clk or negedge	rst_n)begin
	if(!rst_n)begin
		cnt_h_addr <= 12'd0;
	end
	else if(add_cnt_h_addr)begin
		if(end_cnt_h_addr)
			cnt_h_addr <= 12'd0;
		else
			cnt_h_addr <= cnt_h_addr + 12'd1;
	end
	else begin
		cnt_h_addr <= 12'd0;
	end
		
	
end
assign	add_cnt_h_addr = 1'b1;
assign	end_cnt_h_addr = add_cnt_h_addr && cnt_h_addr >= `H_Total_Time - 1;
 

always@(posedge	vga_clk or negedge	rst_n)begin
	if(!rst_n)begin
		cnt_v_addr <= 12'd0;
	end
	else if(add_cnt_v_addr)begin
		if(end_cnt_v_addr)
			cnt_v_addr <= 12'd0;
		else
			cnt_v_addr <= cnt_v_addr + 12'd1;
	end
	else begin
		cnt_v_addr <= cnt_v_addr;
	end
		
	
end
assign	add_cnt_v_addr = end_cnt_h_addr;
assign	end_cnt_v_addr = add_cnt_v_addr && cnt_v_addr >= `V_Total_Time - 1; 


//行场同步信号
always@(posedge	vga_clk or negedge	rst_n)begin
	if(!rst_n)
		hsync <= 1'b1;
	else if(cnt_h_addr == H_SYNC_STA -1)
		hsync <= 1'b0;
	else if(cnt_h_addr == H_SYNC_STO-1)
		hsync <= 1'b1;
	else
		hsync <= hsync;
end

always@(posedge	vga_clk or negedge	rst_n)begin
	if(!rst_n)
		vsync <= 1'b1;
	else if(cnt_v_addr == V_SYNC_STA -1)
		vsync <= 1'b0;
	else if(cnt_v_addr == V_SYNC_STO-1)
		vsync <= 1'b1;
	else
		vsync <= vsync;
end



//有效显示区域
always@(posedge vga_clk or negedge rst_n)begin
	if(!rst_n)
		h_addr <= 12'b0;
	else	if(cnt_h_addr >= H_Data_STA && cnt_h_addr <= H_Data_STO)begin
		h_addr <= cnt_h_addr - H_Data_STA ;
		vga_blk <= 1'b1;
	end
   else begin
		h_addr <= 12'b0;
		vga_blk <= 1'b0;
	end
	
end
always@(posedge vga_clk or negedge rst_n)begin
	if(!rst_n)
		v_addr <= 12'b0;
	else	if(cnt_v_addr >= V_Data_STA  && cnt_v_addr <= V_Data_STO)begin
		v_addr <= cnt_v_addr - V_Data_STA;
	end
   else begin
		v_addr <= 12'b0;
	end
	
end


//数据显示
always@(posedge vga_clk or negedge rst_n)begin
	if(!rst_n)begin
		vga_r <= 5'h0;
		vga_g <= 6'h0;
		vga_b <= 5'h0;
	end
	else	if(cnt_h_addr >= H_Data_STA - 1 && cnt_h_addr <= H_Data_STO - 1 && 
					cnt_v_addr >= V_Data_STA - 1 && cnt_v_addr <= V_Data_STO - 1)begin
		vga_r <= data_display[15:11];	//data_display[23-:8]
		vga_g <= data_display[10:5];	//data_display[15-:8]
		vga_b <= data_display[4:0];	//data_display[7-:8]
	end
	else begin
		vga_r <= 5'h0;
		vga_g <= 6'h0;
		vga_b <= 5'h0;
	end
		
end








endmodule

