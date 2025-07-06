
vlog ../sub/msk_modem/hdl/mdl/lpf_fixed_mdl.sv        -sv -work work
vlog ../sub/msk_modem/hdl/mdl/polyphase_interp_mdl.sv -sv -work work
vlog ../sub/common/hdl/tb/file_read_simple.sv         -sv -work work
vlog ../sub/msk_modem/hdl/mdl/ddc_lpf_mdl.sv          -sv -work work

# tb
vlog ../sub/msk_modem/hdl/tb/polyphase_interp_tb.sv   -sv -work work

