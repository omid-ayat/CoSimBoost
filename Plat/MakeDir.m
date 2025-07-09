function MakeDir()
    % genpath get all folder in that
    addpath(genpath('MATLAB'));
    addpath(genpath('HDL'));

    if(exist('HDL/Snrio'))
        warning('OFF', 'MATLAB:RMDIR:RemovedFromPath');
        rmdir('HDL/Snrio','s');
        disp('Previous RTL Scenarios are completely removed.');
    end
    mkdir('HDL/Snrio');


    if(exist('Result'))
        warning('OFF', 'MATLAB:RMDIR:RemovedFromPath');
        rmdir('Result','s');
        disp('MATLAB Previous results completely removed.');
    end
    mkdir('Result')

end