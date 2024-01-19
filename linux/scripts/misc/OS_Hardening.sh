#!/bin/bash

'''
   CCDC Hardening 2023
        _________ ______
    ___/   \     V      \
   /  ^    |\    |\      \
  /_O_/\  / /    | ‾‾‾\  |
 //     \ |‾‾‾\_ |     ‾‾
//      _\|    _\|

'''

if [[ $EUID -ne 0 ]]; then
	printf 'Must be run as root, exiting!'
	exit 1
fi
sudo apt install git -y
git clone https://github.com/Kirito-Kun07/unixsecur1ty.git
# Variables
echo -e "Ready to Continue?"
read ready_to_continue

## Files to backup
declare -a backup=(/etc/sysctl.conf /etc/pam.conf /etc/host.conf /etc/sysconfig /etc/ssh/sshd_config)

#log () { printf "\033[01;30m$(date)\033[0m: %s\n" }

# Install & Configure

## Backup important files
mkdir -p ~/backup/etc/ssh
for file in ${backup[@]}; do 
	[[ -e $file ]] && cp $file ~/backup$file
done
# chattr -R +i ~/backup # Make backup folder readonly

## This was for CyberPatriot but might still apply
#[[ -e /etc/lightdm/lightdm.conf ]] && echo "allow-guest=false" >> /etc/lightdm/lightdm.conf && sudo restart lightdm
apt install net-tools -y
dnf install net-tools -y
## Modify /etc/sysctl.conf
wget https://raw.githubusercontent.com/UCI-CCDC/CCDC2020/master/configs/sctlconf
sysctl -p sctlconf
printf "\033[01;30m$(date)\033[0m: %s\n" "Configured /etc/sysctl.conf"

## IPv6 is the future but I ain't ready for it
#if [ -f "/etc/modprobe.d/aliases" ]; then
#	cp /etc/modprobe.d/aliases /etc/modprobe.d/aliases.old #make a backup just in case
#	sed -i 's/alias net-pf-10 ipv6/alias net-pf-10 off\nalias ipv6 off/' /etc/modprobe.d/aliases
#	printf "\033[01;30m$(date)\033[0m: %s\n" "Disabled IPv6"
#fi

## Disable IP Forwarding
echo 0 | sudo tee /proc/sys/net/ipv4/ip_forward

## Disable IP Spoofing
#echo "nospoof on" | sudo tee -a /etc/host.conf

## Remove anything world-readable from home directories
env x='() { :;}; echo vulnerable' bash -c "echo this is a test"

## Install & update utilities
if [ $(which apt-get) ]; then # Debian based
	apt-get update -y -q
	apt-get upgrade -y -q
    sudo apt-get install --only-upgrade Bash
	#apt-get install snoopy vim auditd -y -q
	#auditctl –e 1
elif [ $(which yum) ]; then
	yum update
elif [ $(which pacman) ]; then 
	pacman -Syy
	pacman -Su
elif [ $(which apk) ]; then # Alpine
	apk update
	apk upgrade
fi

apt install safe-rm -y
#chattr +i /etc/passwd /etc/shadow # oof

#tar -czvf webstuff.tar.gz /var/www/

if [ $(which apache2) ]; then
	#wget -O /etc/apache2/zot.conf https://raw.githubusercontent.com/UCI-CCDC/CCDC2020/master/configs/zot.conf 
	sudo a2enmod headers
	sudo a2enmod rewrite
	sudo a2enmod ratelimit
	sudo a2enmod security
	service apache2 restart

echo it is recommended to disable the following apache2 modules if they are enabled
echo ""
echo sudo a2dismod php
echo sudo a2dismod cgi
echo sudo a2dismod autoindex
echo sudo a2dismod info
echo sudo a2dismod status
echo try redoing it with mod_ in front of each one like: mod_cgi
echo sudo systemctl restart apache2
echo ""
echo However if services or webpage breaks, re-enable the module until it fixes
echo ""
echo "sudo a2enmod <mod>"
echo Find all 'immutable' files
echo find . | xargs -I file lsattr -a file 2>/dev/null | grep '^....i'
echo 'chattr -i file' to change it back
echo Doing this on / takes a long time, point it where it counts: /etc/, ~/, /tmp/   etc.. etc.
echo ""
echo This command sets the "immutable" attribute on the specified file, which prevents the file from being modified, deleted, or rename
echo -e which is good for important files like passwd or shadow or backups
echo ""
echo There was also various OS Hardening scripts that were installed under "unixsecurity". Use whichever you need!
