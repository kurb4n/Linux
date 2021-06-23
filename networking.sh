#-NETWORKING COMMANDS-#
/etc/sysconfig/network-scripts #is the location where all config files are located
ifconfig #this command is use to initialize an interface, assign IP Address to interface and enable or disable interface on demand. 
iwconfig #same that ifconfig but with wireless
ip addr #The ip command allows Linux users to quickly leverage the IP utility for manipulating the routing, devices, policy routing, and tunnels.
nslookup #obtain domain name or IP address mapping by querying the Domain Name System
         #"name server lookup", finds information about a named domain. We can also perform the above operation in reverse by providing the IP address rather than the domain name.
         #-type=ns/a/aaaa/mx/cname
wget #tool that allow to downloading contents from web servers.
dig #for query the DNS for network tshooting
    dig NS WEBSITE +short > to check nameservers
    dig WEBSITE +trace > to see the delegation path
    dig SOA WEBSITE @NAMESERVER > Look if a zone exists on a particular NS
    dig WEBSITE @X.X.X.X > Check what a particular resolver has in its cache.
    dig MX WEBSITE +short > to check the mail servers accepting emails
    dig -x X.X.X.X > to perform a reverse DNS check
    dig WEBSITE +nssearch > to check if your DNS zone is sync over all auth NS.
    dig +dnssec WEBSITE @NAMESERVER > to check RRSIG
    dig DNSKEY WEBSITE @NAMESERVER > to check ZSK key
    dig +short SOA WEBSITE @NAMESERVER > to check the zone

whois #tool for obtaining both domain and IP related information about a network.
ping
traceroute
netstat
    -a #list all ports
    -at #list all TCP ports
    -au #list all UDP ports
    -l #list only listening ports
    -lt #list only TCP listening ports
    -lu #list only UDP listening ports
    -s #show statistics for all ports

#---> NETWORK MANAGER
nmcli con show #display lisy of connections
    --active #display only active connections
nmcli dev status #display the device status
nmcli con add con-name “nameofthecon” type Ethernet ifname eth0 #add a connection
    -- ifname is the name of the Ethernet device; can find them by doing ls /sys/class/net
nmcli con reload #after modifying a network connection you should reload the config.
nmcli dev disconnect "device" #turn off the network device
nmcli dev connect "device" #turn on the network device
systemctl start NetworkManager
systemctl enable NetworkManager
systemctl restart network

#---> CURL
curl WEBSITE #GET request
    -I WEBSITE #returning only the HTTP headers of a URL
    -o FILE_NAME WEBSITE #saving the result of a curl command
    -H "HTTP-HEADER : VALUE" WEBSITE #adding an additional HTTP request header
    -H "HTTP-HEADER : VALUE" WEBSITE -v #generating additional information
    -I --http2 WEBSITE #check HTTP/2 support
    --request GET/POST/DELETE/PUT WEBSITE #curl examples to simulate HTTP methods

#- NETWORK NAMESPACES -#
ip netns add NSNAME #create a namespace
ip netns exec NSNAME COMMAND #execute a command like ip addr, arp, route
ip -n NSMANE COMMAND #its a shortcut of "netns exec"
ip link add VETH_NSNAME type veth peer name VETH_NSNAME2 #to create a "pipe" between 2 namespaces
ip link set VETH_NSNAME netns NSNAME #attach the virtual interface to the namespace NIC
ip link add VIRTUAL_NET type bridge #create a virtual network/switch
ip link set dev VIRTUAL_NET up/down #bring the virtual switch up or down
ip link set VET_NSNAME master VIRTUAL_NET #attach the interface to the virtual network/switch
ip -n NSNAME link del VET_NSNAME #
ip -n NSNAME addr add X.X.X.X dev VETH_NSNAME #attach a IP addres to the virtual interface
ip -n NSNAME link set VETH_NSNAME up/down #bring the virtual interface IP up or down
ip netns exec NSNAME ping X.X.X.X 
ip netns exec NSNAME arp
iprables -t nat -A POSTROUTING -s X.X.X.X -j MASQUERADE #do the NAT to reach the outside network