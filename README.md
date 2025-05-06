# zub
Avnet ZUBoard-1CG

# DFX UG909

# DFX in BD Project regeneration
generate project
  > tclsh BUILD.tcl -name PRJ0 -proj -multBD
open proj: tools -> enable DFX
add top_io.sv, set as top
add pins.xdc
add led_cnt0.sv, led_cnt1.sv

Partition Definitions tab in Sources... add directories
  add dirs of each BDC 
    PRJ0.srcs -> sources_1 -> bd -> add each BDC dir
  generate block design
  tools -> DFX wizard, auto configure for abstract shell
  generate bitstream

# DFX in BD notes
PR must be a BDC
  the BDC is the PR so ports must match, but inside BD anything else goes
create BDC, double click it, check 'enable dynamic function exchange...' first RM
create additional BDCs, each being additional RMs
  right click the BDC -> create reconfigurable module
tools -> DFX wizard, create configs


### commands testing 
set_part xczu1cg-sbva484-1-e
read_verilog ../hdl/RM0/led_cnt0.sv
read_verilog ../hdl/bd/led_cnt_wrapper.v
set_property source_mgmt_mode All [current_project]
source ../bd/led0.tcl

synth_design -mode out_of_context -top led0_inst_0 -part xczu1cg-sbva484-1-e
### nope. done.

## ABANDONING THIS
trying to script DFX in the BD with BDCs... stupid.
  need to synth each BDC OOC ...
  then build static...

leaving this as project GUI only... if ever need to refer to
