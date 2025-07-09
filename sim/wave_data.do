onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group NEW /polyphase_interp_tb/shifter_viewer_NEW/data_i
add wave -noupdate -expand -group NEW /polyphase_interp_tb/shifter_viewer_NEW/srh0
add wave -noupdate -expand -group NEW /polyphase_interp_tb/shifter_viewer_NEW/srh1
add wave -noupdate -expand -group NEW /polyphase_interp_tb/shifter_viewer_NEW/srh2
add wave -noupdate -expand -group NEW /polyphase_interp_tb/shifter_viewer_NEW/srh3
add wave -noupdate -expand -group OVERSAMP /polyphase_interp_tb/shifter_viewer_OVERSAMP/data_i
add wave -noupdate -expand -group OVERSAMP /polyphase_interp_tb/shifter_viewer_OVERSAMP/srh0
add wave -noupdate -expand -group OVERSAMP /polyphase_interp_tb/shifter_viewer_OVERSAMP/srh1
add wave -noupdate -expand -group OVERSAMP /polyphase_interp_tb/shifter_viewer_OVERSAMP/srh2
add wave -noupdate -expand -group OVERSAMP /polyphase_interp_tb/shifter_viewer_OVERSAMP/srh3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5767790 ps} 0}
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
WaveRestoreZoom {0 ps} {42 us}
