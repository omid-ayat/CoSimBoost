// %%	=======================================================================
// %	CmplxMul HDL code:
// %	Output Fixed point format: 1_16_11
// %	Computes the following:
// %		ThisBlockRecvChEstSymbol		=	ThisBlockRecvPilotSymbol ./ ThisBlockTrnsPilotSymbol
// %	-----------------------------------------------------------------------
// %		$Version:	1.00.00.000
// %		$Date:		2022-12-05
// %		$Author(s):	Omid Ayat (XOyLab)
// %		$Project:	ChirpComm
// %	-----------------------------------------------------------------------
// %	-	Description & Usage/Examples:
// %		It will outputs precalculated values for the following codes in matlab:
// %			ThisBlockRecvChEstSymbol		=	ThisBlockRecvPilotSymbol ./ ThisBlockTrnsPilotSymbol
// %%	=======================================================================
`timescale 1ns / 1ps

module CmplxMul #(InputBitWidth = 16, OutputBitWidth = 16, InputFractionalPoint=12, OutputFractionalPoint=6, ShiftRegDelayPar	= 4) 
	(
		AXI_Data_A_In,
		AXI_Data_B_In,
		AXI_Config_In,			

		AXI_Config_Out,							
		AXI_Data_C_Out,

		CmplxMul_Error
														
	);

	
	// =================================================================================
	// AXI & Input/Outputs
	// =================================================================================
	axi_config_OCDM			AXI_Config_In;
	axi_packet.slave		AXI_Data_A_In;
	axi_packet.slave		AXI_Data_B_In;

	axi_config_OCDM			AXI_Config_Out;
	axi_packet.master		AXI_Data_C_Out;


	// ShiftReg
	axi_config_OCDM										AXI_C_ShiftReg_CmplxMul_Out		(AXI_Data_A_In.clk, 		AXI_Data_A_In.reset);
	axi_packet				#(InputBitWidth, 2)			AXI_D_ShiftReg_CmplxMul_Out		(AXI_Data_A_In.clk, 		AXI_Data_A_In.reset);

	output logic			CmplxMul_Error; 

	logic signed [(InputBitWidth+InputBitWidth-1):0] Real_Res, Imag_Res;

	assign	AXI_Data_A_In.tready		= AXI_Data_C_Out.tready ;
	assign	AXI_Data_B_In.tready		= AXI_Data_C_Out.tready ;							
	localparam BinaryPoint=  (InputFractionalPoint+InputFractionalPoint);
																					//Bit Num in HW: [24-8+16-1].[24-8] 
	// ( 1_16_12 ) *  ( 1_16_12 ) = 1_32_24											//Bit Num in HW: [31].[16]  --> 1_16_8																																						
	assign AXI_Data_C_Out.bus[0]			=	Real_Res[ BinaryPoint - OutputFractionalPoint + OutputBitWidth - 1 : BinaryPoint - OutputFractionalPoint ];														
	assign AXI_Data_C_Out.bus[1]			=	-Imag_Res[ BinaryPoint - OutputFractionalPoint + OutputBitWidth - 1 : BinaryPoint - OutputFractionalPoint ]; 
	assign AXI_Data_C_Out.tvalid			=	AXI_D_ShiftReg_CmplxMul_Out.tvalid;
	assign AXI_Data_C_Out.tlast				=	AXI_D_ShiftReg_CmplxMul_Out.tlast;
	assign AXI_Data_C_Out.tfirst			=	AXI_D_ShiftReg_CmplxMul_Out.tfirst;

	assign AXI_Config_Out.modulation		=	AXI_C_ShiftReg_CmplxMul_Out.modulation;    
	assign AXI_Config_Out.tvalid			=	AXI_C_ShiftReg_CmplxMul_Out.tvalid;


	// =================================================================================
	// Variables
	// =================================================================================

	
	// localparam InputBitWidth = 16, InputBitWidth = 16;
	logic signed [InputBitWidth-1:0]      Real_A, Imag_A;
	logic signed [InputBitWidth-1:0]      Real_B, Imag_B;
	// logic signed [InputBitWidth+InputBitWidth:0] Real_Res, Imag_Res;


	logic signed [InputBitWidth-1:0] Imag_A_d, Imag_A_dd, Imag_A_ddd, Imag_A_dddd   ;
	logic signed [InputBitWidth-1:0] Real_A_d, Real_A_dd, Real_A_ddd, Real_A_dddd   ;
	logic signed [InputBitWidth-1:0] Imag_B_d, Imag_B_dd, Imag_B_ddd, Real_B_d, Real_B_dd, Real_B_ddd ;

	logic signed [InputBitWidth:0]  addcommon     ;
	logic signed [InputBitWidth:0]  addr, addi     ;

	logic signed [InputBitWidth+InputBitWidth:0] mult0, multr, multi, pr_int, pi_int  ;
	logic signed [InputBitWidth+InputBitWidth:0] common, commonr1, commonr2   ;

	assign Real_A = AXI_Data_A_In.bus[0];
	assign Imag_A = AXI_Data_A_In.bus[1];
	assign Real_B = AXI_Data_B_In.bus[0];
	assign Imag_B = AXI_Data_B_In.bus[1];

	always_ff @(posedge AXI_Data_A_In.clk)
	begin
		Real_A_d   <= Real_A;
		Real_A_dd  <= Real_A_d;
		Imag_A_d   <= Imag_A;
		Imag_A_dd  <= Imag_A_d;
		Real_B_d   <= Real_B;
		Real_B_dd  <= Real_B_d;
		Real_B_ddd <= Real_B_dd;
		Imag_B_d   <= Imag_B;
		Imag_B_dd  <= Imag_B_d;
		Imag_B_ddd <= Imag_B_dd;
	end

	// Common factor (Real_A Imag_A) x Imag_B, shared for the calculations of the real and imaginary final products
	//

	always_ff @(posedge AXI_Data_A_In.clk)
	begin
		addcommon <= Real_A_d - Imag_A_d;
		mult0     <= addcommon * Imag_B_dd;
		common    <= mult0;
	end

	// Real product
	//

	always_ff @(posedge AXI_Data_A_In.clk)
	begin
		Real_A_ddd		<= Real_A_dd;
		Real_A_dddd		<= Real_A_ddd;
		addr     		<= Real_B_ddd - Imag_B_ddd;
		multr    		<= addr * Real_A_dddd;
		commonr1 		<= common;
		pr_int   		<= multr + commonr1;
	end

	// Imaginary product
	//

	always_ff @(posedge AXI_Data_A_In.clk)
	begin
		Imag_A_ddd		<= Imag_A_dd;
		Imag_A_dddd		<= Imag_A_ddd;
		addi			<= Real_B_ddd + Imag_B_ddd;
		multi   		<= addi * Imag_A_dddd;
		commonr2		<= common;
		pi_int  		<= multi + commonr2;
	end

	assign Real_Res = pr_int;
	assign Imag_Res = pi_int;

	// =================================================================================
	// ShiftReg : To componsate the multiplyers process delay. The output data (.bus) will not be used in multplication process, only handshaking signals are used.
	// ShiftRegDelayPar	=  (based on experience; If you want 3 clk cycle delays , you need to set it to 3-2=1)
	// =================================================================================
	// (Output Fixed point format:  )
	// logic [3 : 0] ShiftRegDelay;
	// assign	ShiftRegDelay = ShiftRegDelayPar;

	ShiftReg  #(.InputBitWidth (InputBitWidth), .ShiftRegDelayPar (ShiftRegDelayPar))  Inst_ShiftReg_CmplxMul
	(
		.AXI_C_ShiftReg_In				(AXI_Config_In),//
		.AXI_D_ShiftReg_In				(AXI_Data_A_In),//

		.AXI_C_ShiftReg_Out				(AXI_C_ShiftReg_CmplxMul_Out),
		.AXI_D_ShiftReg_Out				(AXI_D_ShiftReg_CmplxMul_Out) 
	);

endmodule




