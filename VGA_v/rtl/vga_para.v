`define 	vga_640_480

`ifdef	vga_640_480
	`define	H_Right_Border 8
	`define	H_Front_Porch  8
	`define	H_Sync_Time    96
	`define	H_Back_Porch	40
	`define	H_Left_Border	8
	`define	H_Data_Time		640
	`define	H_Total_Time	800
	`define	V_Bottom_Border	8
	`define	V_Front_Porch	2
	`define	V_Sync_Time		2
	`define	V_Back_Porch	25
	`define	V_Top_Border	8
	`define	V_Data_Time		480
	`define	V_Total_Time	525

`elsif	vga_1920_1080
	`define	H_Right_Border 0
	`define	H_Front_Porch  88
	`define	H_Sync_Time    44
	`define	H_Back_Porch	148
	`define	H_Left_Border	0
	`define	H_Data_Time		1920
	`define	H_Total_Time	2200
	`define	V_Bottom_Borde	0
	`define	V_Front_Porch	4
	`define	V_Sync_Time		5
	`define	V_Back_Porch	36
	`define	v_Top_Border	2
	`define	v_Data_Time		1080
	`define	v_Total_Time	1125

	
`endif
