
# #########################################################################################################
# #########################################################################################################
# # Create Project
set _xil_proj_name_ "VPrj"
# #  Its where the TCL file is located
set origin_dir [file dirname [info script ]] 



create_project -force ${_xil_proj_name_} ./${_xil_proj_name_} -part  xczu48dr-ffvg1517-2-e



# #########################################################################################################
# #########################################################################################################
# # Add Source

#Call IP add sources
source [glob -dir ${origin_dir} */TopChain.tcl]

# Add SystemVerilog files in Snrio/*/TestVector folders 
set obj [get_filesets sources_1]
set SVModules [glob -dir ${origin_dir}/../Snrio */*/*.sv]
add_files -norecurse -fileset $obj $SVModules

# Add memory files in Modules folder 
#set obj [get_filesets sources_1]
#set MemoryFile [glob -dir ${origin_dir}/../Snrio */*/*.mem]
#add_files -norecurse -fileset $obj $MemoryFile


## Add SystemVerilog Header files in Lib folder
set_property include_dirs ${DUT_TOP_dir}/Lib_InterfaceSV [current_fileset]

## Set TestBench fileset 
set obj [get_filesets sim_1]
set TestBench [glob -dir ${DUT_TOP_dir}/TestBench TB_TopChain.sv]
add_files -norecurse -fileset $obj $TestBench


update_compile_order

set_property -name "top" -value "TopChain" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj



set obj [get_filesets sim_1]
set_property -name "top" -value "TB_TopChain" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj


set_property target_simulator XSim [current_project]
launch_simulation
restart
run all

# #########################################################################################################
# ########################################################################################################
exit
