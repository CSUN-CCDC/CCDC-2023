#!/usr/bin/env bash

set -e

FILE="inventory.txt"
# Clear the output file
> "$FILE"
# Get OS info
echo "===== Getting OS Info: ======" | tee -a $FILE
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
echo "" | tee -a $FILE
echo "===== Getting IP Information: =====" | tee -a $FILE

if [ $(command -v ip) ]; then
# Use the ip command to list network interfaces
    interfaces=$(ip link show | grep -E "^[0-9]+:" | awk -F ": " '{print $2}')

    # Loop through each interface and get its IP and MAC address
    for interface in $interfaces; do
        ip_address=$(ip addr show dev "$interface" | grep -E "inet\s" | awk '{print $2}')
        mac_address=$(ip link show dev "$interface" | grep -E "link/ether" | awk '{print $2}')
        echo 
        echo "interface[$interface]:" | tee -a $FILE
        echo "IP Address: $ip_address" | tee -a $FILE
        echo "MAC Address: $mac_address" | tee -a $FILE
        echo
    done
    echo "==== More IP info: ====" | tee -a $FILE
    ip -brief address | tee -a $FILE
elif [ $(command -v ifconfig) ]; then
    ifconfig | tee -a $FILE
else
    echo "Neither ip nor ifconfig are installed; quitting." | tee -a $FILE
    exit 1
fi
echo ""



# Get open ports
echo "" | tee -a $FILE
echo "===== Showing Open Ports on System: =====" | tee -a $FILE
# Use netstat to list listening ports and pipe the output to grep
listening_ports=$(netstat -tulpn | grep "LISTEN")

# Create an associative array to track services
declare -A services

# Loop through the listening ports and display their corresponding services
echo "===== Inventory Ports & Services to Copy For Inventory Sheet: =====" | tee -a $FILE
while read -r line; do
    port=$(echo "$line" | awk '{print $4}' | awk -F ':' '{print $NF}')
    service_name=$(echo "$line" | awk '{print $7}' | awk -F'/' '{print $2}')
    if [ -n "$service_name" ] && [ -z "${services[$service_name]}" ]; then
        echo " $port ($service_name), " | tee -a $FILE
        services[$service_name]=1
    elif [ -z "$service_name" ]; then
        echo " $port (unknown), " | tee -a $FILE
    fi
done <<< "$listening_ports"

echo "==== More Info on ports: ====" | tee -a $FILE
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
echo "" | tee -a $FILE

# Function to perform an audit of users and groups with "ALL" permissions
audit_sudoers_file() {
    local audit_results=""
    while read -r line; do
        if [[ $line =~ ^[^#]*[[:space:]]+ALL=.*$ ]]; then
            user_or_group=$(echo "$line" | awk -F'[[:space:]]+' '{print $1}')
            permissions=$(echo "$line" | awk -F'=' '{print $2}')
            audit_results+="User/Group: $user_or_group\n"
            audit_results+="Permissions: $permissions\n"

            # Check if the user_or_group is a group and list its members (removing the % symbol)
            if [ -z "$(getent passwd "$user_or_group")" ]; then
                group_without_percent="${user_or_group#%}"
                members=$(getent group "$group_without_percent" | cut -d: -f4 | tr ',' ' ')
                audit_results+="Members of Group $group_without_percent: $members\n"
            fi

            audit_results+="\n"
        fi
    done < /etc/sudoers
    echo -e "$audit_results"
}
get_uid_0_admins() {
    getent passwd | awk -F: '$3 == 0 {print $1}'
    echo
}

# Function to list service users (UID below 1000)
list_service_users() {
    local service_users=$(getent passwd | awk -F: '$3 < 1000 {print $1}')
    echo "==== Service Users (UID < 1000): ===="
    echo "$service_users"
    echo
}

# Function to list regular users (UID 1000 or higher)
list_regular_users() {
    local regular_users=$(getent passwd | awk -F: '$3 >= 1000 {print $1}')
    echo "==== Regular Users (UID >= 1000): ===="
    echo "$regular_users"
    echo
}
list_system_shell_users() {
    local system_users=$(getent passwd | awk -F: '$3 < 1000 && $7 != "/bin/false" && $7 != "/usr/sbin/nologin" {print $1}')
    echo "==== System Users (UID < 1000 with shell; might be sus): ===="
    echo "--- Google of check if these system/service users are supposed to have a shell ---"
    echo "$system_users"
    echo
}
# Create a timestamp
timestamp=$(date +"%Y-%m-%d %H:%M:%S")

# Clear the output file


# Perform the audit and store the results in the output file
{
    echo "Full System Users Audit Report ($timestamp)"
    echo "====================================="
    echo
    audit_sudoers_file
    echo "==== Users with UID 0 (root or equivalent; anyone other root here is BAD): ===="
    get_uid_0_admins
    list_regular_users
    list_service_users
    list_system_shell_users
} >> "$FILE"

#echo "Users audit information saved to $FILE"


# Experimental uploading
#if [ $(command -v curl) ]; then
#    curl -F "file=@$FILE" https://file.io
#else
#    echo "Was not able to upload the file"
#    exit 1
#fi

#echo "Done! Wrote to $FILE"

# Function to display RAM (Memory) information
get_ram_info() {
  ram_info=$(free -h | awk '/^Mem:/ {print $2}')
  echo "RAM: $ram_info" | tee -a $FILE
}

# Function to display CPU information
get_cpu_info() {
  cpu_info=$(lscpu | awk -F: '/Model name/ {print $2}' | xargs)
  echo "CPU: $cpu_info" | tee -a $FILE
}

# Function to display storage information
get_storage_info() {
  storage_info=$(df -h / | awk 'NR==2 {print $2}')
  echo "Storage: $storage_info" | tee -a $FILE
}

# Display information for RAM, CPU, and storage
echo "===== Hardware (Place as Extra Notes if No Hardware Section on Exel Sheet): ====="
get_ram_info
get_cpu_info
get_storage_info

echo "Done! Wrote to $FILE"