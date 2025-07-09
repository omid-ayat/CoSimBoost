function SaveResult(MatlabGoldenIO, RTLOutput, ConfigTable, NumOfConfigToRun)

    Adrs1='Result/MatlabOutput.mat';
    save(Adrs1,'MatlabGoldenIO');

    Adrs2='Result/RTLOutput.mat';
    save(Adrs2,'RTLOutput');
    
    
    Adrs4='Result/ConfigTable.mat';
    save(Adrs4,'ConfigTable');

    Adrs5='Result/NumOfConfigToRun.mat';
    save(Adrs5,'NumOfConfigToRun');

end

