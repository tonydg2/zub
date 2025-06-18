# zub
Avnet ZUBoard-1CG  
vivado/vitis 2025.1

## GEM

## ------------------------------------------------------------------------------------------------
### BSP settings
#### lwip220  
lwip220_dhcp = TRUE  
lwip220_lwip_dhcp_does_acd_check = TRUE   
lwip220_pbuf_pool_size = 16384  
memp_n_pbuf = 1024  
mem_size = 524288  
n_rx_descriptors = 512  

#### xiltimer
XILTIMER_en_interval_timer  = TRUE  
XILTIMER_tick_timer         = psu_ttc_0  

* load examples then revert the following lwip220 configs:  
lwip220_dhcp                      = FALSE  
lwip220_lwip_dhcp_does_acd_check  = FALSE   

## ------------------------------------------------------------------------------------------------ 
### Vitis - echo server  
* New component -> From examples -> lwip echo server  
* will require enabling DHCP in lwip220 to generate (among other options).
* * after it's generated, go back and DISABLE DHCP (also dhcp_does_acp_check), with DHCP enabled, echo server will FAIL
* Copy modified xemacpsif_physpeed.c to:  
/platform/psu_cortexa53_0/standalone_psu_cortexa53_0/bsp/libsrc/lwip220/src/lwip-2.2.0/contrib/ports/xilinx/netif/xemacpsif_physpeed.c
* * RE-BUILD platform
* build and run echo server app

#### Host PC, ping 
* need to ping out of usb-to-eth adapter, not NIC:
* commands: 'ip link', 'ip route', 'ip addr'
> sudo ip addr add 192.168.1.100/24 dev enxd03745fbd50e
> ip route get 192.168.1.10
> ping 192.168.1.10

#### Host PC, telnet
> telnet 192.168.1.10 7  
* ctrl + ] to exit, then 'quit'

* xemacpsif_physpeed_ORIGINAL.c saved for comparison  

## ------------------------------------------------------------------------------------------------
### UDP perf server
* as above need to enable DHCP to load example, then disable and reload
* in the BSP xiltimer -> XILTIMER_tick_timer = psu_ttc_0. Without this, no bandwidth calculation.


#### host PC:
> sudo ip addr add 192.168.1.100/24 dev enxd03745fbd50e
> ip route get 192.168.1.10
> iperf -c 192.168.1.10 -i 1 -t 10 -u -b 100M

## ------------------------------------------------------------------------------------------------
python scripts not needed/used. iperf command sufficient  