# zub
Avnet ZUBoard-1CG



# DFX in BD
PR must be a BDC
  the BDC is the PR so ports must match, but inside BD anything else goes
create BDC, double click it, check 'enable dynamic function exchange...' first RM
create additional BDCs, each being additional RMs
  right click the BDC -> create reconfigurable module
tools -> DFX wizard, create configs


### commands
set_part xczu1cg-sbva484-1-e
read_verilog ../hdl/RM0/led_cnt0.sv
read_verilog ../hdl/bd/led_cnt_wrapper.v
set_property source_mgmt_mode All [current_project]
source ../bd/led0.tcl

synth_design -mode out_of_context -top led0_inst_0 -part xczu1cg-sbva484-1-e

## ABANDONING THIS
trying to script DFX in the BD with BDCs... stupid.
  need to synth each BDC OOC ...
  then build static...

leaving this as project GUI only... if ever need to refer to
