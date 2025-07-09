%	=======================================================================
%	$ Coverifaction Matlab code
%	-----------------------------------------------------------------------
%		$Version:	1.00.00.000
%		$Date:		2024-04-12
%		$Author(s):	Sayed Omid Ayat 
%		$Project:	CoVerification Training
%	-----------------------------------------------------------------------
%	-	Description & Usage/Examples:
%	=======================================================================
%% initial
    clc;
    close all;
    fclose ('all');
    clear all;

%% make path and directory and delete previous result
    MakeDir();
    
%% read config
    ConfigTable                    = ReadConfigFromExcel;        

%% run all scenarios
    NumOfConfigToRun                    = size(ConfigTable,1);
    MatlabGoldenIO                      = cell(1, NumOfConfigToRun);
    RTLOutput                           = cell(1, NumOfConfigToRun);
    TestVector                          = cell(1, NumOfConfigToRun);
 
    
%     delete(gcp('nocreate'))
%     parpool('local', 8);
    NumOfConfigToRun=1;

    for ConfigIdx = 1:NumOfConfigToRun 
        Config     = ConfigTable(ConfigIdx,:);

        %% make the folders
        mkdir(['HDL/Snrio/',num2str(ConfigIdx),'/TestVector'])
        mkdir(['HDL/Snrio/',num2str(ConfigIdx),'/Result'])

        %% Matlab             
        [MatlabGoldenIO{1,ConfigIdx}]   = MatlabDUT(Config, ConfigIdx);  


        %% Run RTL
        RTLOutput{1,ConfigIdx}          = DUTRTLImplementation(MatlabGoldenIO{1,ConfigIdx},Config,ConfigIdx);
    end

    %% Save Results
    SaveResult(MatlabGoldenIO, RTLOutput, ConfigTable, NumOfConfigToRun);

    %% Verification
	QuantizationError(MatlabGoldenIO, RTLOutput,ConfigTable, NumOfConfigToRun );


	%% Plots
	CoVerificationPlots(MatlabGoldenIO, RTLOutput,ConfigTable, NumOfConfigToRun )




    


   
