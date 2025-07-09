// %%	=======================================================================
// %	$Testbench 
// %	-----------------------------------------------------------------------
// %		$Version:	1.00.00.000
// %		$Date:		2024-04-12
// %		$Author(s):	Sayed Omid Ayat 
// %		$Project:	CoVerification Training
// %	-----------------------------------------------------------------------
// %	-	Description & Usage/Examples:
// %%	=======================================================================

`timescale 1ns / 1ps

`include "sv_interface.sv"

`include "../../../../../../TestVector/parameters.sv"

parameter Clk_PERIOD=4;

module TB_TopChain();

	localparam START_TIME = (20*Clk_PERIOD);

	// =================================================================================
	// Variables
	// =================================================================================
	bit 							Clk , Reset;

	int 							Data_A_IntReal_1, Data_A_IntImag_1, Data_A_IntReal_2, Data_A_IntImag_2;
	logic 	[InputBitWidth-1:0]		Data_A_Real, Data_A_Imag;

	int 							Data_B_IntReal_1, Data_B_IntImag_1, Data_B_IntReal_2, Data_B_IntImag_2;
	logic 	[InputBitWidth-1:0]		Data_B_Real, Data_B_Imag;

	int 							Data_C_IntReal_1, Data_C_IntImag_1;
	// logic 	[InputBitWidth-1:0]	Data_C_Real, Data_C_Imag;

	int 							Input_Block_counter = 0;
	int 							Output_Block_counter = 0;
	int 							data_counter=0;

	logic 	[3:0]					DataState;
	logic 							end_simulation = 0;




	// =================================================================================
	// inteface and instace
	// =================================================================================

	axi_config_OCDM											AXI_Config_In					(Clk, Reset);
	axi_packet	#(InputBitWidth, 2)						AXI_Data_A_In					(Clk, Reset);
	axi_packet	#(InputBitWidth, 2)						AXI_Data_B_In					(Clk, Reset);

	axi_config_OCDM											AXI_Config_Out					(Clk, Reset);
	axi_packet	#(OutputBitWidth, 2)						AXI_Data_C_Out					(Clk, Reset);
			

	// =================================================================================
	// CmplxMul (Output Fixed point format: 1_16_11 )
	// =================================================================================

	CmplxMul #(.InputBitWidth (InputBitWidth), .OutputBitWidth (OutputBitWidth), .InputFractionalPoint (InputFractionalPoint), .OutputFractionalPoint (OutputFractionalPoint)) CmplxMul_inst 
    (

		.AXI_Data_A_In			(AXI_Data_A_In),
		.AXI_Data_B_In			(AXI_Data_B_In),
		.AXI_Config_In			(AXI_Config_In),			

		.AXI_Config_Out			(AXI_Config_Out),							
		.AXI_Data_C_Out			(AXI_Data_C_Out),

		.CmplxMul_Error			(CmplxMul_Error)
    );





	// =================================================================================
	// open Test Vector and result files
	// =================================================================================
	initial begin
		//inputs
		Data_A_IntReal_1			= $fopen("../../../../../../TestVector/Input_A_Vector_Re_FxPt.txt","r");
		Data_A_IntImag_1			= $fopen("../../../../../../TestVector/Input_A_Vector_Im_FxPt.txt","r");
		Data_B_IntReal_1			= $fopen("../../../../../../TestVector/Input_B_Vector_Re_FxPt.txt","r");
		Data_B_IntImag_1			= $fopen("../../../../../../TestVector/Input_B_Vector_Im_FxPt.txt","r");


		// Outputs
		Data_C_IntReal_1			= $fopen({"../../../../../../Result/Output_C_Vector_Re_FxPt.txt"},"w");
		Data_C_IntImag_1			= $fopen({"../../../../../../Result/Output_C_Vector_Im_FxPt.txt"},"w");
	end 





	// =================================================================================
	// End of simulation
	// =================================================================================
	always_ff @( posedge Clk ) begin
		if(!Reset) begin
			Output_Block_counter	<= 0;
			end_simulation			<= 0;
		end if (AXI_Data_C_Out.tlast & AXI_Data_C_Out.tvalid) begin
			Output_Block_counter 	<= Output_Block_counter + 1;
			end_simulation			<= (Output_Block_counter==NumOfBlocks-1) ? 1:0; // 
		end
	end

	initial 
	begin 
		wait  (end_simulation == 1)
		begin
			# (2 * START_TIME)
			$fclose(Data_C_IntReal_1);		
			$fclose(Data_C_IntImag_1);		
			$display("================ THIS SCENARIO IS COMPLETED SUCCESSFULLY ================");
			$finish;	
		end
	end
	


	// =================================================================================
	// Reset & Clk Initialization
	// =================================================================================

	initial
	begin
		Reset						<= 0;	
		#START_TIME
		Reset 						<= 1;
		// # (20*START_TIME)
		# (NumOfBlocks*Clk_PERIOD);

	end

	// always #(Clk_PERIOD/2) Clk 						<= ~Clk;	
	always
	begin
		Clk = 1'b1;
		#(Clk_PERIOD/2) Clk = 1'b0;
		#(Clk_PERIOD/2);
	end



	// =================================================================================
	// Next module tready
	// =================================================================================
	initial begin
		AXI_Data_C_Out.tready		<= 0;
		#(3*START_TIME)
		AXI_Data_C_Out.tready		<= 1;
	end


	// =================================================================================
	// Read Packet Data by DUT
	// =================================================================================

	always_ff @( posedge Clk ) 
	begin 
		if(!Reset) begin
			AXI_Data_A_In.tfirst			<= 0;
			AXI_Data_A_In.tlast			<= 0;
			AXI_Data_A_In.tvalid			<= 0;
			data_counter					<= 0;
			DataState						<= 0;
			Input_Block_counter				<= 0;
			//  Configs
			AXI_Config_In.modulation 		<= 0;
		end else 
		if (Input_Block_counter < NumOfBlocks) begin 
			AXI_Data_A_In.tfirst			<= 0;
			AXI_Data_A_In.tvalid			<= 0;
			AXI_Data_A_In.tlast			<= 0;
			DataState						<= 1;		
			// =================================================================================
			// Digesting time between two frames: do nothing after tlast
			// =================================================================================
			if( AXI_Data_A_In.tlast) begin		
				Data_A_IntReal_2				<= 0;
				AXI_Data_A_In.bus[0]			<= 0;

				Data_A_IntImag_2				<= 0;
				AXI_Data_A_In.bus[1]			<= 0;

				Data_B_IntReal_2				<= 0;
				AXI_Data_B_In.bus[0]			<= 0;

				Data_B_IntImag_2				<= 0;
				AXI_Data_B_In.bus[1]			<= 0;

				AXI_Data_A_In.tfirst			<= 0;
				AXI_Data_A_In.tvalid			<= 0;
				AXI_Data_A_In.tlast			<= 0;


				AXI_Config_In.tvalid			<= 0;
				data_counter					<= data_counter;
				DataState						<= 2;
			// =================================================================================
			// First data only , !AXI_Config_In.tready means that the module is already recieved the config
			// =================================================================================
			end else if(AXI_Data_A_In.tready && (data_counter==0)) begin		
				Data_A_IntReal_2				<= $fscanf(Data_A_IntReal_1,"%b\n", Data_A_Real);
				AXI_Data_A_In.bus[0]			<= Data_A_Real;

				Data_A_IntImag_2				<= $fscanf(Data_A_IntImag_1,"%b\n", Data_A_Imag);
				AXI_Data_A_In.bus[1]			<= Data_A_Imag;

				Data_B_IntReal_2				<= $fscanf(Data_B_IntReal_1,"%b\n", Data_B_Real);
				AXI_Data_B_In.bus[0]			<= Data_B_Real;

				Data_B_IntImag_2				<= $fscanf(Data_B_IntImag_1,"%b\n", Data_B_Imag);
				AXI_Data_B_In.bus[1]			<= Data_B_Imag;

				AXI_Data_A_In.tfirst			<= 1;
				AXI_Data_A_In.tvalid			<= 1;
				AXI_Data_A_In.tlast			<= 0;

				//  Configs
				AXI_Config_In.tvalid			<= 1;

				data_counter					<= data_counter+1;
				DataState						<= 3;
			// =================================================================================
			// if it is not first or last
			// =================================================================================
			end else if (AXI_Data_A_In.tready && data_counter!=0 && data_counter!= (RTLInputBlockSize -1)) begin 	

				Data_A_IntReal_2				<= $fscanf(Data_A_IntReal_1,"%b\n", Data_A_Real);
				AXI_Data_A_In.bus[0]			<= Data_A_Real;

				Data_A_IntImag_2				<= $fscanf(Data_A_IntImag_1,"%b\n", Data_A_Imag);
				AXI_Data_A_In.bus[1]			<= Data_A_Imag;

				Data_B_IntReal_2				<= $fscanf(Data_B_IntReal_1,"%b\n", Data_B_Real);
				AXI_Data_B_In.bus[0]			<= Data_B_Real;

				Data_B_IntImag_2				<= $fscanf(Data_B_IntImag_1,"%b\n", Data_B_Imag);
				AXI_Data_B_In.bus[1]			<= Data_B_Imag;

				AXI_Data_A_In.tfirst			<= 0;
				AXI_Data_A_In.tvalid			<= 1;

				//  Configs
				AXI_Config_In.tvalid			<= 0;

				data_counter					<= data_counter+1;
				DataState						<= 5;
				
			// =================================================================================
			//Not Ready: Hold current value for all transactions
			// =================================================================================
			end else if (!AXI_Data_A_In.tready) begin 				

				AXI_Data_A_In.bus[0]			<= AXI_Data_A_In.bus[0];
				AXI_Data_A_In.bus[1]			<= AXI_Data_A_In.bus[1];

				AXI_Data_A_In.tfirst			<= AXI_Data_A_In.tfirst;
				AXI_Data_A_In.tvalid			<= AXI_Data_A_In.tvalid;

				AXI_Data_B_In.bus[0]			<= AXI_Data_B_In.bus[0];
				AXI_Data_B_In.bus[1]			<= AXI_Data_B_In.bus[1];

				AXI_Data_B_In.tfirst			<= AXI_Data_B_In.tfirst;
				AXI_Data_B_In.tvalid			<= AXI_Data_B_In.tvalid;

				//  Configs
				AXI_Config_In.tvalid			<= AXI_Config_In.tvalid;

				data_counter					<= data_counter;				
				DataState						<= 6;

			// =================================================================================
			//last data
			// =================================================================================
			end else if (AXI_Data_A_In.tready && data_counter== (RTLInputBlockSize -1)) begin									
				Data_A_IntReal_2				<= $fscanf(Data_A_IntReal_1,"%b\n", Data_A_Real);
				AXI_Data_A_In.bus[0]			<= Data_A_Real;

				Data_A_IntImag_2				<= $fscanf(Data_A_IntImag_1,"%b\n", Data_A_Imag);
				AXI_Data_A_In.bus[1]			<= Data_A_Imag;

				Data_B_IntReal_2				<= $fscanf(Data_B_IntReal_1,"%b\n", Data_B_Real);
				AXI_Data_B_In.bus[0]			<= Data_B_Real;

				Data_B_IntImag_2				<= $fscanf(Data_B_IntImag_1,"%b\n", Data_B_Imag);
				AXI_Data_B_In.bus[1]			<= Data_B_Imag;

				AXI_Data_A_In.tfirst			<= 0;
				AXI_Data_A_In.tlast			<= 1;
				AXI_Data_A_In.tvalid			<= 1;

				//  Configs
				AXI_Config_In.tvalid			<= 0;

				data_counter					<= 0;								
				DataState						<= 7;
 				Input_Block_counter				<= Input_Block_counter+1;
 			end
		end else begin
			AXI_Data_A_In.tfirst			<= 0;
			AXI_Data_A_In.tlast			<= 0;
			AXI_Data_A_In.tvalid			<= 0;

			//  Configs
			AXI_Config_In.modulation		<= AXI_Config_In.modulation;

			DataState						<= 8;
			Input_Block_counter				<= Input_Block_counter;
		end
		
	end




	// =================================================================================
	// write the output inReal Text file
	// =================================================================================
	always_ff @(posedge Clk)
		if(Reset)
			if(AXI_Data_C_Out.tvalid && AXI_Data_C_Out.tready)
			begin
				$fwrite(Data_C_IntReal_1,"%d\n",($signed(AXI_Data_C_Out.bus[0])));
				$fwrite(Data_C_IntImag_1,"%d\n",($signed(AXI_Data_C_Out.bus[1])));
			end

	//----------------------------------------------------------------------------------




endmodule
