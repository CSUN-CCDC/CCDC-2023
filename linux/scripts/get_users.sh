#!/bin/bash

eval getent passwd {$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)..$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)} | cut -d: -f1 | tee users.txt

output_file="users.txt"

# Function to get admin users for Debian
get_debian_admin_users() {
  admin_users=$(grep -Po '^sudo\s+\:\s+\K[^,]+' /etc/sudoers)
  echo "Admin users on Debian systems:" >> "$output_file"
  echo "$admin_users" >> "$output_file"
}

# Function to get admin users for CentOS
get_centos_admin_users() {
  admin_users=$(getent group wheel | cut -d: -f4)
  echo "Admin users on CentOS systems:" >> "$output_file"
  echo "$admin_users" >> "$output_file"
}

# Check the Linux distribution
if [ -f /etc/os-release ]; then
  source /etc/os-release
  if [ "$ID" == "debian" ]; then
    get_debian_admin_users
  elif [ "$ID" == "centos" ] || [ "$ID" == "rhel" ]; then
    get_centos_admin_users
  else
    echo "Unsupported distribution: $ID"
    exit 1
  fi
else
  echo "Unable to determine the distribution."
  exit 1
fi

echo "Admin users have been written to $output_file."
