set DUT_TOP_dir [file dirname [info script ]]

## Add all the files in dir folder
set obj [get_filesets sources_1]
set files [glob -dir ${DUT_TOP_dir}/HDL TopChain.sv]
add_files -norecurse -fileset $obj  $files

# # Set IPs fileset 
#set obj [get_filesets sources_1]
#set IPSets [glob -dir ${DUT_TOP_dir}/IP */*.xci]
#add_files -norecurse -fileset $obj $IPSets

## Open Script files of other Modules
#source [glob -dir ${DUT_TOP_dir}/SubMod */Script/QAM_Modulator.tcl]

source [glob -dir ${DUT_TOP_dir}/../../../.. /*/*/CmplxMul.tcl]


## Add memory files in Modules folder 
#set obj [get_filesets sources_1]
#set MemoryFile [glob -dir ${DUT_TOP_dir}/HDL *.mem]
#add_files -norecurse -fileset $obj $MemoryFile

# ## Add SystemVerilog Header files in Package folder
# set_property include_dirs ${DUT_TOP_dir}/Lib [current_fileset]

# ## Set TestBench fileset 
# set obj [get_filesets sim_1]
# set TestBench [glob -dir ${DUT_TOP_dir}/TestBench TB_TopChain.sv]
# add_files -norecurse -fileset $obj $TestBench


