#!/usr/bin/env python3
import os

# Colorful functions for printing (Maybe move to another file)
def warning(text):
    print(f"\033[93m[ WARNING ]: {text}\033[0m")

def failed(text):
    print(f"\033[91m[ FAIL ]: {text}\033[0m")

def passed(text):
    print(f"\033[92m[ PASS ]: {text}\033[0m")

def inform(text):
    print(f"[ INFORM ]: {text}")

# Check for root priv
if os.geteuid() != 0:
    failed("Please re-run the script as root")
    exit()

# Backup
if os.system("cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bck") != 0:
    failed("Failed to take a backup.")
    exit()

# Context-aware `match' block
# (User or Group, name)
match = None

new_config = ""

for line in open("/etc/ssh/sshd_config.bck", 'r'):
    # Match blocks
    if match is not None:
        print(f"for {match[0]} {match[1]}:")
    if not (line.startswith(' ') or line.startswith('\t')):
        line = ' '.join(line.split(' '))
    else:
        match = None
    # Skip empty lines and comments
    if line == '\n' or line.startswith('#'):
        continue
    option = line.split()[0]
    value = ' '.join(line.split()[1:])
    if option == "Match":
        match = (value.split()[0], ' '.join(value.split()[1:]))
    if option == "PermitRootLogin":
        # Enabled root login is bad
        if value == "no" or value == "prohibit-password":
            passed("Root login is disabled")
            new_config += "PermitRootLogin no\n"
        elif value == "yes":
            failed("Root login is enabled.")
    elif option == "LogLevel":
        # Any log level is okay; quiet is not
        if value == "QUIET":
            warning("There is no logging enabled")
            new_config += "LogLevel INFO\n"
        else:
            new_config += line + '\n'
    elif option == "X11Forwarding":
        # X11 bad
        if value != "no":
            failed("X11 forwarding is enabled")
            new_config += "X11Forwarding no\n"
    elif option == "UsePAM":
        if value == "yes":
            inform("PAM is enabled")
        else:
            inform("PAM is disabled")
        new_config += line
    # TODO: sftp secure, and protocol check

# Ask the user if the config should be written?
if input("Write the new config to /etc/ssh/ssh_config? [y/n] ").lower() == 'y':
    config_file = open("/etc/ssh/sshd_config", 'w')
    config_file.write(new_config)
