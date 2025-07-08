onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /polyphase_interp_tb/gardner_ted_3_inst/clk
add wave -noupdate -expand -group ted /polyphase_interp_tb/gardner_ted_3_inst/i_in
add wave -noupdate -expand -group ted /polyphase_interp_tb/gardner_ted_3_inst/q_in
add wave -noupdate -expand -group ted /polyphase_interp_tb/gardner_ted_3_inst/iq_val
add wave -noupdate -expand -group ted /polyphase_interp_tb/gardner_ted_3_inst/sym_valid_i
add wave -noupdate -expand -group ted /polyphase_interp_tb/gardner_ted_3_inst/e_out_o
add wave -noupdate -expand -group ted /polyphase_interp_tb/gardner_ted_3_inst/e_valid_o
add wave -noupdate -expand -group loop /polyphase_interp_tb/pi_loop_filter_inst3/e_in_i
add wave -noupdate -expand -group loop /polyphase_interp_tb/pi_loop_filter_inst3/e_valid_i
add wave -noupdate -expand -group loop /polyphase_interp_tb/pi_loop_filter_inst3/ctrl_o
add wave -noupdate -expand -group loop /polyphase_interp_tb/pi_loop_filter_inst3/ctrl_val_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {435 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ns} {3434 ns}
