set_property PACKAGE_PIN A7 [get_ports {led_0[0]}]; # HD_GPIO_RGB1_R 
set_property PACKAGE_PIN B6 [get_ports {led_0[1]}]; # HD_GPIO_RGB1_G 
set_property PACKAGE_PIN B5 [get_ports {led_0[2]}]; # HD_GPIO_RGB1_B 
set_property PACKAGE_PIN B4 [get_ports {led_1[0]}]; # HP_GPIO_RGB2_R 
set_property PACKAGE_PIN A2 [get_ports {led_1[1]}]; # HP_GPIO_RGB2_G 
set_property PACKAGE_PIN F4 [get_ports {led_1[2]}]; # HP_GPIO_RGB2_B 

set_property IOSTANDARD LVCMOS18 [get_ports {led*}]


#-----------------------------------------------------------------------
# BANK 44
#-----------------------------------------------------------------------
# Mikro Bus / MicroE Click 
set_property PACKAGE_PIN G6 [get_ports HD_CLICK_PWM]
set_property PACKAGE_PIN G5 [get_ports HD_CLICK_CS1_AN] ;# ADC
set_property PACKAGE_PIN G7 [get_ports HD_CLICK_CS0]
set_property PACKAGE_PIN F6 [get_ports HD_CLICK_SCK]
set_property PACKAGE_PIN E6 [get_ports HD_CLICK_MISO]
set_property PACKAGE_PIN E5 [get_ports HD_CLICK_MOSI]
set_property PACKAGE_PIN F8 [get_ports HD_CLICK_SCL]
set_property PACKAGE_PIN F7 [get_ports HD_CLICK_SDA]
set_property PACKAGE_PIN D7 [get_ports HD_CLICK_RX]
set_property PACKAGE_PIN D6 [get_ports HD_CLICK_TX]
set_property PACKAGE_PIN E8 [get_ports HD_CLICK_INT]
set_property PACKAGE_PIN D8 [get_ports HD_CLICK_RST]

set_property IOSTANDARD LVCMOS18 [get_ports {HD_CLICK*}]


#-----------------------------------------------------------------------
# Temp Sensor I2C STTS22HTR, ADDR=LOW

set_property PACKAGE_PIN B7 [get_ports HD_SENSOR_I2C_SDA]
set_property PACKAGE_PIN A6 [get_ports HD_SENSOR_I2C_SCL]

set_property IOSTANDARD LVCMOS18 [get_ports {HD_SENSOR_I2C*}]


#-----------------------------------------------------------------------
