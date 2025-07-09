-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
-- Date        : Tue Aug 29 11:21:44 2023
-- Host        : ITS00BE43956517 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub {c:/Users/sayedomid.ayat/University College Cork/ChirpComm-Team -
--               Documents/General/Workspace/Project/OFDMPlatform/FPGA/HdlMod/ChEst/Sub/ShReg/IP/ShReg/ShifReg_ChEst_1_stub.vhdl}
-- Design      : ShifReg_ChEst_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu48dr-ffvg1517-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShifReg_ChEst_1 is
  Port ( 
    A : in STD_LOGIC_VECTOR ( 3 downto 0 );
    D : in STD_LOGIC_VECTOR ( 105 downto 0 );
    CLK : in STD_LOGIC;
    CE : in STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 105 downto 0 )
  );

end ShifReg_ChEst_1;

architecture stub of ShifReg_ChEst_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "A[3:0],D[105:0],CLK,CE,Q[105:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "c_shift_ram_v12_0_14,Vivado 2021.2";
begin
end;
