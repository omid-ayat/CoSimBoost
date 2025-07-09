%% Do not Modify this Code

function RTLOutput=DUTRTLImplementation(TestVector2,ThisConfig,Idx)

    WriteParameters(ThisConfig,Idx);                      % write in <.sv file>:: RTL/Scenarios/#num/TestVector/parameters
    WriteInputTextFile(TestVector2,Idx,ThisConfig);
    
    % call vivado
    RTLDUTSimulation(Idx);                            % generate the vivado project and run the test bench in <.tct>
    
   RTLOutput = ReadRTLResults(Idx,ThisConfig);         % new verion 
end

