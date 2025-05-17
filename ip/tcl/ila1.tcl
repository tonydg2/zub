set ipDir "../ip"
set modName "ila1"

if {![file exists $ipDir]} {error "ip directory not present"}

create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name $modName -dir $ipDir -force
set_property -dict [list \
  CONFIG.C_DATA_DEPTH {16384} \
  CONFIG.C_NUM_OF_PROBES {2} \
  CONFIG.C_PROBE0_WIDTH {6} \
  CONFIG.C_PROBE1_WIDTH {6} \
] [get_ips $modName]

if {"-gen" in $argv} {generate_target all [get_files $modName.xci]}

# Extra options:
#  CONFIG.C_ADV_TRIGGER {true} \
#  CONFIG.C_EN_STRG_QUAL {1} \
#  CONFIG.C_INPUT_PIPE_STAGES {6} \
#  CONFIG.C_TRIGIN_EN {true} \
#  CONFIG.C_TRIGOUT_EN {true} \
#  CONFIG.ALL_PROBE_SAME_MU_CNT {4} \     ## max=16
#  CONFIG.C_DATA_DEPTH {2048} \ 1024,2048,4096,8192,16384,32768,65536,131072