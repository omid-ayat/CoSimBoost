// %%	=======================================================================
// %	RecPilotMem HDL code:
// %	Output Fixed point format: same as the input
// %	Computes the following:
// %		based on experience; If you want 3 clk cycle delays , you need to set it to 3-2=1
// %	-----------------------------------------------------------------------
// %		$Version:	1.00.00.000
// %		$Date:		2023-02-15
// %		$Author(s):	Omid Ayat (XOyLab)
// %		$Project:	ChirpComm
// %	-----------------------------------------------------------------------
// %	-	Description & Usage/Examples:
// %%	=======================================================================
`timescale 1ns / 1ps

module ShiftReg
	#(
		MODUL_WIDTH                     = 3,
		ShiftRegDelayPar				= 1,
		InputBitWidth					= 16		
	)
	(
		AXI_C_ShiftReg_In,
		AXI_D_ShiftReg_In,			

		AXI_C_ShiftReg_Out,							
		AXI_D_ShiftReg_Out					
	);


	// =================================================================================
	// AXI & Input/Outputs
	// =================================================================================
	axi_config_OCDM										AXI_C_ShiftReg_In;
	axi_packet.slave									AXI_D_ShiftReg_In;

	axi_config_OCDM										AXI_C_ShiftReg_Out;
	axi_packet.master									AXI_D_ShiftReg_Out;

	assign	AXI_D_ShiftReg_In.tready = AXI_D_ShiftReg_Out.tready ;
	
	// =================================================================================
	// Parameters
	// =================================================================================

	logic                               Data_tvalid;
	logic                               Data_tlast;
	logic                               Data_tfirst;

	logic   [MODUL_WIDTH-1 :0]          Config_modulation;     
	logic                               Config_tvalid;


	logic [3 : 0] ShiftRegDelay;

	assign	ShiftRegDelay = ShiftRegDelayPar;

	// =================================================================================
	// IP instantiation
	// =================================================================================

	ShifReg_ChEst_1 ShifReg_ChEst_1_inst (
	// input wire [1 : 0] A
	.A		(ShiftRegDelay),	
	// input wire [92 : 0] D
	.D		({	AXI_D_ShiftReg_In.tvalid, AXI_D_ShiftReg_In.tlast, AXI_D_ShiftReg_In.bus[1], AXI_D_ShiftReg_In.bus[0], AXI_D_ShiftReg_In.tfirst, AXI_C_ShiftReg_In.tvalid, AXI_C_ShiftReg_In.modulation}),
	// input wire CLK	
	.CLK	(AXI_D_ShiftReg_In.clk),	
	// input wire CE
	.CE(1'b1),    
	// output wire [92 : 0] Q
	.Q		({	AXI_D_ShiftReg_Out.tvalid, AXI_D_ShiftReg_Out.tlast, AXI_D_ShiftReg_Out.bus[1], AXI_D_ShiftReg_Out.bus[0], AXI_D_ShiftReg_Out.tfirst,AXI_C_ShiftReg_Out.tvalid, AXI_C_ShiftReg_Out.modulation })		
	);

endmodule




