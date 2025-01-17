# 2025-01-17 12:47:38 by RouterOS 7.16.2
# software id = 8FQG-8SX1
#
# model = C53UiG+5HPaxD2HPaxD
# serial number = HGY0A83CV6F
/interface bridge
add name=hAp-ax3-bridge
/interface wifi
# DFS channel availability check (1 min)
set [ find default-name=wifi1 ] configuration.country=Netherlands .mode=ap .ssid=Droadloos2 disabled=no
set [ find default-name=wifi2 ] configuration.country=Netherlands .mode=ap .ssid=Droadloos1 disabled=no
/interface list
add name=LAN
add name=WAN
/ip pool
add name=dhcp_pool ranges=172.16.0.100-172.16.0.200
/ip dhcp-server
add address-pool=dhcp_pool interface=hAp-ax3-bridge lease-time=10m name=dhcp1
/interface bridge filter
# no interface
add action=drop chain=forward in-interface=*A
# no interface
add action=drop chain=forward out-interface=*A
# no interface
add action=drop chain=forward in-interface=*B
# no interface
add action=drop chain=forward out-interface=*B
/interface bridge port
add bridge=hAp-ax3-bridge disabled=yes interface=ether1
add bridge=hAp-ax3-bridge interface=ether2
add bridge=hAp-ax3-bridge interface=ether3
add bridge=hAp-ax3-bridge interface=ether4
add bridge=hAp-ax3-bridge interface=ether5
add bridge=hAp-ax3-bridge interface=wifi1
add bridge=hAp-ax3-bridge interface=wifi2
/interface list member
add interface=hAp-ax3-bridge list=LAN
add interface=ether1 list=WAN
/ip address
add address=172.16.0.1/24 interface=hAp-ax3-bridge network=172.16.0.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server network
add address=172.16.0.0/24 dns-server=172.16.0.1 gateway=172.16.0.1
/ip dns
set allow-remote-requests=yes servers=192.168.1.1
/ip firewall nat
add action=masquerade chain=srcnat out-interface-list=WAN
/system clock
set time-zone-name=Europe/Amsterdam
/system note
set show-at-login=no