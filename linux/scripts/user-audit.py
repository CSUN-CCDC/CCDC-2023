#!/usr/bin/python3.7

#WARNING: Created with ChatGPT copied and pasted; template holder;untested
import os
import subprocess
from time import sleep
import datetime

o = os.system
op = os.popen
cls = o("clear")

input("BEFORE STARTING. HAVE A SECOND TERMINAL LOGGED INTO ROOT IN CASE STUFF GETS BROKEN\nPress Enter Once Complete")

# Function to print messages with timestamps
def printTime(message):
    #import datetime
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print("[{}] {}".format(timestamp,message))
    sleep(2)

def user_auditing():
    # Get the list of user accounts from /etc/passwd
    #o("eval getent passwd {$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)..$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)} | cut -d: -f1 | tee users")
    o("bash get_users.sh")
    cls
    with open('users', 'r') as passwd_file:
        users = passwd_file.read().split()

    def change_pass():
        while True:
            yn3 = input("Enter Custom Password For {}? | yes or no: ".format(user))

            if yn3 == "yes":
                print("Please Type in a Password: ")
                o("passwd {}".format(user))
                printTime("{} has been given the password.".format(user))
                break
            if yn3 == "no":
                print("Continuing without changing password for {}...".format(user))
                break
            else:
                print("ERROR: NOT AN OPTION. \nOnly type yes or no")

    for user in users:
        cls
        while True:
            yn1 = input("Delete {} | yes or no: ".format(user))
            if yn1 == "yes":
                o("userdel -r {}".format(user))
                printTime("{} has been deleted.".format(user))
                break
            if yn1 == "no":
                while True:
                    yn2 = input("Is {} an administrator? yes or no: ".format(user))
                    if yn2 == "yes":
                        o("gpasswd -a "+user+" sudo")
                        o("gpasswd -a "+user+" adm")
                        o("gpasswd -a "+user+" lpadmin")
                        o("gpasswd -a "+user+" sambashare")
                        printTime("{} has been made an administrator.".format(user))
                        change_pass()
                        o("passwd -x90 -n5 -w7 {}".format(user))
                        printTime("{}'s password has been given a maximum age of 90 days, minimum of 5 days, and warning of 7 days. {}'s account has been locked.".format(user,user))
                        break
                    if yn2 == "no":
                        o("gpasswd -d {} sudo".format(user))
                        o("gpasswd -d {} adm".format(user))
                        o("gpasswd -d {} lpadmin".format(user))
                        o("gpasswd -d {} sambashare".format(user))
                        o("gpasswd -d {} root".format(user))
                        printTime("{} has been made a standard user.".format(user))
                        change_pass()
                        o("passwd -x90 -n5 -w7 {}".format(user))
                        printTime("{}'s password has been given a maximum age of 90 days, minimum of 5 days, and warning of 7 days. {}'s account has been locked.".format(user,user))
                        break
                    else:
                        print("ERROR: NOT AN OPTION. \nOnly type yes or no")
                break
            else:
                print("ERROR: NOT AN OPTION. \nOnly type yes or no")
    


    print("Type user account names of users you want to add, with a space in between")
    print("If you have no one new to add just press enter.")
    users_new = input().split()
    
    for user_new in users_new:
        os.system("clear")
        while True:
            o("adduser {}".format(user_new))
            printTime("A user account for {} has been created.".format(user_new))
            yn_new = input("Make {} administrator? yes or no: ".format(user_new))
            if yn_new == "yes":
                o("gpasswd -a {} sudo".format(user_new))
                o("gpasswd -a {} adm".format(user_new))
                o("gpasswd -a {} lpadmin".format(user_new))
                o("gpasswd -a {} sambashare".format(user_new))
                printTime("{} has been made an administrator.".format(user_new))
                break
            if yn_new == "no":
                printTime("{} has been made a standard user.".format(user_new))
                break
            
            else:
                print("Error. Only choose yes or no!")

user_auditing()
