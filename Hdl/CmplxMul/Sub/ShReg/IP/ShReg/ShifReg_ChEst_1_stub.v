// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
// Date        : Tue Aug 29 11:21:44 2023
// Host        : ITS00BE43956517 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {c:/Users/sayedomid.ayat/University College Cork/ChirpComm-Team -
//               Documents/General/Workspace/Project/OFDMPlatform/FPGA/HdlMod/ChEst/Sub/ShReg/IP/ShReg/ShifReg_ChEst_1_stub.v}
// Design      : ShifReg_ChEst_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu48dr-ffvg1517-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "c_shift_ram_v12_0_14,Vivado 2021.2" *)
module ShifReg_ChEst_1(A, D, CLK, CE, Q)
/* synthesis syn_black_box black_box_pad_pin="A[3:0],D[105:0],CLK,CE,Q[105:0]" */;
  input [3:0]A;
  input [105:0]D;
  input CLK;
  input CE;
  output [105:0]Q;
endmodule
