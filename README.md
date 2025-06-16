# zub
Avnet ZUBoard-1CG  

### GEM
Vitis - echo server  
* New component -> From examples -> lwip echo server  
* Copy modified xemacpsif_physpeed.c to:  
/platform/psu_cortexa53_0/standalone_psu_cortexa53_0/bsp/libsrc/lwip213/src/contrib/ports/xilinx/netif/xemacpsif_physpeed.c  
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


* xemacpsif_physpeed_ORIGINAL.c saved for comparison  

