set ipDir "../ip"
set modName "gpio"

if {![file exists $ipDir]} {error "ip directory not present"}

create_ip -name axi_gpio -vendor xilinx.com -library ip -version 2.0 -module_name $modName -dir $ipDir -force
set_property -dict [list \
  CONFIG.C_INTERRUPT_PRESENT {0} \
  CONFIG.C_IS_DUAL {1} \
  CONFIG.C_ALL_INPUTS {0} \
  CONFIG.C_ALL_INPUTS_2 {0} \
  CONFIG.C_ALL_OUTPUTS {0} \
  CONFIG.C_ALL_OUTPUTS_2 {0} \
] [get_ips $modName]

if {"-gen" in $argv} {generate_target all [get_files $modName.xci]}

########
