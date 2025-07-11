onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /msk_tb_mdl_RX/gardner_ted_inst/clk
add wave -noupdate -expand -group ted -format Analog-Step -height 50 -max 18000.0 -min -18000.0 -radix decimal /msk_tb_mdl_RX/gardner_ted_inst/i_in
add wave -noupdate -expand -group ted -format Analog-Step -height 50 -max 18000.0 -min -18000.0 -radix decimal /msk_tb_mdl_RX/gardner_ted_inst/q_in
add wave -noupdate -expand -group ted /msk_tb_mdl_RX/gardner_ted_inst/iq_val
add wave -noupdate -expand -group ted /msk_tb_mdl_RX/gardner_ted_inst/sym_valid_i
add wave -noupdate -expand -group ted -format Analog-Step -height 84 -max 145.99999999999997 -min -288.0 -radix decimal /msk_tb_mdl_RX/gardner_ted_inst/e_out_o
add wave -noupdate -expand -group ted /msk_tb_mdl_RX/gardner_ted_inst/e_valid_o
add wave -noupdate -expand -group loop /msk_tb_mdl_RX/pi_loop_filter_inst/e_in_i
add wave -noupdate -expand -group loop /msk_tb_mdl_RX/pi_loop_filter_inst/e_valid_i
add wave -noupdate -expand -group loop /msk_tb_mdl_RX/pi_loop_filter_inst/ctrl_o
add wave -noupdate -expand -group loop /msk_tb_mdl_RX/pi_loop_filter_inst/ctrl_val_o
add wave -noupdate -expand -group phase /msk_tb_mdl_RX/phase_accum_inst/ctrl_i
add wave -noupdate -expand -group phase /msk_tb_mdl_RX/phase_accum_inst/ctrl_val_i
add wave -noupdate -expand -group phase /msk_tb_mdl_RX/phase_accum_inst/mu_o
add wave -noupdate -expand -group phase /msk_tb_mdl_RX/phase_accum_inst/phase_int_o
add wave -noupdate -expand -group phase /msk_tb_mdl_RX/phase_accum_inst/sym_valid_o
add wave -noupdate -expand -group phase /msk_tb_mdl_RX/phase_accum_inst/dec
add wave -noupdate -expand -group phase /msk_tb_mdl_RX/phase_accum_inst/inc
add wave -noupdate -expand -group phase /msk_tb_mdl_RX/phase_accum_inst/nom
add wave -noupdate -expand -group poly -radix decimal /msk_tb_mdl_RX/polyphase_interp_NEW/i_raw_i
add wave -noupdate -expand -group poly -radix decimal /msk_tb_mdl_RX/polyphase_interp_NEW/q_raw_i
add wave -noupdate -expand -group poly /msk_tb_mdl_RX/polyphase_interp_NEW/iq_raw_val_i
add wave -noupdate -expand -group poly /msk_tb_mdl_RX/polyphase_interp_NEW/mu_i
add wave -noupdate -expand -group poly /msk_tb_mdl_RX/polyphase_interp_NEW/phase_int_i
add wave -noupdate -expand -group poly /msk_tb_mdl_RX/polyphase_interp_NEW/sym_valid_i
add wave -noupdate -expand -group poly /msk_tb_mdl_RX/polyphase_interp_NEW/i_sym_o
add wave -noupdate -expand -group poly /msk_tb_mdl_RX/polyphase_interp_NEW/q_sym_o
add wave -noupdate -expand -group poly /msk_tb_mdl_RX/polyphase_interp_NEW/sym_valid_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {48032500 ps} 0}
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
WaveRestoreZoom {35334819 ps} {145508694 ps}
