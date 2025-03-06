set_property PACKAGE_PIN A7 [get_ports {led_0[0]}]; # HD_GPIO_RGB1_R 
set_property PACKAGE_PIN B6 [get_ports {led_0[1]}]; # HD_GPIO_RGB1_G 
set_property PACKAGE_PIN B5 [get_ports {led_0[2]}]; # HD_GPIO_RGB1_B 
set_property PACKAGE_PIN B4 [get_ports {led_1[0]}]; # HP_GPIO_RGB2_R 
set_property PACKAGE_PIN A2 [get_ports {led_1[1]}]; # HP_GPIO_RGB2_G 
set_property PACKAGE_PIN F4 [get_ports {led_1[2]}]; # HP_GPIO_RGB2_B 

set_property IOSTANDARD LVCMOS18 [get_ports {led*}]
