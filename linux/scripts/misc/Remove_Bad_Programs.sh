#!/bin/bash

if [[ $EUID -ne 0 ]]
then
  echo This script must be run as root
  exit
fi
# "Script is being run as root."

# "The current OS is Linux Ubuntu."

#
apt-get purge netcat -y -qq
apt-get purge netcat-openbsd -y -qq
apt-get purge netcat-traditional -y -qq
apt-get purge ncat -y -qq
apt-get purge pnetcat -y -qq
apt-get purge socat -y -qq
apt-get purge sock -y -qq
apt-get purge socket -y -qq
apt-get purge sbd -y -qq
#rm /usr/bin/nc
# "Netcat and all other instances have been removed."
echo -e "Netcat and all other instances have been removed."
# 2s

#
apt-get purge john -y -qq
apt-get purge john-data -y -qq
# "John the Ripper has been removed."
echo -e "John the Ripper has been removed."
# 2s

#
apt-get purge hydra -y -qq
apt-get purge hydra-gtk -y -qq
# "Hydra has been removed."
echo -e "Hydra has been removed."
# 2s

#
apt-get purge aircrack-ng -y -qq
# "Aircrack-NG has been removed."
echo -e "Aircrack-NG has been removed."
# 2s

#
apt-get purge fcrackzip -y -qq
# "FCrackZIP has been removed."
echo -e "FCrackZIP has been removed."
# 2s

#
apt-get purge lcrack -y -qq
# "LCrack has been removed."
echo -e "LCrack has been removed."
# 2s

#
apt-get purge ophcrack -y -qq
apt-get purge ophcrack-cli -y -qq
# "OphCrack has been removed."
echo -e "OphCrack has been removed."
# 2s

#
apt-get purge pdfcrack -y -qq
# "PDFCrack has been removed."
echo -e "PDFCrack has been removed."
# 2s

#
apt-get purge pyrit -y -qq
# "Pyrit has been removed."
echo -e "Pyrit has been removed."
# 2s

#
apt-get purge rarcrack -y -qq
# "RARCrack has been removed."
echo -e "RARCRACK has been removed"
# 2s

#
apt-get purge sipcrack -y -qq
# "SipCrack has been removed."
echo -e "SipCrack has been removed."
# 2s

#
apt-get purge crack -y -qq
apt-get purge crack-common -y -qq
# "Crack has been Removed."
echo -e "Crack has beem Removed."
# 2s

#
apt-get purge irpas -y -qq
# "IRPAS has been removed."
echo -e "IRPAS has been removed."
# 2s

#
# 'Are there any hacking tools shown? (not counting libcrack2:amd64 or cracklib-runtime)'
#dpkg -l | egrep "crack|hack" >> ~/Desktop/possible_hacking_tools.log

#
apt-get purge logkeys -y -qq
# "LogKeys has been removed."
echo -e "LogKeys has been removed."
# 2s

#
apt-get purge etherwake -y -qq
# "Etherwake has been Removed."
echo -e "Etherwake has been Removed."
# 2s

#
apt-get purge zeitgeist-core -y -qq
apt-get purge zeitgeist-datahub -y -qq
apt-get purge python-zeitgeist -y -qq
apt-get purge rhythmbox-plugin-zeitgeist -y -qq
apt-get purge zeitgeist -y -qq
# "Zeitgeist has been removed."
echo -e "Zeitgeist has been removed."
# 2s

#
#apt-get purge nfs-kernel-server -y -qq
#apt-get purge nfs-common -y -qq
apt-get purge portmap -y -qq
apt-get purge rpcbind -y -qq
apt-get purge autofs -y -qq
# "NFS has been removed."
echo -e "NFS has been removed"
# 2s

#
apt-get purge nmap -y -qq
apt-get purge zenmap -y -qq
# "NMAPs' has been removed."
# 2s

#apt-get purge inetd -y -qq
#apt-get purge openbsd-inetd -y -qq
#apt-get purge xinetd -y -qq
#apt-get purge inetutils-ftp -y -qq
#apt-get purge inetutils-ftpd -y -qq
#apt-get purge inetutils-inetd -y -qq
#apt-get purge inetutils-ping -y -qq
#apt-get purge inetutils-syslogd -y -qq
#apt-get purge inetutils-talk -y -qq
#apt-get purge inetutils-talkd -y -qq
#apt-get purge inetutils-telnet -y -qq
#apt-get purge inetutils-telnetd -y -qq
#apt-get purge inetutils-tools -y -qq
#apt-get purge inetutils-traceroute -y -qq
## "Inetd (super-server) and all inet utilities have been removed."
#echo -e "Inetd (super-server) and all inet utilities have been removed."

#
apt-get purge vnc4server -y -qq
apt-get purge vncsnapshot -y -qq
apt-get purge vtgrab -y -qq
apt-get purge remmina-plugin-vnc -y -qq
apt-get purge tigervnc -y -qq
apt-get purge tightvncserver -y -qq
apt-get purge x11vnc -y -qq
# "VNC has been removed."
echo -e "VNC has been removed."
# 2s

#
apt-get purge wireshark -y -qq
# "Wireshark has been removed."
echo -e "Wireshark has been removed."
# 2s

#
apt-get purge snmp -y -qq
# "SNMP has been removed."
echo -e "SNMP has been removed."
# 2s

#
apt-get purge nikto -y -qq
# "Nikto has been removed."
echo -e "Nikto has been removed."
# 1s

#
apt-get purge medusa -y -qq
apt-get purge hashcat -y -qq
apt-get purge acccheck -y -qq
apt-get purge arp-scan -y -qq
apt-get purge braa -y -qq
apt-get purge dnsrecon -y -qq
apt-get purge dnstracer -y -qq
apt-get purge metasploit-framework -y -qq
apt-get purge cryptocat -y -qq
apt-get purge w3af -y -qq
apt-get purge w3af-console -y -qq
apt-get purge corkscrew -y -qq
apt-get purge netrw -y -qq
apt-get purge dns2tcp -y -qq
apt-get purge httptunnel -y -qq
apt-get purge patator -y -qq
apt-get purge polenum -y -qq
apt-get purge cmospwd -y -qq
# "More Hacking Tools Removed."
echo -e "More Hacking Tools Removed."
# 1s

#
apt-get purge nexuiz -y -qq
apt-get purge darkplaces -y -qq
apt-get purge hitori -y -qq
apt-get purge iagno -y -qq
apt-get purge four-in-a-row -y -qq
apt-get purge lightsoff -y -qq
apt-get purge minetest -y -qq
apt-get purge minetest-server -y -qq
apt-get purge swell-foop -y -qq
apt-get purge quadrapassel -y -qq
apt-get purge gnome-chess -y -qq
apt-get purge gnome-mines -y -qq
apt-get purge gnome-mahjongg -y -qq
apt-get purge gnome-robots -y -qq
apt-get purge gnome-nibbles -y -qq
apt-get purge gnome-sudoku -y -qq
apt-get purge gnome-taquin -y -qq
apt-get purge gnome-klotski -y -qq
apt-get purge defendguin -y -qq
apt-get purge crack-attack -y -qq
apt-get purge airstrike -y -qq
apt-get purge airstrike-common -y -qq
apt-get purge doomsday -y -qq
apt-get purge doomsday-common -y -qq
apt-get purge doomsday-server -y -qq
apt-get purge dopewars -y -qq
apt-get purge dopewars-data -y -qq
apt-get purge empire empire-hub -y -qq
apt-get purge wing wing-data -y -qq
apt-get autoremove -y -qq
# "Games have been removed."
echo -e "Games have been removed."
# 2s

# 
apt-get purge monopd -y -qq
# "Monopd Game Server has been removed."
echo -e "Monopd Game Server has been removed."
# 2s

#
apt-get purge sqlmap -y -qq
# "SQLMAP has been Removed."
echo -e "SQLMAP has been Removed."
# 2s

#
apt-get purge ettercap -y -qq
apt-get purge ettercap-common -y -qq
apt-get purge ettercap-graphical -y -qq
apt-get purge ettercap-dbg -y -qq
apt-get purge ettercap-text-only -y -qq
# "Ettercap has been Removed."
echo -e "Ettercap has been Removed."
# 2s

#
apt-get purge rhythmbox -y -qq
apt-get purge rhythmbox-plugins -y -qq
# "Rhythmbox has been Removed."
echo -e "Rhythmbox has been Removed."
# 2s

#
apt-get purge vlc -y -qq
apt-get purge vlc-plugin-samba -y -qq
apt-get purge vlc-plugin-notify -y -qq
apt-get purge vlc-nox -y -qq
# "VlC has been Removed."
echo -e "VlC has been Removed."
# 1s

#
apt-get purge snarf -y -qq
apt-get purge fido -y -qq
apt-get purge fimap -y -qq
apt-get purge pykek -y -qq
apt-get purge spraywmi -y -qq
apt-get purge trevorc2 -y -qq
apt-get purge fuzzbunch -y -qq
apt-get purge spiderfoot -y -qq
apt-get purge sniper -y -qq
apt-get purge phishery -y -qq
apt-get purge 3proxy -y -qq
apt-get purge metasploit -y -qq
apt-get purge tplmap -y -qq
apt-get purge rats -y -qq
apt-get purge exploit-db -y -qq
apt-get purge findsploit -y -qq
apt-get purge powersploit -y -qq
apt-get purge ettercap -y -qq
apt-get purge buttercap -y -qq
apt-get purge wireshark -y -qq
apt-get purge pluginhook -y -qq
apt-get purge poshc2 -y -qq
apt-get purge rhythmbox-plugins -y -qq

#echo -e '# Controls IP packet forwarding\nnet.ipv4.ip_forward = 0\n\n# IP Spoofing protection\nnet.ipv4.conf.all.rp_filter = 1\nnet.ipv4.conf.default.rp_filter = 1\n\n# Ignore ICMP broadcast requests\nnet.ipv4.icmp_echo_ignore_broadcasts = 1\n\n# Disable source packet routing\nnet.ipv4.conf.all.accept_source_route = 0\nnet.ipv6.conf.all.accept_source_route = 0\nnet.ipv4.conf.default.accept_source_route = 0\nnet.ipv6.conf.default.accept_source_route = 0\n\n# Ignore send redirects\nnet.ipv4.conf.all.send_redirects = 0\nnet.ipv4.conf.default.send_redirects = 0\n\n# Block SYN attacks\nnet.ipv4.tcp_syncookies = 1\nnet.ipv4.tcp_max_syn_backlog = 2048\nnet.ipv4.tcp_synack_retries = 2\nnet.ipv4.tcp_syn_retries = 5\n\n# Log Martians\nnet.ipv4.conf.all.log_martians = 1\nnet.ipv4.icmp_ignore_bogus_error_responses = 1\n\n# Ignore ICMP redirects\nnet.ipv4.conf.all.accept_redirects = 0\nnet.ipv6.conf.all.accept_redirects = 0\nnet.ipv4.conf.default.accept_redirects = 0\nnet.ipv6.conf.default.accept_redirects = 0\n\n# Ignore Directed pings\nnet.ipv4.icmp_echo_ignore_all = 1\n\n# Accept Redirects? No, this is not router\nnet.ipv4.conf.all.secure_redirects = 0\n\n# Log packets with impossible addresses to kernel log? yes\nnet.ipv4.conf.default.secure_redirects = 0\n\n########## IPv6 networking start ##############\n# Number of Router Solicitations to send until assuming no routers are present.\n# This is host and not router\nnet.ipv6.conf.default.router_solicitations = 0\n\n# Accept Router Preference in RA?\nnet.ipv6.conf.default.accept_ra_rtr_pref = 0\n\n# Learn Prefix Information in Router Advertisement\nnet.ipv6.conf.default.accept_ra_pinfo = 0\n\n# Setting controls whether the system will accept Hop Limit settings from a router advertisement\nnet.ipv6.conf.default.accept_ra_defrtr = 0\n\n#router advertisements can cause the system to assign a global unicast address to an interface\nnet.ipv6.conf.default.autoconf = 0\n\n#how many neighbor solicitations to send out per address?\nnet.ipv6.conf.default.dad_transmits = 0\n\n# How many global unicast IPv6 addresses can be assigned to each interface?\nnet.ipv6.conf.default.max_addresses = 1\n\n########## IPv6 networking ends ##############' >> /etc/sysctl.conf
#echo -e '#Kernal Hardening\n#Kernal Logs\nkernel.dmesg_restrict = 1\n#Kernal Pointers\nkernel.kptr_restrict = 1\n#ExecShield Protection\nkernel.exec-shield = 2\n#Memory Protections\nkernel.randomize_va_space=2' >> /etc/sysctl.conf
#sysctl -p
# "Other Known Hacking Tools has been Removed."
echo -e "Other Known Hacking Tools has been Removed."
# 2s
#flawfinder -examines source code and looks for security weakness.
#ike- Shrew soft VPN client
#ike-scan  - Discover and fingerprint IKE hosts (IPsec VPN Servers)
#sipsak - SIP Swiss army knife
#siproxd SIP proxy/redirect/registrar
#sipwitch - secure peer-to-peer VoIP server for the SIP protocol
#xdotool - simulate (generate) X11 keyboard/mouse input events (Remote Keyboard?)
#vinagre - remote desktop client for the GNOME Desktop
#remote-tty = multiuser "tip"/"cu" replacement with logging
#remotetea - Sun ONC/RPC support for Java
#remctl-server = server for Kerberos-authenticated command execution


#unneeded services:
#unicorn - Rack HTTP server for fast clients
#vinagre - remote desktop client for the GNOME Desktop
#remmina - a remote desktop client that supports the Remote Desktop Protocol, VNC, NX, XDMCP, SPICE and SSH protocols
#remote desktop services/programs

#yersenia -network vulnerability check software (might be good)
#	example: sudo yersenia dhcp -attack 1 (DOS attack on Discover packet)
#auditd -might be good
#vsaudit
#nessus -  a Windows- as well as Linux-based automated network vulnerability and audit tool
#tiger - a security tool that can be use both as a security audit and intrusion detection system.
#	example: "be in a root shell and use the command: 'tiger'"


#games:
#nexuiz - fast paced 3D first-person shooter
#darkplaces - Game engine for Quake and similar 3D first person shooter
#four-in-a-row -game for gnome
#hitori - logiz puzzle game similar to sudoku
#iagno - popular Othellow game for gnome
#lightsoff - Light puzzle game
#minetest - minecraft parody game
#quadrapassel - Popular Russian game, similar to Tetris
#swell-foop - Colored ball puzzle game
#gnome-chess
#gnome-games
#gnome-mines
#gnome-mahjongg
#gnome-nibbles
#gnome-robots
#gnome-taquin
#gnome-klotski
#defendguin -penguin game


#fuzz - stress-test programs by giving them random input


#Notes:
#Use Antivirus, antirootkit, vulnerabilties, antimalware scanners while doing Forensic Questions
#^To save time!
