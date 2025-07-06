if {![file exists modelsim.ini]} {vmap -c }

rm -rf work

#vcom  ../hdl/common/2008/led_cnt_vhd08.vhd  -2008 -work work
#vlog  ../hdl/common/led_cnt.sv  -sv -work work
#vlog  ../hdl/tb/led_cnt_tb.sv   -sv -work work

vlog ../sub/msk_modem/hdl/mdl/lpf_fixed_mdl.sv        -sv -work work
vlog ../sub/msk_modem/hdl/mdl/polyphase_interp_mdl.sv -sv -work work
vlog ../sub/common/hdl/tb/file_read_simple.sv         -sv -work work
vlog ../sub/msk_modem/hdl/mdl/ddc_lpf_mdl.sv          -sv -work work
vlog ../sub/msk_modem/hdl/tb/polyphase_interp_tb.sv   -sv -work work

vsim  -vopt work.polyphase_interp_tb -voptargs=+acc -t ns

# ps resolution
#vsim  -vopt work.msk_tb -voptargs=+acc -t ps
#vsim  -vopt work.msk_tb -voptargs=+acc -t fs

log -r /*

if {[file exists wave.do]} {do wave.do}

run 5us