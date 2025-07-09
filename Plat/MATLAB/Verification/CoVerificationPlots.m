function CoVerificationPlots(MatlabGoldenIO, RTLOutput,ConfigTable, NumOfConfigToRun )
    for ConfigIdx = 1:NumOfConfigToRun 
        %% initial definition
        Configs                 = ConfigTable(ConfigIdx,:);
        NumOfBlocks             = Configs.NumOfBlocks;

        for BlockIdx = 1 : NumOfBlocks 
            
            HDLreal=(RTLOutput{1, ConfigIdx}.O_Real{1, BlockIdx}).*2^(-ConfigTable.OutputFractionalPoint(ConfigIdx));
        	MatlabReal=real(MatlabGoldenIO{1, ConfigIdx}.Output_C{1, BlockIdx}); 
	
        	HDLimag=(RTLOutput{1, ConfigIdx}.O_Imag{1, BlockIdx}).*2^(-ConfigTable.OutputFractionalPoint(ConfigIdx));
        	Matlabimag=imag(MatlabGoldenIO{1, ConfigIdx}.Output_C{1, BlockIdx});

            figure; sgtitle("Config No" + ConfigIdx + ", Output Fractional Point :" + ConfigTable.OutputFractionalPoint(ConfigIdx));
            subplot(4,1,1);
            hold on; plot(HDLreal,'r');plot(MatlabReal, 'b');legend('HDL','Matlab');hold off;
            title("Matlab VS HDL (Real), Frame No" + BlockIdx   );
            subplot(4,1,2);
            plot(HDLreal-MatlabReal);
            title("Difference");
            
            subplot(4,1,3);
            hold on; plot(HDLimag,'r');plot(Matlabimag, 'b');legend('HDL','Matlab');hold off;
            title("Matlab VS HDL (Imag), Frame No" + BlockIdx  );
            subplot(4,1,4);
            plot(HDLimag-Matlabimag);
            title("Difference");


        end
        
    end

end

