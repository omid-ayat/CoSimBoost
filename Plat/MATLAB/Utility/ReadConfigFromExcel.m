%% Modified for CIC
function [data] = ReadConfigFromExcel()
	workbookFile = 'ConfigsORG.xlsx';
    data=readtable(workbookFile);end