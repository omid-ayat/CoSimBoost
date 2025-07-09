// %%	=======================================================================
// %	$Interface 
// %	-----------------------------------------------------------------------
// %		$Version:	1.00.00.000
// %		$Date:		2024-04-12
// %		$Author(s):	Sayed Omid Ayat 
// %		$Project:	CoVerification Training
// %	-----------------------------------------------------------------------
// %	-	Description & Usage/Examples:
// %%	=======================================================================


// =================================================================================
// axi Packet
// =================================================================================
interface axi_packet
    #(
        DATA_WIDTH                              = 16,
        LANE	                                = 2
    )(
        clk, 
        reset
    );
    input   logic                               clk;            
    input   logic                               reset; 

            logic   signed [DATA_WIDTH-1:0]     bus [LANE];   

            logic                               tvalid;
            logic                               tready;

            logic                               tlast;
            logic                               tfirst;
            
    modport master
    (
        input   reset,  clk,    tready,
        output  tvalid, tlast,  bus,    tfirst
    );
                                
    modport slave  
    (
        input   reset,  clk,    tlast,  tfirst, tvalid, bus,    
        output  tready
    );
                                                    
endinterface

// =================================================================================
// axi Config  
// =================================================================================
interface axi_config_OCDM 
    (
        clk, 
        reset
    );

    //------------------------------------------------
    // Don't modify these parameters
    //------------------------------------------------
    localparam  MODUL_WIDTH                     = 3;
    //------------------------------------------------

    input   logic                               clk;            
    input   logic                               reset; 

 
            logic   [MODUL_WIDTH-1 :0]          modulation; 
            logic                               tvalid;    
            
    modport master
    (
        input   reset,  clk,
        output  tvalid, modulation
    );
                                
    modport slave  
    (
        input   tvalid, reset, clk, modulation
    );
                                                    
endinterface
