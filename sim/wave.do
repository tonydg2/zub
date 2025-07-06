onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Analog-Step -height 84 -max 17017.0 -min -16915.0 -radix decimal /polyphase_interp_tb/ddc_mdl_inst/I_out
add wave -noupdate -format Analog-Step -height 84 -max 16965.999999999996 -min -16967.0 -radix decimal /polyphase_interp_tb/ddc_mdl_inst/Q_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5930 ns} 0}
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
WaveRestoreZoom {0 ns} {42 us}
