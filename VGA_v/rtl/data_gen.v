module data_gen (
    input   wire              clk         , //vga clk 640*480 25.2MHz
    input   wire              rst_n       , //复位信号

    input   wire   [10:0]     h_addr      , //数据有效显示区域行地址
    input   wire   [10:0]     v_addr      , //数据有效显示区域场地址

    output  reg    [15:0]     data_disp     //

);

    
    reg			[ 13:0 ]		rom_address				; // ROM地址
    wire		[ 15:0 ]		rom_data				; // 图片数据

    wire						flag_enable_out2			; // 图片有效区域
    wire						flag_clear_rom_address		; // 地址清零
    wire						flag_begin_h			    ; // 图片显示行
    wire						flag_begin_v			    ; // 图片显示列
    
    parameter	height = 46; // 图片高度
    parameter	width  = 62; // 图片宽度

    reg [ 223:0 ] char_line[ 15:0 ];//16*14个字符=224,224*16的字符存储区
//参数定义
    parameter
        BLACK   = 24'h000000,
        RED     = 24'hFF0000,
        GREEN   = 24'h00FF00,
        BLUE    = 24'h0000FF,
        YELLOW  = 24'hFFFF00,
        SKY_BULE= 24'h00FFFF,
        PURPLE  = 24'hFF00FF,
        GRAY    = 24'hC0C0C0,
        WHITE   = 24'hFFFFFF; 

    always @( posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        data_disp = BLACK;
    end
    else if ( flag_enable_out2 ) begin
        data_disp = rom_data;
    end
    else begin
        data_disp = BLACK;
    end
    end

    //ROM地址计数器
    always @( posedge clk or negedge rst_n ) begin
        if ( !rst_n ) begin
            rom_address <= 0;
        end
        else if ( flag_clear_rom_address ) begin //计数满清零
            rom_address <= 0;
        end
            else if ( flag_enable_out2 ) begin  //在有效区域内+1
            rom_address <= rom_address + 1;
            end
        else begin  //无效区域保持
            rom_address <= rom_address;
        end
    end
    assign flag_clear_rom_address = rom_address == height * width - 1;
    assign flag_begin_h     = h_addr > ( ( 640 - width ) / 2 ) && h_addr < ( ( 640 - width ) / 2 ) + width + 1;
    assign flag_begin_v     = v_addr > ( ( 480 - height )/2 ) && v_addr <( ( 480 - height )/2 ) + height + 1;
    assign flag_enable_out2 = flag_begin_h && flag_begin_v;

    //实例化ROM
    rom	rom_inst (
    .address    ( rom_address   ),
    .clock      ( clk           ),
    .q          ( rom_data      )
    );
endmodule
