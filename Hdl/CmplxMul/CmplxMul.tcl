set CmplxMul_dir [file dirname [info script ]]

## Add all the files in dir folder
set obj [get_filesets sources_1]
set files [glob -dir ${CmplxMul_dir}/HDL *.sv]
add_files -norecurse -fileset $obj  $files

# # # Set IPs fileset 
# set obj [get_filesets sources_1]
# set IPSets [glob -dir ${CmplxMul_dir}/IP */*.xci]
# add_files -norecurse -fileset $obj $IPSets

## Open Script files of other Modules
source [glob -dir ${CmplxMul_dir}/Sub */ShReg.tcl]


## Add memory files in Modules folder 
#set obj [get_filesets sources_1]
#set MemoryFile [glob -dir ${CmplxMul_dir}/HDL *.mem]
#add_files -norecurse -fileset $obj $MemoryFile

## Add SystemVerilog Header files in Package folder
#set_property include_dirs ${CmplxMul_dir}/Libraries [current_fileset]

## Set TestBench fileset 
#set obj [get_filesets sim_1]
#set TestBench [glob -dir ${CmplxMul_dir}/TestBench *.sv]
#add_files -norecurse -fileset $obj $TestBench


