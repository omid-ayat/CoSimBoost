function [RTLOut] = ReadRTLResults (Idx, ThisConfig)
    
    addrs_r     = strcat('HDL/Snrio/',num2str(Idx),'/Result/Output_C_Vector_Re_FxPt.txt');
    addrs_i     = strcat('HDL/Snrio/',num2str(Idx),'/Result/Output_C_Vector_Im_FxPt.txt');
    O_Real         = (importdata(addrs_r));
    O_Imag         = (importdata(addrs_i));
%     ComplexResult      = O_Real + (1i*O_Imag);

    for BlockIdx=1:ThisConfig.NumOfBlocks 
        if(size(O_Real,1)>=ThisConfig.RTLOutputBlockSize)
            RTLOut.O_Real{1,BlockIdx} = O_Real(1:ThisConfig.RTLOutputBlockSize);
            O_Real=O_Real(ThisConfig.RTLOutputBlockSize+1:end);

            RTLOut.O_Imag{1,BlockIdx} = O_Imag(1:ThisConfig.RTLOutputBlockSize);
            O_Imag=O_Imag(ThisConfig.RTLOutputBlockSize+1:end);
        else %if the result is too short, pad it with zeros
            RTLOut.O_Real{1,BlockIdx} = [O_Real(1:end); zeros(ThisConfig.RTLOutputBlockSize-size(O_Real,1),1)];

            RTLOut.O_Imag{1,BlockIdx} = [O_Imag(1:end); zeros(ThisConfig.RTLOutputBlockSize-size(O_Imag,1),1)];
        end
    end
end
