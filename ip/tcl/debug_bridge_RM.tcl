set ipDir "../ip"
set modName "debug_bridge_RM"

if {![file exists $ipDir]} {error "ip directory not present"}

create_ip -name debug_bridge -vendor xilinx.com -library ip -version 3.0 -module_name $modName -dir $ipDir -force

set_property CONFIG.C_DESIGN_TYPE {1} [get_ips $modName]

if {"-gen" in $argv} {generate_target all [get_files $modName.xci]}

