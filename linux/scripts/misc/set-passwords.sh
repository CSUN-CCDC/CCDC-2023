#!/usr/bin/env bash

# Check for root
if [ "$EUID" -ne 0 ]; then
    echo "Run as root plz uwu"
    exit
fi

# set all user passwords and store
echo "user,password" > users_and_passwords.csv 
for user in $(egrep -v '(nologin|false)$' /etc/passwd | egrep -v '^root' | cut -d':' -f1);
do
    pass=$(dd if=/dev/random of=/dev/stdout bs=1 count=20 | base64)
    echo "$user,$pass" >> users_and_passwords.csv
    chpasswd <<<"$user:$pass"
done
