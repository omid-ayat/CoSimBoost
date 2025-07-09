set ShiftReg_dir [file dirname [info script ]]

## Add all the files in dir folder
set obj [get_filesets sources_1]
set files [glob -dir ${ShiftReg_dir}/HDL *.sv]
add_files -norecurse -fileset $obj  $files

# # Set IPs fileset 
set obj [get_filesets sources_1]
set IPSets [glob -dir ${ShiftReg_dir}/IP */*.xci]
add_files -norecurse -fileset $obj $IPSets

## Open Script files of other Modules
# source [glob -dir ${ShiftReg_dir}/Modules */Script/CIC_Decimation.tcl]

## Add memory files in Modules folder 
#set obj [get_filesets sources_1]
#set MemoryFile [glob -dir ${ShiftReg_dir}/Mem *.mem]
#add_files -norecurse -fileset $obj $MemoryFile

## Add SystemVerilog Header files in Package folder
#set_property include_dirs ${ShiftReg_dir}/Lib [current_fileset]

## Set TestBench fileset 
#set obj [get_filesets sim_1]
#set TestBench [glob -dir ${ShiftReg_dir}/TestBench *.sv]
#add_files -norecurse -fileset $obj $TestBench


