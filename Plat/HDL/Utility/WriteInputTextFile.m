function []=WriteInputTextFile(TestVector,Idx,ThisConfig)
    %% Writing to .txt files

    Input_A_Vector					= [];
    Input_B_Vector					= [];
    signed							= 1; %bcz we are processing signed numbers

	%Creating an stream of data for each input
    for ThisBlock = 1: ThisConfig.NumOfBlocks
            Input_A_Vector        = [Input_A_Vector TestVector.Input_A{ThisBlock}'];
            Input_B_Vector        = [Input_B_Vector TestVector.Input_B{ThisBlock}'];
	end
	
	%Converting to fixed point representation for Real And Imag values separately 
	Input_A_Vector_Re_FxPt        = dec2bin(Fixed_Integer_Mapping(real (Input_A_Vector)    , ThisConfig.InputBitWidth, ThisConfig.InputFractionalPoint, signed), ThisConfig.InputBitWidth);
	Input_A_Vector_Im_FxPt        = dec2bin(Fixed_Integer_Mapping(imag (Input_A_Vector)    , ThisConfig.InputBitWidth, ThisConfig.InputFractionalPoint, signed), ThisConfig.InputBitWidth);
	Input_B_Vector_Re_FxPt        = dec2bin(Fixed_Integer_Mapping(real (Input_B_Vector)    , ThisConfig.InputBitWidth, ThisConfig.InputFractionalPoint, signed), ThisConfig.InputBitWidth);
	Input_B_Vector_Im_FxPt        = dec2bin(Fixed_Integer_Mapping(imag (Input_B_Vector)    , ThisConfig.InputBitWidth, ThisConfig.InputFractionalPoint, signed), ThisConfig.InputBitWidth);

    addr= ['HDL/Snrio/',num2str(Idx),'/TestVector/Input_A_Vector_Re_FxPt.txt'];
    fid = fopen(addr , 'w');
	for i = 1: (ThisConfig.NumOfBlocks*ThisConfig.RTLInputBlockSize)
		fprintf(fid , Input_A_Vector_Re_FxPt (i,:));
		fprintf(fid , '\n');
	end
    fclose(fid);

    addr= ['HDL/Snrio/',num2str(Idx),'/TestVector/Input_A_Vector_Im_FxPt.txt'];
    fid = fopen(addr , 'w');
    for i = 1: (ThisConfig.NumOfBlocks*ThisConfig.RTLInputBlockSize)
		fprintf(fid , Input_A_Vector_Im_FxPt (i,:));
		fprintf(fid , '\n');
	end
    fclose(fid);


	addr= ['HDL/Snrio/',num2str(Idx),'/TestVector/Input_B_Vector_Re_FxPt.txt'];
    fid = fopen(addr , 'w');
    for i = 1: (ThisConfig.NumOfBlocks*ThisConfig.RTLInputBlockSize)
		fprintf(fid , Input_B_Vector_Re_FxPt (i,:));
		fprintf(fid , '\n');
	end
    fclose(fid);

    addr= ['HDL/Snrio/',num2str(Idx),'/TestVector/Input_B_Vector_Im_FxPt.txt'];
    fid = fopen(addr , 'w');
    for i = 1: (ThisConfig.NumOfBlocks*ThisConfig.RTLInputBlockSize)
		fprintf(fid , Input_B_Vector_Im_FxPt (i,:),'\n');
		fprintf(fid , '\n');
	end
    fclose(fid);
end

