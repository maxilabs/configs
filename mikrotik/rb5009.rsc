# 2025-05-04 15:53:52 by RouterOS 7.16.2
# software id = 6PH6-YFG6
#
# model = RB5009UPr+S+
# serial number = HGP09HW9PGW
/interface bridge
add mtu=1514 name=iot
add admin-mac=D4:01:C3:F5:B4:89 auto-mac=no comment=defconf name=lan
add mtu=1514 name=wlan
/interface wireguard
add listen-port=51830 mtu=1420 name=wg0
/interface vlan
add interface=ether1 name=vlan300 vlan-id=300
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
add name=VPN
add name=TRUSTED
/ip pool
add name=default-dhcp ranges=192.168.88.10-192.168.88.254
/ip dhcp-server
add address-pool=default-dhcp interface=lan name=defconf
/disk settings
set auto-media-interface=lan auto-media-sharing=yes auto-smb-sharing=yes
/interface bridge port
add bridge=lan comment=defconf interface=ether2
add bridge=lan comment=defconf interface=ether3
add bridge=lan comment=defconf interface=ether4
add bridge=lan comment=defconf interface=ether5
add bridge=wlan comment=defconf interface=ether6
add bridge=iot comment=defconf interface=ether7
add bridge=iot comment=defconf interface=ether8
add bridge=lan comment=defconf interface=sfp-sfpplus1
/ip neighbor discovery-settings
set discover-interface-list=LAN
/interface list member
add comment=defconf interface=lan list=LAN
add comment=defconf interface=vlan300 list=WAN
add interface=wg0 list=VPN
add interface=lan list=TRUSTED
add interface=wg0 list=TRUSTED
/interface wireguard peers
add allowed-address=10.99.99.2/24 interface=wg0 name=peer1 persistent-keepalive=25s public-key="JXPzqcEX4hXjj5g722ssadmzFFlLh0dou8rNCrLUc2s="
/ip address
add address=192.168.88.1/24 comment=defconf interface=lan network=192.168.88.0
add address=10.99.99.1/24 interface=wg0 network=10.99.99.0
/ip dhcp-client
add comment=defconf interface=vlan300
/ip dhcp-server lease
add address=192.168.88.16 client-id=1:a8:a1:59:51:70:f3 mac-address=A8:A1:59:51:70:F3 server=defconf
add address=192.168.88.32 client-id=1:60:45:cb:9b:d4:6 mac-address=60:45:CB:9B:D4:06 server=defconf
/ip dhcp-server network
add address=192.168.88.0/24 comment=defconf dns-server=192.168.88.1 gateway=192.168.88.1
/ip dns
set allow-remote-requests=yes
/ip dns static
add address=192.168.88.1 comment=defconf name=router.lan type=A
add address=192.168.88.32 name=vaultwarden.maxilabs.nl type=A
add address=192.168.88.32 name=portainer.maxilabs.nl type=A
add address=192.168.88.32 name=cockpit.maxilabs.nl type=A
add address=192.168.88.32 name=nextcloud.maxilabs.nl type=A
add address=192.168.88.32 name=kopia.maxilabs.nl type=A
add address=192.168.88.16 name=host.docker.internal type=A
add address=192.168.88.16 name=gateway.docker.internal type=A
add address=192.168.88.32 name=elysium.maxilabs.nl type=A
add address=192.168.88.32 name=mattermost.maxilabs.nl type=A
add address=192.168.88.32 name=immich.maxilabs.nl type=A
/ip firewall address-list
add address=89.205.132.236 comment="Trusted IP" list=https_whitelist
add address=93.95.250.154 comment="Trusted IP" list=https_whitelist
add address=95.99.122.165 comment="Trusted IP" list=https_whitelist
add address=84.241.198.171 comment="Trusted IP" list=https_whitelist
add address=31.187.153.43 comment="Trusted IP" list=https_whitelist
add address=89.205.140.133 comment="Trusted IP" list=https_whitelist
add address=84.241.201.97 comment="Trusted IP" list=https_whitelist
add address=93.95.250.42 comment="Trusted IP" list=https_whitelist
/ip firewall filter
add action=accept chain=input comment="defconf: accept established,related,untracked" connection-state=established,related,untracked
add action=drop chain=input comment="defconf: drop invalid" connection-state=invalid
add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
add action=accept chain=input comment="defconf: accept to local loopback (for CAPsMAN)" dst-address=127.0.0.1
add action=drop chain=input comment="defconf: drop all not coming from TRUSTED" in-interface-list=!TRUSTED
add action=accept chain=forward comment="defconf: accept in ipsec policy" ipsec-policy=in,ipsec
add action=accept chain=forward comment="defconf: accept out ipsec policy" ipsec-policy=out,ipsec
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" connection-state=established,related hw-offload=yes
add action=accept chain=forward comment="defconf: accept established,related, untracked" connection-state=established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" connection-state=invalid
add action=drop chain=forward comment="defconf: drop all from WAN not DSTNATed" connection-nat-state=!dstnat connection-state=new in-interface-list=WAN
add action=accept chain=forward comment="Allow HTTPS to 192.168.88.32" dst-address=192.168.88.32 dst-port=443 in-interface-list=WAN protocol=tcp src-address-list=https_whitelist
add action=drop chain=forward comment="Drop non-whitelisted HTTPS traffic" dst-address=192.168.88.32 dst-port=443 in-interface-list=WAN protocol=tcp
add action=accept chain=forward comment="Allow Enshrouded UDP" dst-address=192.168.88.32 dst-port=15637 in-interface-list=WAN protocol=udp
add action=accept chain=forward comment="Allow Enshrouded TCP" dst-address=192.168.88.32 dst-port=15637 in-interface-list=WAN protocol=tcp
add action=accept chain=input comment="Allow WireGuard VPN" port=51830 protocol=udp
add action=accept chain=forward comment="Allow VPN clients to communicate" src-address=10.99.99.0/24
add action=accept chain=input comment="Allow VPN clients to reach router" dst-address=10.99.99.1 in-interface=wg0 src-address=10.99.99.0/24
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" ipsec-policy=out,none out-interface-list=WAN
add action=dst-nat chain=dstnat comment="Forward HTTPS to 192.168.88.32" dst-port=443 in-interface-list=WAN protocol=tcp to-addresses=192.168.88.32
add action=dst-nat chain=dstnat comment="Enshrouded TCP" dst-port=15637 in-interface-list=WAN protocol=tcp to-addresses=192.168.88.32
add action=dst-nat chain=dstnat comment="Enshrouded UDP" dst-port=15637 in-interface-list=WAN protocol=udp to-addresses=192.168.88.32
add action=masquerade chain=srcnat comment="Allow VPN clients to access the internet" src-address=10.99.99.0/24
/ipv6 firewall address-list
add address=::/128 comment="defconf: unspecified address" list=bad_ipv6
add address=::1/128 comment="defconf: lo" list=bad_ipv6
add address=fec0::/10 comment="defconf: site-local" list=bad_ipv6
add address=::ffff:0.0.0.0/96 comment="defconf: ipv4-mapped" list=bad_ipv6
add address=::/96 comment="defconf: ipv4 compat" list=bad_ipv6
add address=100::/64 comment="defconf: discard only " list=bad_ipv6
add address=2001:db8::/32 comment="defconf: documentation" list=bad_ipv6
add address=2001:10::/28 comment="defconf: ORCHID" list=bad_ipv6
add address=3ffe::/16 comment="defconf: 6bone" list=bad_ipv6
/ipv6 firewall filter
add action=accept chain=input comment="defconf: accept established,related,untracked" connection-state=established,related,untracked
add action=drop chain=input comment="defconf: drop invalid" connection-state=invalid
add action=accept chain=input comment="defconf: accept ICMPv6" protocol=icmpv6
add action=accept chain=input comment="defconf: accept UDP traceroute" dst-port=33434-33534 protocol=udp
add action=accept chain=input comment="defconf: accept DHCPv6-Client prefix delegation." dst-port=546 protocol=udp src-address=fe80::/10
add action=accept chain=input comment="defconf: accept IKE" dst-port=500,4500 protocol=udp
add action=accept chain=input comment="defconf: accept ipsec AH" protocol=ipsec-ah
add action=accept chain=input comment="defconf: accept ipsec ESP" protocol=ipsec-esp
add action=accept chain=input comment="defconf: accept all that matches ipsec policy" ipsec-policy=in,ipsec
add action=drop chain=input comment="defconf: drop everything else not coming from LAN" in-interface-list=!LAN
add action=accept chain=forward comment="defconf: accept established,related,untracked" connection-state=established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" connection-state=invalid
add action=drop chain=forward comment="defconf: drop packets with bad src ipv6" src-address-list=bad_ipv6
add action=drop chain=forward comment="defconf: drop packets with bad dst ipv6" dst-address-list=bad_ipv6
add action=drop chain=forward comment="defconf: rfc4890 drop hop-limit=1" hop-limit=equal:1 protocol=icmpv6
add action=accept chain=forward comment="defconf: accept ICMPv6" protocol=icmpv6
add action=accept chain=forward comment="defconf: accept HIP" protocol=139
add action=accept chain=forward comment="defconf: accept IKE" dst-port=500,4500 protocol=udp
add action=accept chain=forward comment="defconf: accept ipsec AH" protocol=ipsec-ah
add action=accept chain=forward comment="defconf: accept ipsec ESP" protocol=ipsec-esp
add action=accept chain=forward comment="defconf: accept all that matches ipsec policy" ipsec-policy=in,ipsec
add action=drop chain=forward comment="defconf: drop everything else not coming from LAN" in-interface-list=!LAN
/system clock
set time-zone-name=Europe/Amsterdam
/system note
set show-at-login=no
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN