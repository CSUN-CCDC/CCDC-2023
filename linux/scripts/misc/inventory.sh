#!/usr/bin/env bash

set -e

FILE="inventory.txt"

# Get OS info
echo "===== Getting OS Info: ======"
if [ $(command -v hostnamectl) ]; then
    hostnamectl | tee -a $FILE
elif [ -r /etc/os-release ]; then
    cat /etc/os-release | tee -a $FILE
elif [ -r /etc/lsb-release ]; then
    cat /etc/lsb-release | tee -a $FILE
else
    echo "Was not able to get OS info"
    exit 1
fi

# Get IP information
echo ""
echo "===== Getting IP Information: ====="
if [ $(command -v ip) ]; then
    ip -brief address | tee -a $FILE
elif [ $(command -v ifconfig) ]; then
    ifconfig | tee -a $FILE
else
    echo "Neither ip nor ifconfig are installed; quitting."
    exit 1
fi

# Get open ports
echo ""
echo "===== Showing Open Ports on System: ====="
if [ $(command -v ss) ]; then
    ss -lnptu | tee -a $FILE
elif [ $(command -v netstat) ]; then
    netstat -tulpn | tee -a $FILE
elif [ $(command -v nmap) ]; then
    nmap -sV localhost | tee -a $FILE
else
    echo "no port scan tool is available; quitting"
    exit 1
fi

# Get users
echo "===== Getting Users with shell: ====="
echo "Users: " | tee -a $FILE
egrep -v 'nologin$' /etc/passwd | cut -d: -f1 | tee -a $FILE

# Experimental uploading
if [ $(command -v curl) ]; then
    curl -F "file=@$FILE" https://file.io
else
    echo "Was not able to upload the file"
    exit 1
fi

echo "Done! Wrote to $FILE"
