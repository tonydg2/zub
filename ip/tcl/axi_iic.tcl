set ipDir "../ip"
set modName "axi_iic_0"

if {![file exists $ipDir]} {error "ip directory not present"}

create_ip -name axi_iic -vendor xilinx.com -library ip -version 2.1 -module_name $modName -dir $ipDir -force
set_property -dict [list \
  CONFIG.AXI_ACLK_FREQ_MHZ {100} \
  CONFIG.C_DEFAULT_VALUE {0x00} \
  CONFIG.C_GPO_WIDTH {1} \
  CONFIG.C_SCL_INERTIAL_DELAY {0} \
  CONFIG.C_SDA_INERTIAL_DELAY {0} \
  CONFIG.C_SDA_LEVEL {1} \
  CONFIG.IIC_FREQ_KHZ {100} \
  CONFIG.TEN_BIT_ADR {7_bit} \
] [get_ips $modName]

if {"-gen" in $argv} {generate_target all [get_files $modName.xci]}

