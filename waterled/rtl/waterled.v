module waterled( // @[:@3.2]
  input         clock, // @[:@4.4]
  input         reset, // @[:@5.4]
  output [17:0] io_led // @[:@6.4]
);
  reg [31:0] count; // @[waterled.scala 25:25:@8.4]
  reg [31:0] _RAND_0;
  wire  _T_9; // @[waterled.scala 26:26:@9.4]
  wire [32:0] _T_12; // @[waterled.scala 26:45:@10.4]
  wire [31:0] _T_13; // @[waterled.scala 26:45:@11.4]
  wire [31:0] _T_14; // @[waterled.scala 26:18:@12.4]
  reg [17:0] shiftReg; // @[waterled.scala 11:21:@14.4]
  reg [31:0] _RAND_1;
  wire  _T_18; // @[waterled.scala 12:23:@16.4]
  wire [23:0] _T_21; // @[waterled.scala 15:30:@21.6]
  wire [23:0] _T_22; // @[waterled.scala 15:30:@22.6]
  wire [22:0] _T_23; // @[waterled.scala 15:30:@23.6]
  wire [31:0] _GEN_2; // @[waterled.scala 15:17:@24.6]
  wire  _T_24; // @[waterled.scala 15:17:@24.6]
  wire [16:0] _T_25; // @[waterled.scala 16:31:@26.8]
  wire  _T_26; // @[waterled.scala 16:49:@27.8]
  wire  _T_27; // @[waterled.scala 16:40:@28.8]
  wire [17:0] _T_28; // @[Cat.scala 30:58:@29.8]
  wire [17:0] _GEN_0; // @[waterled.scala 15:36:@25.6]
  assign _T_9 = count == 32'h4c4b40; // @[waterled.scala 26:26:@9.4]
  assign _T_12 = count + 32'h1; // @[waterled.scala 26:45:@10.4]
  assign _T_13 = _T_12[31:0]; // @[waterled.scala 26:45:@11.4]
  assign _T_14 = _T_9 ? 32'h0 : _T_13; // @[waterled.scala 26:18:@12.4]
  assign _T_18 = reset == 1'h0; // @[waterled.scala 12:23:@16.4]
  assign _T_21 = 23'h4c4b40 - 23'h1; // @[waterled.scala 15:30:@21.6]
  assign _T_22 = $unsigned(_T_21); // @[waterled.scala 15:30:@22.6]
  assign _T_23 = _T_22[22:0]; // @[waterled.scala 15:30:@23.6]
  assign _GEN_2 = {{9'd0}, _T_23}; // @[waterled.scala 15:17:@24.6]
  assign _T_24 = count == _GEN_2; // @[waterled.scala 15:17:@24.6]
  assign _T_25 = shiftReg[16:0]; // @[waterled.scala 16:31:@26.8]
  assign _T_26 = shiftReg[17]; // @[waterled.scala 16:49:@27.8]
  assign _T_27 = ~ _T_26; // @[waterled.scala 16:40:@28.8]
  assign _T_28 = {_T_25,_T_27}; // @[Cat.scala 30:58:@29.8]
  assign _GEN_0 = _T_24 ? _T_28 : shiftReg; // @[waterled.scala 15:36:@25.6]
  assign io_led = shiftReg; // @[waterled.scala 23:10:@36.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  count = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{$random}};
  shiftReg = _RAND_1[17:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (!reset) begin
      count <= 32'h0;
    end else begin
      if (_T_9) begin
        count <= 32'h0;
      end else begin
        count <= _T_13;
      end
    end
    if (_T_18) begin
      shiftReg <= 18'h0;
    end else begin
      if (_T_24) begin
        shiftReg <= _T_28;
      end
    end
  end
endmodule
