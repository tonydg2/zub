if {![file exists modelsim.ini]} {vmap -c }

rm -rf work

do files0.do

vsim  -vopt work.polyphase_interp_tb -voptargs=+acc -t ns

# ps resolution
#vsim  -vopt work.msk_tb -voptargs=+acc -t ps
#vsim  -vopt work.msk_tb -voptargs=+acc -t fs

log -r /*

if {[file exists wave.do]} {do wave.do}

run 5us

