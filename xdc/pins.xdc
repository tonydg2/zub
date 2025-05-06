set_property PACKAGE_PIN A7 [get_ports {led_0[0]}]; # HD_GPIO_RGB1_R 
set_property PACKAGE_PIN B6 [get_ports {led_0[1]}]; # HD_GPIO_RGB1_G 
set_property PACKAGE_PIN B5 [get_ports {led_0[2]}]; # HD_GPIO_RGB1_B 
set_property PACKAGE_PIN B4 [get_ports {led_1[0]}]; # HP_GPIO_RGB2_R 
set_property PACKAGE_PIN A2 [get_ports {led_1[1]}]; # HP_GPIO_RGB2_G 
set_property PACKAGE_PIN F4 [get_ports {led_1[2]}]; # HP_GPIO_RGB2_B 

set_property IOSTANDARD LVCMOS18 [get_ports {led*}]



create_pblock pblock_led_cnt_wrapper_0
resize_pblock pblock_led_cnt_wrapper_0 -add {SLICE_X2Y135:SLICE_X25Y151 DSP48E2_X0Y54:DSP48E2_X2Y59 RAMB18_X0Y54:RAMB18_X2Y59 RAMB36_X0Y27:RAMB36_X2Y29}
#add_cells_to_pblock pblock_led_cnt_wrapper_0 [get_cells [list top_bd_wrapper_inst/top_bd_i/led0]]
add_cells_to_pblock pblock_led_cnt_wrapper_0 [get_cells -hierarchical led0]

create_pblock pblock_led_cnt_wrapper_1
resize_pblock pblock_led_cnt_wrapper_1 -add {SLICE_X2Y75:SLICE_X25Y95 DSP48E2_X0Y30:DSP48E2_X2Y37 RAMB18_X0Y30:RAMB18_X2Y37 RAMB36_X0Y15:RAMB36_X2Y18}
#add_cells_to_pblock pblock_led_cnt_wrapper_1 [get_cells [list top_bd_wrapper_inst/top_bd_i/led1]]
add_cells_to_pblock pblock_led_cnt_wrapper_1 [get_cells -hierarchical led1]

