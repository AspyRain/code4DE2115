module led_ctrl(input En,input CP,input Dn,output reg [0:7] Out);//匹配8个灯，故宽度为8
reg [25:0] cnt;
reg cnt1;
reg Cn;
parameter cnt_max = 26'd49_999_999;//时钟的频率是50mhz，要实现几秒钟变一次就调到//相应时间，例子为1s每次

always@(posedge CP or negedge En)//该always循环实现的是一秒钟的计数
   if(En==1'b0)
 	cnt<=26'd0;
   else if(cnt == cnt_max)
	cnt<=26'd0;
   else 
	cnt<=cnt + 1'b1;
always @(posedge CP or negedge En) //cnt每次为1代表到了一秒钟
   if(En==1'b0)
 	cnt1<=1'b0;
   else if(cnt == cnt_max-1'd1)
	cnt1<=1'b1;
   else 
	cnt1<=1'b0;

always @(posedge CP or negedge En)
	if(En==1'b0) begin
	  if(Dn==1'b1)                  //用 Dn来判断赋不同的值，1为亮，也就可以实现两个灯一起移动的选择
 	     Out <=8'b00000001;
	  else
	     Out <=8'b00000011;
	 end
   else begin
	    if (Out[0]==1'b1)//不用判断整个Out，只需要判断最边上的1，为1则表示需要改变方向，方向由Cn判断
		      Cn<=1'b1;
		 else if(Out[7]==1'b1)
		      Cn<=1'b0;
	      if (cnt1==1'b1) begin
		      if(Cn==1'b1)
			       Out<={1'b0,Out[0:6]};//右移
			    else
			       Out<={Out[1:7],1'b0};//左移
			 end
   end


endmodule
