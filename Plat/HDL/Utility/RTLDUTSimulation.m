function [] = RTLDUTSimulation(Idx)
    mkdir(strcat('HDL/Snrio/',num2str(Idx),'/Prj'))
    addrs=strcat('HDL/Snrio/',num2str(Idx),'/Prj');
    
    display = ['Open Vivado for Senario Num # ',num2str(Idx)];
    disp(display);
     
    if ispc  
% 		string=['cd ' addrs '&C:\Xilinx\Vivado\2023.2\bin\vivado -mode tcl -source ../../../Src/Prj_TopChain.tcl'];        %(Without Vivado GUI),
		string=['cd ' addrs '&C:\Xilinx\Vivado\2021.2\bin\vivado -source ../../../Src/Prj_TopChain.tcl'];                  %(With Vivado GUI)
    else    % Ubuntu OS
% 	    string=['cd ' addrs ';vivado  -mode tcl -source ../../../Src/Prj_TopChain.tcl'];                   %(Without Vivado GUI)
    	string=['cd ' addrs ';vivado  -source ../../../Src/Prj_TopChain.tcl'];                             %(With Vivado GUI) 
    end
    
    system(string);
end