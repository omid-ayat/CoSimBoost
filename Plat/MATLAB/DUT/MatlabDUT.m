function [MatlabGoldenIO] = MatlabDUT(Config, ConfigIdx)
	
% %% Initial
% 	ThisConfig.NumOfBlocks				= Config.NumOfBlocks;
% 	ThisConfig.RTLInputBlockSize		= Config.RTLInputBlockSize;
% 	ThisConfig.RTLOutputBlockSize       = Config.RTLOutputBlockSize;
%     ThisConfig.Input_A_FractionalPoint	= Config.Input_A_FractionalPoint;
% 	ThisConfig.Input_B_FractionalPoint	= Config.Input_B_FractionalPoint;
% 	ThisConfig.OutputFractionalPoint    = Config.OutputFractionalPoint;



%% generate random data for each Block
	fprintf("\n ********************************************************************************* \n");
	fprintf('\nConfig No %d \n', ConfigIdx);
    for BlockNumIndx = 1:Config.NumOfBlocks
		
		% Generating random complex numbers
		Input_A									= rand(Config.RTLInputBlockSize,1) + rand(Config.RTLInputBlockSize,1)*1i;
		Input_B									= rand(Config.RTLInputBlockSize,1) + rand(Config.RTLInputBlockSize,1)*1i;
		MatlabGoldenIO.Input_A{BlockNumIndx}	= Input_A; 
		MatlabGoldenIO.Input_B{BlockNumIndx}	= Input_B;

		% Matlab reference design
		Output_C								= Input_A .* Input_B;
		MatlabGoldenIO.Output_C{BlockNumIndx}	= Output_C;
		
		% Verification
		fprintf("\n ***************************** \n");
		fprintf(' Block No %d \n', BlockNumIndx);
		for BlockDataIndx = 1:Config.RTLInputBlockSize
			fprintf('(%f + %fi) * (%f + %fi) = (%f + %fi) \n',real(Input_A(BlockDataIndx)),imag(Input_A(BlockDataIndx)),real(Input_B(BlockDataIndx)),imag(Input_B(BlockDataIndx)),real(Output_C(BlockDataIndx)),imag(Output_C(BlockDataIndx)));
		end
		fprintf("\n ***************************** \n");
	end
	fprintf("\n ********************************************************************************* \n");
end