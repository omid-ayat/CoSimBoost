function QuantizationError(MatlabGoldenIO, RTLOutput,ConfigTable, NumOfConfigToRun )
for ConfigIdx = 1:NumOfConfigToRun 
    %% initial definition
    Configs                 = ConfigTable(ConfigIdx,:);
    NumOfBlocks             = Configs.NumOfBlocks;
    fprintf("***************************** \n");
    fprintf("Config No: %d\n", ConfigIdx);
    fprintf("***************************** \n\n");
	SumQuantizeErrReal=0;
	SumQuantizeErrimag=0;
    for BlockIdx = 1 : NumOfBlocks 
        fprintf("********Block No: %d****** \n\n", BlockIdx);
        HDLreal=(RTLOutput{1, ConfigIdx}.O_Real{1, BlockIdx}).*2^(-ConfigTable.OutputFractionalPoint(ConfigIdx));
        MatlabReal=real(MatlabGoldenIO{1, ConfigIdx}.Output_C{1, BlockIdx}); 

        HDLimag=(RTLOutput{1, ConfigIdx}.O_Imag{1, BlockIdx}).*2^(-ConfigTable.OutputFractionalPoint(ConfigIdx));
        Matlabimag=imag(MatlabGoldenIO{1, ConfigIdx}.Output_C{1, BlockIdx}); 

        QuantizeErrReal=mean( abs( HDLreal - MatlabReal).^2 ) ./ mean( abs( MatlabReal ).^2 );
%         disp("Quantization Error (Real Non Equalized)");
%         disp(QuantizeErrReal);
		SumQuantizeErrReal=SumQuantizeErrReal+QuantizeErrReal;
        
        QuantizeErrimag=mean( abs( HDLimag - Matlabimag).^2 ) ./ mean( abs( Matlabimag ).^2 ); 
%         disp("Quantization Error (imag Non Equalized)");
%         disp(QuantizeErrimag);
		SumQuantizeErrimag=SumQuantizeErrimag+QuantizeErrimag;

	end
	fprintf("============================================ \n");
    fprintf("Average QuantizeErrReal: %f\n", SumQuantizeErrReal/NumOfBlocks);
    fprintf("Average QuantizeErrimag: %f\n", SumQuantizeErrimag/NumOfBlocks);
	fprintf("Average QuantizeErr: %f\n", (SumQuantizeErrimag+SumQuantizeErrReal)/(2*NumOfBlocks));
	fprintf("============================================ \n");
end
