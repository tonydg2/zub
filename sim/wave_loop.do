onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /polyphase_interp_tb/pi_loop_filter_inst3/clk
add wave -noupdate -radix decimal /polyphase_interp_tb/pi_loop_filter_inst3/e_in_i
add wave -noupdate /polyphase_interp_tb/pi_loop_filter_inst3/e_valid_i
add wave -noupdate /polyphase_interp_tb/pi_loop_filter_inst3/u_pre
add wave -noupdate /polyphase_interp_tb/pi_loop_filter_inst3/u_prop
add wave -noupdate /polyphase_interp_tb/pi_loop_filter_inst3/acc
add wave -noupdate /polyphase_interp_tb/pi_loop_filter_inst3/ctrl
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {40145347 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 266
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
WaveRestoreZoom {39978922 ps} {40316583 ps}
