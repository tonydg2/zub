set tbFile msk_tb_mdl_RX

#--------------------------------------------------------------------------------------------------
# msk
#--------------------------------------------------------------------------------------------------
set mskDir ../sub/msk_modem/hdl
set mskFiles { \
  mdl/lpf_fixed_mdl.sv \
  mdl/polyphase_interp_mdl.sv \
  mdl/ddc_lpf_mdl.sv \
  mdl/gardner_ted_mdl.sv \
  mdl/loop_filter_mdl.sv \
  mdl/phase_accum_mdl.sv \
  mdl/msk_slicer_dec_mdl.sv \
  mdl/msk_demod_mdl.sv \
  mdl/mf_taps_pkg.sv \
  mdl/rrc_mf_mdl.sv \
  mdl/rrc_mf_mdl_0.sv \
  mdl/msk_mf.sv \
}  

foreach x $mskFiles {
  vlog $mskDir/$x -sv -work work
}


#--------------------------------------------------------------------------------------------------
# common
#--------------------------------------------------------------------------------------------------
set comDir ../sub/common/hdl
set comFiles {\
  tb/file_read_simple.sv \
  shifter_viewer.sv \
}

foreach x $comFiles {
  vlog $comDir/$x -sv -work work
}


#--------------------------------------------------------------------------------------------------
# tb
#--------------------------------------------------------------------------------------------------
vlog $mskDir/tb/$tbFile.sv   -sv -work work

