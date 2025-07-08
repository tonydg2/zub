onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group demod_mdl_good /polyphase_interp_tb/shifter_viewer_OVERSAMP/srh0
add wave -noupdate -group demod_mdl_good /polyphase_interp_tb/shifter_viewer_OVERSAMP/srh1
add wave -noupdate -group demod_mdl_good /polyphase_interp_tb/shifter_viewer_OVERSAMP/srh2
add wave -noupdate -group demod_mdl_good /polyphase_interp_tb/shifter_viewer_OVERSAMP/srh3
add wave -noupdate -format Analog-Step -height 84 -max 17.000000000000004 -min -158.0 -radix decimal /polyphase_interp_tb/phase_accum_inst/ctrl_i
add wave -noupdate /polyphase_interp_tb/phase_accum_inst/ctrl_val_i
add wave -noupdate -format Analog-Step -height 84 -max 387.99999999999994 -min -194.0 -radix decimal /polyphase_interp_tb/pi_loop_filter_inst3/e_in_i
add wave -noupdate -format Analog-Step -height 84 -max 17017.0 -min -16915.0 -radix decimal /polyphase_interp_tb/gardner_ted_3_inst/i_in
add wave -noupdate -format Analog-Step -height 84 -max 16965.999999999996 -min -16967.0 -radix decimal /polyphase_interp_tb/gardner_ted_3_inst/q_in
add wave -noupdate /polyphase_interp_tb/gardner_ted_3_inst/iq_val
add wave -noupdate /polyphase_interp_tb/gardner_ted_3_inst/sym_valid_i
add wave -noupdate /polyphase_interp_tb/phase_accum_inst/dec
add wave -noupdate /polyphase_interp_tb/phase_accum_inst/inc
add wave -noupdate /polyphase_interp_tb/phase_accum_inst/nom
add wave -noupdate /polyphase_interp_tb/msk_slicer_dec_NEW/i_sym_i
add wave -noupdate /polyphase_interp_tb/msk_slicer_dec_NEW/sym_valid_i
add wave -noupdate /polyphase_interp_tb/polyphase_interp_NEW/iq_raw_val_i
add wave -noupdate /polyphase_interp_tb/polyphase_interp_NEW/i_raw_i
add wave -noupdate /polyphase_interp_tb/i_fir_NEW
add wave -noupdate /polyphase_interp_tb/polyphase_interp_NEW/idelay
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5687500 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 255
configure wave -valuecolwidth 311
configure wave -justifyvalue left
configure wave -signalnamewidth 2
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {2500 ns}
