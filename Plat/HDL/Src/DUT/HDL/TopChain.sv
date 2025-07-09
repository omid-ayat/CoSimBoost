// %%	=======================================================================
// %	$Top Chain 
// %	-----------------------------------------------------------------------
// %		$Version:	1.00.00.000
// %		$Date:		2024-04-12
// %		$Author(s):	Sayed Omid Ayat 
// %		$Project:	CoVerification Training
// %	-----------------------------------------------------------------------
// %	-	Description & Usage/Examples:
// %%	=======================================================================
`timescale 1ns / 1ps


module DUT_Receiver
	#(	DATA_Width_Bits=16, SubcarLengthDATAWidth= 17)
	(																
		AXI_C_Top_Input,
		AXI_D_Top_Input,

		AXI_C_NonEQ_SymbolOut,
		AXI_D_NonEQ_SymbolOut,

		AXI_C_EQ_SymbolOut,
		AXI_D_EQ_SymbolOut,

		// 
		AXI_C_Top_InfobitOut,
		AXI_D_Top_InfobitOut			// 	use 2 lane for Real and Imagin (bus0 => real) (bus1 => imag) and 16 bits
	);



	// =================================================================================
	// AXI & Input/Outputs
	// =================================================================================

	axi_config_OCDM.slave								AXI_C_Top_Input;
	axi_packet.slave									AXI_D_Top_Input;

	axi_config_OCDM.master								AXI_C_NonEQ_SymbolOut;							
	axi_packet.master									AXI_D_NonEQ_SymbolOut;

	axi_config_OCDM.master								AXI_C_EQ_SymbolOut;							
	axi_packet.master									AXI_D_EQ_SymbolOut;

	axi_config_OCDM.master								AXI_C_Top_InfobitOut;							
	axi_packet.master									AXI_D_Top_InfobitOut;	
	

	// ----------------------------------		TR		----------------------------------

	// // Modulator
	// axi_config_OCDM										AXI_C_Modulator_Out			(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);
	// axi_packet				#(DATA_Width_Bits, 2)			AXI_D_Modulator_Out			(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);

	// // IFFT_Mapper
	// axi_config_OCDM										AXI_C_IFFT_Mapper_Out		(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);
	// axi_packet				#(DATA_Width_Bits, 2)			AXI_D_IFFT_Mapper_Out		(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);

	// // IFFT_Core
	// axi_config_OCDM										AXI_C_IFFT_Core_Out			(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);
	// axi_packet				#(DATA_Width_Bits, 2)			AXI_D_IFFT_Core_Out			(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);

	// ----------------------------------		RX		----------------------------------

	// ChannelEst
	axi_config_OCDM											AXI_C_ChannelEst_In			(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);
	axi_packet				#(DATA_Width_Bits, 2)			AXI_D_ChannelEst_In			(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);
	axi_config_OCDM											AXI_C_ChannelEst_Out		(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);
	axi_packet				#(DATA_Width_Bits, 2)			AXI_D_ChannelEst_Out		(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);

	// GI_Removal
	axi_config_OCDM											AXI_C_GI_Removal_In			(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);
	axi_packet				#(DATA_Width_Bits, 2)			AXI_D_GI_Removal_In			(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);
	axi_config_OCDM											AXI_C_GI_Removal_Out		(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);
	axi_packet				#(DATA_Width_Bits, 2)			AXI_D_GI_Removal_Out		(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);

	// FFT
	axi_config_OCDM											AXI_C_FFT_Out				(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);
	axi_packet				#(DATA_Width_Bits, 2)			AXI_D_FFT_Out				(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);

	// DeMapper
	axi_config_OCDM											AXI_C_DeMapper_Out			(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);
	axi_packet				#(DATA_Width_Bits, 2)			AXI_D_DeMapper_Out			(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);


	// Equalizer
	axi_config_OCDM											AXI_C_Equalizer_Out			(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);
	axi_packet				#(DATA_Width_Bits, 2)			AXI_D_Equalizer_Out			(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);

	// //FIFO_HLS_Intf
	axi_config_OCDM											AXI_C_FIFO_HLS_Out			(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);
	axi_packet				#(DATA_Width_Bits, 2)			AXI_D_FIFO_HLS_Out			(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);

	// //Debug
	// axi_packet				#(DATA_Width_Bits, 2)			TEMP						(AXI_D_Top_Input.clk, 		AXI_D_Top_Input.reset);


	

	// =================================================================================
	// Variables
	// =================================================================================

	logic 											IFFT_Error, FFT_Error, IFFT_Mapper_Error, DeMapper_Error, ChannelEst_Error, Equalizer_Error;
	logic [19:0]									ModulatorOut_Counter;

	// =================================================================================
	// Receiver's Control Unit 
	// =================================================================================



// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
// ─████████████████───██████████████─██████████████─██████████████─██████████─██████──██████─██████████████─████████████████───
// ─██░░░░░░░░░░░░██───██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░██─██░░██──██░░██─██░░░░░░░░░░██─██░░░░░░░░░░░░██───
// ─██░░████████░░██───██░░██████████─██░░██████████─██░░██████████─████░░████─██░░██──██░░██─██░░██████████─██░░████████░░██───
// ─██░░██────██░░██───██░░██─────────██░░██─────────██░░██───────────██░░██───██░░██──██░░██─██░░██─────────██░░██────██░░██───
// ─██░░████████░░██───██░░██████████─██░░██─────────██░░██████████───██░░██───██░░██──██░░██─██░░██████████─██░░████████░░██───
// ─██░░░░░░░░░░░░██───██░░░░░░░░░░██─██░░██─────────██░░░░░░░░░░██───██░░██───██░░██──██░░██─██░░░░░░░░░░██─██░░░░░░░░░░░░██───
// ─██░░██████░░████───██░░██████████─██░░██─────────██░░██████████───██░░██───██░░██──██░░██─██░░██████████─██░░██████░░████───
// ─██░░██──██░░██─────██░░██─────────██░░██─────────██░░██───────────██░░██───██░░░░██░░░░██─██░░██─────────██░░██──██░░██─────
// ─██░░██──██░░██████─██░░██████████─██░░██████████─██░░██████████─████░░████─████░░░░░░████─██░░██████████─██░░██──██░░██████─
// ─██░░██──██░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░██───████░░████───██░░░░░░░░░░██─██░░██──██░░░░░░██─
// ─██████──██████████─██████████████─██████████████─██████████████─██████████─────██████─────██████████████─██████──██████████─
// ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

	// assign AXI_C_ChannelEst_In					= (ChannelEst_In.pilot & ChannelEst_In.tready) ? Top_Input: 0;
	assign AXI_C_ChannelEst_In.tvalid				= (AXI_C_ChannelEst_In.pilot & AXI_C_ChannelEst_In.tready & AXI_D_ChannelEst_In.tready) ? AXI_C_Top_Input.tvalid			: 0;
	assign AXI_C_ChannelEst_In.pilot				= AXI_C_Top_Input.pilot; 
	assign AXI_C_ChannelEst_In.NumSymbol			= AXI_C_Top_Input.NumSymbol;
	assign AXI_C_ChannelEst_In.NumSubcar			= AXI_C_Top_Input.NumSubcar; 
	assign AXI_C_ChannelEst_In.BlockInfoBit			= AXI_C_Top_Input.BlockInfoBit; 
	assign AXI_C_ChannelEst_In.modulation			= AXI_C_Top_Input.modulation ;
	assign AXI_C_ChannelEst_In.DCNull				= AXI_C_Top_Input.DCNull; 
	assign AXI_C_ChannelEst_In.Prefix				= AXI_C_Top_Input.Prefix; 
	assign AXI_C_ChannelEst_In.Suffix				= AXI_C_Top_Input.Suffix ;


	assign AXI_D_ChannelEst_In.tvalid				= (AXI_C_ChannelEst_In.pilot & AXI_C_ChannelEst_In.tready & AXI_D_ChannelEst_In.tready) ? AXI_D_Top_Input.tvalid			: 0; 
	assign AXI_D_ChannelEst_In.tlast				= (AXI_C_ChannelEst_In.pilot & AXI_C_ChannelEst_In.tready & AXI_D_ChannelEst_In.tready) ? AXI_D_Top_Input.tlast				: 0; 
	assign AXI_D_ChannelEst_In.bus[1]				= (AXI_C_ChannelEst_In.pilot & AXI_C_ChannelEst_In.tready & AXI_D_ChannelEst_In.tready) ? AXI_D_Top_Input.bus[1]			: 0; 
	assign AXI_D_ChannelEst_In.bus[0]				= (AXI_C_ChannelEst_In.pilot & AXI_C_ChannelEst_In.tready & AXI_D_ChannelEst_In.tready) ? AXI_D_Top_Input.bus[0]			: 0; 
	assign AXI_D_ChannelEst_In.tfirst				= (AXI_C_ChannelEst_In.pilot & AXI_C_ChannelEst_In.tready & AXI_D_ChannelEst_In.tready) ? AXI_D_Top_Input.tfirst			: 0;

	// Input.tready = (Removal_In.tready) | (pilot & ChannelEst_In.tready);
	assign AXI_C_Top_Input.tready=(AXI_C_GI_Removal_In.tready & AXI_D_GI_Removal_In.tready) | (AXI_C_Top_Input.pilot & AXI_C_ChannelEst_In.tready & AXI_D_ChannelEst_In.tready);
	assign AXI_D_Top_Input.tready=(AXI_C_GI_Removal_In.tready & AXI_D_GI_Removal_In.tready) | (AXI_C_Top_Input.pilot & AXI_C_ChannelEst_In.tready & AXI_D_ChannelEst_In.tready);

	//assign AXI_D_GI_Removal_In					= (!AXI_C_Top_Input.pilot) ? AXI_D_Top_Input				: 0;
	assign AXI_C_GI_Removal_In.tvalid				= (!AXI_C_Top_Input.pilot) ? AXI_C_Top_Input.tvalid			: 0;
	assign AXI_C_GI_Removal_In.pilot				=  AXI_C_Top_Input.pilot; 
	assign AXI_C_GI_Removal_In.NumSymbol			= (!AXI_C_Top_Input.pilot) ? AXI_C_Top_Input.NumSymbol		: 0;
	assign AXI_C_GI_Removal_In.NumSubcar			= (!AXI_C_Top_Input.pilot) ? AXI_C_Top_Input.NumSubcar		: 0; 
	assign AXI_C_GI_Removal_In.BlockInfoBit			= (!AXI_C_Top_Input.pilot) ? AXI_C_Top_Input.BlockInfoBit	: 0; 
	assign AXI_C_GI_Removal_In.modulation			= (!AXI_C_Top_Input.pilot) ? AXI_C_Top_Input.modulation		: 0;
	assign AXI_C_GI_Removal_In.DCNull				= (!AXI_C_Top_Input.pilot) ? AXI_C_Top_Input.DCNull			: 0; 
	assign AXI_C_GI_Removal_In.Prefix				= (!AXI_C_Top_Input.pilot) ? AXI_C_Top_Input.Prefix			: 0; 
	assign AXI_C_GI_Removal_In.Suffix				= (!AXI_C_Top_Input.pilot) ? AXI_C_Top_Input.Suffix			: 0;


	assign AXI_D_GI_Removal_In.tvalid				= (!AXI_C_Top_Input.pilot) ? AXI_D_Top_Input.tvalid			: 0; 
	assign AXI_D_GI_Removal_In.tlast				= (!AXI_C_Top_Input.pilot) ? AXI_D_Top_Input.tlast			: 0; 
	assign AXI_D_GI_Removal_In.bus[1]				= (!AXI_C_Top_Input.pilot) ? AXI_D_Top_Input.bus[1]			: 0; 
	assign AXI_D_GI_Removal_In.bus[0]				= (!AXI_C_Top_Input.pilot) ? AXI_D_Top_Input.bus[0]			: 0; 
	assign AXI_D_GI_Removal_In.tfirst				= (!AXI_C_Top_Input.pilot) ? AXI_D_Top_Input.tfirst			: 0;


	//Output: AXI_NonEQ_SymbolOut
	assign AXI_C_NonEQ_SymbolOut.tvalid			= AXI_C_DeMapper_Out.tvalid			;
	assign AXI_C_NonEQ_SymbolOut.pilot			= AXI_C_DeMapper_Out.pilot			; 
	assign AXI_C_NonEQ_SymbolOut.NumSymbol		= AXI_C_DeMapper_Out.NumSymbol		;
	assign AXI_C_NonEQ_SymbolOut.NumSubcar		= AXI_C_DeMapper_Out.NumSubcar		; 
	assign AXI_C_NonEQ_SymbolOut.BlockInfoBit	= AXI_C_DeMapper_Out.BlockInfoBit	; 
	assign AXI_C_NonEQ_SymbolOut.modulation		= AXI_C_DeMapper_Out.modulation		;
	assign AXI_C_NonEQ_SymbolOut.DCNull			= AXI_C_DeMapper_Out.DCNull			; 
	assign AXI_C_NonEQ_SymbolOut.Prefix			= AXI_C_DeMapper_Out.Prefix			; 
	assign AXI_C_NonEQ_SymbolOut.Suffix			= AXI_C_DeMapper_Out.Suffix			;
	

	assign AXI_D_NonEQ_SymbolOut.tvalid			= AXI_D_DeMapper_Out.tvalid 		; 
	assign AXI_D_NonEQ_SymbolOut.tlast			= AXI_D_DeMapper_Out.tlast			; 
	assign AXI_D_NonEQ_SymbolOut.bus[1]			= AXI_D_DeMapper_Out.bus[1]			; 
	assign AXI_D_NonEQ_SymbolOut.bus[0]			= AXI_D_DeMapper_Out.bus[0]			; 
	assign AXI_D_NonEQ_SymbolOut.tfirst			= AXI_D_DeMapper_Out.tfirst			;


	//Output: AXI_EQ_SymbolOut
	assign AXI_C_EQ_SymbolOut.tvalid			= AXI_C_Equalizer_Out.tvalid			;
	assign AXI_C_EQ_SymbolOut.pilot				= AXI_C_Equalizer_Out.pilot				; 
	assign AXI_C_EQ_SymbolOut.NumSymbol			= AXI_C_Equalizer_Out.NumSymbol			;
	assign AXI_C_EQ_SymbolOut.NumSubcar			= AXI_C_Equalizer_Out.NumSubcar			; 
	assign AXI_C_EQ_SymbolOut.BlockInfoBit		= AXI_C_Equalizer_Out.BlockInfoBit		; 
	assign AXI_C_EQ_SymbolOut.modulation		= AXI_C_Equalizer_Out.modulation		;
	assign AXI_C_EQ_SymbolOut.DCNull			= AXI_C_Equalizer_Out.DCNull			; 
	assign AXI_C_EQ_SymbolOut.Prefix			= AXI_C_Equalizer_Out.Prefix		; 
	assign AXI_C_EQ_SymbolOut.Suffix			= AXI_C_Equalizer_Out.Suffix		;

	assign AXI_D_EQ_SymbolOut.tvalid			= AXI_D_FIFO_HLS_Out.tvalid			& AXI_D_FIFO_HLS_Out.tready		; 
	assign AXI_D_EQ_SymbolOut.tlast				= AXI_D_FIFO_HLS_Out.tlast				; 
	assign AXI_D_EQ_SymbolOut.bus[1]			= AXI_D_FIFO_HLS_Out.bus[1]			; 
	assign AXI_D_EQ_SymbolOut.bus[0]			= AXI_D_FIFO_HLS_Out.bus[0]			; 
	assign AXI_D_EQ_SymbolOut.tfirst			= AXI_D_FIFO_HLS_Out.tfirst			;

	// // =================================================================================
	// // ChannelEst (Output Fixed point format: 1_16_14 )
	// // =================================================================================

	ChannelEst #( .DATA_Width_Bits (DATA_Width_Bits)	, .SubcarLengthDATAWidth (SubcarLengthDATAWidth) )  ChannelEst_inst
    (
    	.start					(1'b1),

		.AXI_C_ChannelEst_In		(AXI_C_ChannelEst_In),
		.AXI_D_ChannelEst_In		(AXI_D_ChannelEst_In), 

		.AXI_C_ChannelEst_Out		(AXI_C_ChannelEst_Out),
		.AXI_D_ChannelEst_Out		(AXI_D_ChannelEst_Out), 

		// .AXI_C_ChannelEst_Out		(AXI_C_Top_InfobitOut),
		// .AXI_D_ChannelEst_Out		(AXI_D_Top_InfobitOut), 		

		.ChannelEst_Error			(ChannelEst_Error)
    );


	// =================================================================================
	// GI_Removal (Output Fixed point format: 1_16_12 )
	// =================================================================================

	GI_Removal_FIFOBased #(	.DATA_Width_Bits (DATA_Width_Bits)	,.SubcarLengthDATAWidth (SubcarLengthDATAWidth))  Inst_GI_Removal
	(
		.AXI_C_GI_Removal_In				(AXI_C_GI_Removal_In),
		.AXI_D_GI_Removal_In				(AXI_D_GI_Removal_In),

		.AXI_C_GI_Removal_Out				(AXI_C_GI_Removal_Out), 
		.AXI_D_GI_Removal_Out				(AXI_D_GI_Removal_Out), 

		// .AXI_C_GI_Removal_Out				(AXI_C_EQ_SymbolOut), 
		// .AXI_D_GI_Removal_Out				(AXI_D_EQ_SymbolOut),

		.GI_Removal_Error					(GI_Removal_Error)
		
	);


	// =================================================================================
	// FFT (Output Fixed point format: 1_16_12 )
	// =================================================================================
	FFT_IP_Controller  #(.SubcarLengthDATAWidth (SubcarLengthDATAWidth))  Inst_FFT_IP_Controller
	(
		.AXI_C_FFT_In				(AXI_C_GI_Removal_Out),
		.AXI_D_FFT_In				(AXI_D_GI_Removal_Out),

		.AXI_C_FFT_Out				(AXI_C_FFT_Out),
		.AXI_D_FFT_Out				(AXI_D_FFT_Out), // 	use 2 lane for Real and Imagin (bus0 => real) (bus1 => imag) and 18 bits

		.FFT_Error					(FFT_Error),
		// .Subcar_Length_Input		(Subcar_Length_Input),
		.Forward					(1'b1)				//Forward=1: FFT, Forward=0: IFFT
		
	);


	// =================================================================================
	// DeMapper (Output Fixed point format: 1_16_12 )
	// =================================================================================

	DeMapper #(	.DATA_Width_Bits (DATA_Width_Bits)	,.SubcarLengthDATAWidth (SubcarLengthDATAWidth) )  Inst_DeMapper
	(
		// .AXI_C_DeMapper_In				(AXI_C_GI_Removal_Out),
		// .AXI_D_DeMapper_In				(AXI_D_GI_Removal_Out),

		.AXI_C_DeMapper_In				(AXI_C_FFT_Out),
		.AXI_D_DeMapper_In				(AXI_D_FFT_Out),

		.AXI_C_DeMapper_Out				(AXI_C_DeMapper_Out), 
		.AXI_D_DeMapper_Out				(AXI_D_DeMapper_Out), 

		// .AXI_C_DeMapper_Out				(AXI_C_Top_InfobitOut), 
		// .AXI_D_DeMapper_Out				(AXI_D_Top_InfobitOut),

		.DeMapper_Error					(DeMapper_Error)
		// .Subcar_Length_Input			(Subcar_Length_Input),
		// .Symbol_Length_Input			(Symbol_Length_Input)
		
	);


	// =================================================================================
	// Equalizer (Output Fixed point format: 1_16_12 )
	// =================================================================================

	Equalizer  Equalizer_inst
    (
		//CFRC is "Channel Frequency Resopond's Coefficient" 
		.AXI_C_CFRC_In					(AXI_C_ChannelEst_Out),
		.AXI_D_CFRC_In					(AXI_D_ChannelEst_Out),

		.AXI_C_Symbol_In				(AXI_C_DeMapper_Out),
		.AXI_D_Symbol_In				(AXI_D_DeMapper_Out),	

		.AXI_C_Equalizer_Out			(AXI_C_Equalizer_Out),							
		.AXI_D_Equalizer_Out			(AXI_D_Equalizer_Out),

		// .AXI_C_Equalizer_Out			(AXI_C_Top_InfobitOut),							
		// .AXI_D_Equalizer_Out			(AXI_D_Top_InfobitOut),


		.Equalizer_Error				(Equalizer_Error)
    );



	
	// =================================================================================
	// FIFO_HLS_Intf (Output Fixed point format: 1_16_12 ), This Fifo is just to handle the different handshaking protocol btw OFDM submodules developed in SV and HLS
	// =================================================================================

	FIFO_HLS_Intf FIFO_HLS_Intf_inst
    (
    	.AXI_D_FIFO_HLS_In 				(AXI_D_Equalizer_Out),
		.AXI_C_FIFO_HLS_In 				(AXI_C_Equalizer_Out),

		.AXI_D_FIFO_HLS_Out 			(AXI_D_FIFO_HLS_Out),
		.AXI_C_FIFO_HLS_Out				(AXI_C_FIFO_HLS_Out)
    );



	// =================================================================================
	// Demodulator (Output Fixed point format: binary )
	// =================================================================================

	Top_Demod_Wrapper #( .DATA_Width_Bits (16)	, .SubcarLengthDATAWidth (SubcarLengthDATAWidth))  Top_Demod_Wrapper_inst
    (
    	.start							(1'b1),
    	.AXI_Demodulator_Data_In 		(AXI_D_FIFO_HLS_Out),
		.AXI_Demodulator_Config_In 		(AXI_C_FIFO_HLS_Out),

		.AXI_Demodulator_Data_Out 		(AXI_D_Top_InfobitOut)
		// .AXI_Demodulator_Config_Out		(AXI_C_Top_InfobitOut)
    );

	// assign AXI_C_Top_InfobitOut.tready=1;
	// assign AXI_D_Top_InfobitOut.tready=1;

endmodule




