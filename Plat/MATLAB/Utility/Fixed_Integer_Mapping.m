%	=======================================================================
%	$ Converts float number to a fixed point number sutiable for hardware
%	implementation
%	-----------------------------------------------------------------------
%		$Version:	1.00.00.000
%		$Date:		2024-04-12
%		$Author(s):	Sayed Omid Ayat 
%		$Project:	CoVerification Training
%	-----------------------------------------------------------------------
%	-	Description & Usage/Examples:
%	=======================================================================
% 
function Output  = Fixed_Integer_Mapping(input,WordLength,FractionalPoint,SignFlag)
%% Main
if SignFlag==0 % Unsigned
    Output = round(input*(2^FractionalPoint));
    Output(Output>((2^WordLength)-1)) = (2^WordLength)-1; 
    Output(Output<0)                  = 0;   
    
else % Signed
    Output = round(input*(2^FractionalPoint));
    Output(Output>(2^(WordLength-1)-1))   = 2^(WordLength-1)-1;
    Output(Output<-(2^(WordLength-1)))    = -(2^(WordLength-1));
end

