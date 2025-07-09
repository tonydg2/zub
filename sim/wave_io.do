onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /polyphase_interp_tb/gardner_ted_3_inst/clk
add wave -noupdate -expand -group ted -format Analog-Step -height 50 -max 18000.0 -min -18000.0 -radix decimal /polyphase_interp_tb/gardner_ted_3_inst/i_in
add wave -noupdate -expand -group ted -format Analog-Step -height 50 -max 18000.0 -min -18000.0 -radix decimal /polyphase_interp_tb/gardner_ted_3_inst/q_in
add wave -noupdate -expand -group ted /polyphase_interp_tb/gardner_ted_3_inst/iq_val
add wave -noupdate -expand -group ted /polyphase_interp_tb/gardner_ted_3_inst/sym_valid_i
add wave -noupdate -expand -group ted -format Analog-Step -height 40 -max 20.0 -min -20.0 -radix decimal /polyphase_interp_tb/gardner_ted_3_inst/e_out_o
add wave -noupdate -expand -group ted /polyphase_interp_tb/gardner_ted_3_inst/e_valid_o
add wave -noupdate -expand -group loop /polyphase_interp_tb/pi_loop_filter_inst3/e_in_i
add wave -noupdate -expand -group loop /polyphase_interp_tb/pi_loop_filter_inst3/e_valid_i
add wave -noupdate -expand -group loop /polyphase_interp_tb/pi_loop_filter_inst3/ctrl_o
add wave -noupdate -expand -group loop /polyphase_interp_tb/pi_loop_filter_inst3/ctrl_val_o
add wave -noupdate -expand -group phase /polyphase_interp_tb/phase_accum_inst/ctrl_i
add wave -noupdate -expand -group phase /polyphase_interp_tb/phase_accum_inst/ctrl_val_i
add wave -noupdate -expand -group phase /polyphase_interp_tb/phase_accum_inst/mu_o
add wave -noupdate -expand -group phase /polyphase_interp_tb/phase_accum_inst/phase_int_o
add wave -noupdate -expand -group phase /polyphase_interp_tb/phase_accum_inst/sym_valid_o
add wave -noupdate -expand -group phase /polyphase_interp_tb/phase_accum_inst/dec
add wave -noupdate -expand -group phase /polyphase_interp_tb/phase_accum_inst/inc
add wave -noupdate -expand -group phase /polyphase_interp_tb/phase_accum_inst/nom
add wave -noupdate -expand -group poly -radix decimal /polyphase_interp_tb/polyphase_interp_NEW/i_raw_i
add wave -noupdate -expand -group poly -radix decimal /polyphase_interp_tb/polyphase_interp_NEW/q_raw_i
add wave -noupdate -expand -group poly /polyphase_interp_tb/polyphase_interp_NEW/iq_raw_val_i
add wave -noupdate -expand -group poly /polyphase_interp_tb/polyphase_interp_NEW/mu_i
add wave -noupdate -expand -group poly /polyphase_interp_tb/polyphase_interp_NEW/phase_int_i
add wave -noupdate -expand -group poly /polyphase_interp_tb/polyphase_interp_NEW/sym_valid_i
add wave -noupdate -expand -group poly /polyphase_interp_tb/polyphase_interp_NEW/i_sym_o
add wave -noupdate -expand -group poly /polyphase_interp_tb/polyphase_interp_NEW/q_sym_o
add wave -noupdate -expand -group poly /polyphase_interp_tb/polyphase_interp_NEW/sym_valid_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2782500 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 209
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {40507229 ps}
