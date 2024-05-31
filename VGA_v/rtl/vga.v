        // 定义模块类
class VGA extends Module {
  // 输入输出端口
  val io = IO(new Bundle {
    val osc_50 = Input(Clock())
    val vga_clk = Output(Clock())
    val vga_hs = Output(Bool())
    val vga_vs = Output(Bool())
    val vga_blank = Output(Bool())
    val vga_sync = Output(Bool())
    val vga_r = Output(UInt(8.W))
    val vga_g = Output(UInt(8.W))
    val vga_b = Output(UInt(8.W))
  })

  // 参数定义
  val H_FRONT = 16
  val H_SYNC = 96
  val H_BACK = 48
  val H_ACT = 640
  val H_BLANK = H_FRONT + H_SYNC + H_BACK
  val H_TOTAL = H_FRONT + H_SYNC + H_BACK + H_ACT

  val V_FRONT = 11
  val V_SYNC = 2
  val V_BACK = 31
  val V_ACT = 480
  val V_BLANK = V_FRONT + V_SYNC + V_BACK
  val V_TOTAL = V_FRONT + V_SYNC + V_BACK + V_ACT

  // 时钟分频生成 VGA 时钟
  val clk_25 = RegInit(0.U(1.W))
  when(io.osc_50) { clk_25 := ~clk_25 }

  // VGA 控制信号
  io.vga_sync := 0.U
  io.vga_blank := ~((RegNext(when(clk_25)(0.U(11.W)) < H_BLANK.S) || RegNext(when(clk_25)(0.U(11.W)) < V_BLANK.S)))
  io.vga_clk := ~clk_25

  // 行和场计数器
  val h_cont = RegInit(0.U(11.W))
  val v_cont = RegInit(0.U(11.W))

  // 行同步信号
  when(clk_25) {
    when(h_cont < H_TOTAL.S) { h_cont := h_cont + 1.U }
    .otherwise { h_cont := 0.U }
    when(h_cont === (H_FRONT - 1).S) { io.vga_hs := 0.U }
    when(h_cont === (H_FRONT + H_SYNC - 1).S) { io.vga_hs := 1.U }
  }

  // 场同步信号
  when(io.vga_hs) {
    when(v_cont < V_TOTAL.S) { v_cont := v_cont + 1.U }
    .otherwise { v_cont := 0.U }
    when(v_cont === (V_FRONT - 1).S) { io.vga_vs := 0.U }
    when(v_cont === (V_FRONT + V_SYNC - 1).S) { io.vga_vs := 1.U }
  }
  when(char_bit === 256.U) {
    vga_rgb := 0.U // 如果超出了一行的长度，设置为黑色或其他默认颜色
  } .otherwise {
    vga_rgb := charLines(currentLine)(char_bit + 255.U).asUInt(30.W)
  }
  // 以下是 VGA 显示数据的生成，需要根据具体的图像数据进行转换
var charLines = Array("0000210400200000000000000000000000000000000000000000000000000000".U(256.W),
"1FF0108402220000000000000000000000000000000000000000000000000000".U(256.W),
"10101088FA220000000000000000000000000000000000000000000000000000".U(256.W),
"1010F8002222000007F00FE00FF0008007E01FFC07E007F007E00FE00FF00FE0".U(256.W),
"10100BFE23FE0000081830183018078018183008181808181818301830183018".U(256.W),
"101010202000000010003818380C0180381C2010381C1000381C3818380C3818".U(256.W),
"1FF0102027FE00003000001810180180300C0020300C3000300C001810180018".U(256.W),
"000039FCF820000037F0006000180180300C0040300C37F0300C006000180060".U(256.W),
"0000542020400000380C01F000600180300C0080300C380C300C01F0006001F0".U(256.W),
"3FF8902023FE0000300C001801800180300C0180300C300C300C001801800018".U(256.W),
"200813FE22520000300C000C06000180300C0300300C300C300C000C0600000C".U(256.W),
"200810203A520000300C380C08040180381803003818300C3818380C0804380C".U(256.W),
"20081020E252000018183018300C01801C1003801C1018181C103018300C3018".U(256.W),
"200810204252000007E00FE03FF80FF807E0030007E007E007E00FE03FF80FE0".U(256.W),
"3FF8102002520000000000000000000000000000000000000000000000000000".U(256.W),
"2008102002060000000000000000000000000000000000000000000000000000".U(256.W))
  // 最终的 RGB 信号赋值
  io.vga_r := vga_rgb(23, 16)
  io.vga_g := vga_rgb(15, 8)
  io.vga_b := vga_rgb(7, 0)
}

// 实例化模块
object VGA extends App {
  chisel3.Driver.execute(args, () => new VGA)
}