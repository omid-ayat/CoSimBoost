
function [] = WriteParameters(ThisConfig,Idx)
    %% Writes parameters.sv file

    address			= ['HDL/Snrio/',num2str(Idx),'/TestVector/parameters.sv'];
    fid				= fopen(address,'wt');

    string          = ['parameter NumOfBlocks = ',num2str(ThisConfig.NumOfBlocks ),';']; 
    fprintf(fid,'%s\n',string);

	string          = ['parameter InputBitWidth = ',num2str(ThisConfig.InputBitWidth ),';']; 
    fprintf(fid,'%s\n',string);

	string          = ['parameter OutputBitWidth = ',num2str(ThisConfig.OutputBitWidth ),';']; 
    fprintf(fid,'%s\n',string);

	string          = ['parameter RTLInputBlockSize = ',num2str(ThisConfig.RTLInputBlockSize ),';']; 
    fprintf(fid,'%s\n',string);

	string          = ['parameter RTLOutputBlockSize = ',num2str(ThisConfig.RTLOutputBlockSize ),';']; 
    fprintf(fid,'%s\n',string);

	string          = ['parameter InputFractionalPoint = ',num2str(ThisConfig.InputFractionalPoint ),';']; 
    fprintf(fid,'%s\n',string);

	string          = ['parameter OutputFractionalPoint = ',num2str(ThisConfig.OutputFractionalPoint ),';']; 
    fprintf(fid,'%s\n',string);


end


