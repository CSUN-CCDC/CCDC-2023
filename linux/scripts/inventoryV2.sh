#!/bin/bash

# Get the hostname
hostname=$(hostname)
#set -e

FILE=$hostname"_inventory.txt"
# Clear the output file
> "$FILE"

IS_RHEL=false
IS_DEBIAN=false
IS_ALPINE=false
IS_SLACK=false

ORAG=''
GREEN=''
YELLOW=''
BLUE=''
RED=''
NC=''

if [ -z "$DEBUG" ]; then
    DPRINT() { 
        "$@" 2>/dev/null 
    }
else
    DPRINT() { 
        "$@" 
    }
fi

RHEL(){
  IS_RHEL=true
}

DEBIAN(){
  IS_DEBIAN=true
}

UBUNTU(){
  DEBIAN
}

ALPINE(){
  IS_ALPINE=true
}

SLACK(){
  IS_SLACK=true
}

if command -v yum >/dev/null ; then
    RHEL
elif command -v apt-get >/dev/null ; then
    if $(cat /etc/os-release | grep -qi Ubuntu); then
        UBUNTU
    else
        DEBIAN
    fi
elif command -v apk >/dev/null ; then
    ALPINE
elif command -v slapt-get >/dev/null || (cat /etc/os-release | grep -qi slackware ) ; then
    SLACK
fi

if [ $IS_ALPINE = true ]; then
    SERVICES=$( rc-status -s | grep started | awk '{print $1}' )
elif [ $IS_SLACK = true ]; then
    SERVICES=$( ls -la /etc/rc.d | grep rwx | awk '{print $9}' ) 
else
    SERVICES=$( DPRINT systemctl --type=service | grep active | awk '{print $1}' || service --status-all | grep -E '(+|is running)' )
fi
APACHE2=false
NGINX=false
checkService()
{
    serviceList=$1
    serviceToCheckExists=$2
    serviceAlias=$3                

    if [ -n "$serviceAlias" ]; then
        echo -e "\n${BLUE}[+] $serviceToCheckExists is on this machine${NC}\n"
        if echo "$serviceList" | grep -qi "$serviceAlias\|$serviceToCheckExists" ; then
            if [ "$( DPRINT netstat -tulpn | grep -i $serviceAlias )" ] ; then
                
                echo -e "Active on port(s) ${YELLOW}$(netstat -tulpn | grep -i "$serviceAlias\|$serviceToCheckExists"| awk 'BEGIN {ORS=" and "} {print $1, $4}' | sed 's/\(.*\)and /\1\n/')${NC}\n"
            
            elif [ "$( DPRINT ss -blunt -p | grep -i $serviceAlias )" ] ; then
                
                echo -e "Active on port(s) ${YELLOW}$(ss -blunt -p | grep -i "$serviceAlias\|$serviceToCheckExists"| awk 'BEGIN {ORS=" and " } {print $1,$5}' | sed 's/\(.*\)and /\1\n/')${NC}\n"
            fi

        fi 
    elif echo "$serviceList" | grep -qi "$serviceToCheckExists" ; then
        echo -e "\n${BLUE}[+] $serviceToCheckExists is on this machine${NC}\n"

        if [ "$( DPRINT netstat -tulpn | grep -i $serviceToCheckExists )" ] ; then
                
                echo -e "Active on port(s) ${YELLOW}$(netstat -tulpn | grep -i $serviceToCheckExists| awk 'BEGIN {ORS=" and "} {print $1, $4}' | sed 's/\(.*\)and /\1\n/')${NC}\n"
        
        elif [ "$( DPRINT ss -blunt -p | grep -i $serviceToCheckExists )" ] ; then
                
                echo -e "Active on port(s) ${YELLOW}$(ss -blunt -p | grep -i $serviceToCheckExists| awk 'BEGIN {ORS=" and " } {print $1,$5}' | sed 's/\(.*\)and /\1\n/')${NC}\n"
        fi
    fi
}

# Get the hostname
#hostname=$(hostname)
#set -e

#FILE="$hostname_inventory.txt"
# Clear the output file
#> "$FILE"
# Get OS info
echo "[+] Getting OS Info: " | tee -a $FILE
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
echo "[+] Getting IP Information: " | tee -a $FILE

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
    echo "[+] More IP info: " | tee -a $FILE
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
echo "[+] Showing Open Ports on System: " | tee -a $FILE
# Use netstat to list listening ports and pipe the output to grep
listening_ports=$(netstat -tulpn | grep "LISTEN")

# Create an associative array to track services
declare -A services

# Loop through the listening ports and display their corresponding services
echo "--- Inventory Ports & Services to Copy For Inventory Sheet: ---" | tee -a $FILE
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
echo ""
echo "[+] More Info on ports:" | tee -a $FILE
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
    echo "[+] Service Users (UID < 1000): "
    echo "$service_users"
    echo
}

# Function to list regular users (UID 1000 or higher)
list_regular_users() {
    local regular_users=$(getent passwd | awk -F: '$3 >= 1000 {print $1}')
    echo "[+] Regular Users (UID >= 1000):"
    echo "$regular_users"
    echo
}
list_system_shell_users() {
    local system_users=$(getent passwd | awk -F: '$3 < 1000 && $7 != "/bin/false" && $7 != "/usr/sbin/nologin" {print $1}')
    echo "[+] System Users (UID < 1000 with shell; might be sus):"
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
    echo "[+] Users with UID 0 (root or equivalent; anyone other root here is BAD): "
    get_uid_0_admins
    list_regular_users
    list_service_users
    list_system_shell_users
} >> "$FILE"

#echo "Users audit information saved to $FILE"
# Check SUID & Worldwritables
SUIDS=$(find /bin /sbin /usr -perm -u=g+s -type f -exec ls -la {} \; | grep -E '(s7z|aa-exec|ab|agetty|alpine|ansible-playbook|ansible-test|aoss|apt|apt-get|ar|aria2c|arj|arp|as|ascii85|ascii-xfr|ash|aspell|at|atobm|awk|aws|base32|base58|base64|basenc|basez|bash|batcat|bc|bconsole|bpftrace|bridge|bundle|bundler|busctl|busybox|byebug|bzip2|c89|c99|cabal|cancel|capsh|cat|cdist|certbot|check_by_ssh|check_cups|check_log|check_memory|check_raid|check_ssl_cert|check_statusfile|chmod|choom|chown|chroot|clamscan|cmp|cobc|column|comm|composer|cowsay|cowthink|cp|cpan|cpio|cpulimit|crash|crontab|csh|csplit|csvtool|cupsfilter|curl|cut|dash|date|dd|debugfs|dialog|diff|dig|distcc|dmesg|dmidecode|dmsetup|dnf|docker|dos2unix|dosbox|dotnet|dpkg|dstat|dvips|easy_install|eb|ed|efax|elvish|emacs|enscript|env|eqn|espeak|ex|exiftool|expand|expect|facter|file|find|finger|fish|flock|fmt|fold|fping|ftp|gawk|gcc|gcloud|gcore|gdb|gem|genie|genisoimage|ghc|ghci|gimp|ginsh|git|grc|grep|gtester|gzip|hd|head|hexdump|highlight|hping3|iconv|iftop|install|ionice|ip|irb|ispell|jjs|joe|join|journalctl|jq|jrunscript|jtag|julia|knife|ksh|ksshell|ksu|kubectl|latex|latexmk|ldconfig|ld.so|less|lftp|ln|loginctl|logsave|look|lp|ltrace|lua|lualatex|luatex|lwp-download|lwp-request|mail|make|man|mawk|minicom|more|mosquitto|msfconsole|msgattrib|msgcat|msgconv|msgfilter|msgmerge|msguniq|mtr|multitime|mv|mysql|nano|nasm|nawk|nc|ncftp|neofetch|nft|nice|nl|nm|nmap|node|nohup|npm|nroff|nsenter|octave|od|openssl|openvpn|openvt|opkg|pandoc|paste|pax|pdb|pdflatex|pdftex|perf|perl|perlbug|pexec|pg|php|pic|pico|pidstat|pip|pkexec|pkg|posh|pr|pry|psftp|psql|ptx|puppet|pwsh|python|rake|rc|readelf|red|redcarpet|redis|restic|rev|rlogin|rlwrap|rpm|rpmdb|rpmquery|rpmverify|rsync|rtorrent|ruby|run-mailcap|run-parts|runscript|rview|rvim|sash|scanmem|scp|screen|script|scrot|sed|service|setarch|setfacl|setlock|sftp|sg|shuf|slsh|smbclient|snap|socat|socket|soelim|softlimit|sort|split|sqlite3|sqlmap|ss|ssh|ssh-agent|ssh-keygen|ssh-keyscan|sshpass|start-stop-daemon|stdbuf|strace|strings|sysctl|systemctl|systemd-resolve|tac|tail|tar|task|taskset|tasksh|tbl|tclsh|tcpdump|tdbtool|tee|telnet|terraform|tex|tftp|tic|time|timedatectl|timeout|tmate|tmux|top|torify|torsocks|troff|tshark|ul|unexpand|uniq|unshare|unsquashfs|unzip|update-alternatives|uudecode|uuencode|vagrant|valgrind|vi|view|vigr|vim|vimdiff|vipw|virsh|volatility|w3m|wall|watch|wc|wget|whiptail|whois|wireshark|wish|xargs|xdg-user-dir|xdotool|xelatex|xetex|xmodmap|xmore|xpad|xxd|xz|yarn|yash|yelp|yum|zathura|zip|zsh|zsoelim|zypper)$')
echo "[+] Funny SUIDs" | tee -a $FILE
echo -e "$SUIDS\n" | tee -a $FILE


WORLDWRITEABLES=$( DPRINT find /usr /bin/ /sbin /var/www /lib -perm -o=w -type f -exec ls {} -la \; )
echo "[+] World Writable Files (CHANGE PERMS)" | tee -a $FILE
echo "$WORLDWRITEABLES"
echo ""

#Check service stuff:
if checkService "$SERVICES"  'ssh' | grep -qi "is on this machine"; then checkService "$SERVICES"  'ssh' ; SSH=true ;fi | tee -a $FILE
if checkService "$SERVICES"  'docker' | grep -qi "is on this machine"; then
    checkService "$SERVICES"  'docker' | tee -a $FILE

    ACTIVECONTAINERS=$( docker ps )
    if [ -n "$ACTIVECONTAINERS" ]; then
        echo "Current Active Containers"
        echo -e "${ORAG}$ACTIVECONTAINERS${NC}\n"
    fi

    ANONMOUNTS=$( docker ps -q | DPRINT xargs -n 1 docker inspect --format '{{if .Mounts}}{{.Name}}: {{range .Mounts}}{{.Source}} -> {{.Destination}}{{end}}{{end}}' | grep -vE '^$' | sed 's/^\///g' )
    if [ -n "$ANONMOUNTS" ]; then
        echo "Anonymous Container Mounts (host -> container)"
        echo -e "${ORAG}$ANONMOUNTS${NC}\n"
    fi

    VOLUMES="$( DPRINT docker volume ls --format "{{.Name}}" )"
    if [ -n "$VOLUMES" ]; then
        echo "Volumes"
        for v in $VOLUMES; do
            container=$( DPRINT docker ps -a --filter volume=$v --format '{{.Names}}' | tr '\n' ',' | sed 's/,$//g' )
            if [ -n "$container" ]; then
                mountpoint=$( echo $( DPRINT docker volume inspect --format '{{.Name}}: {{.Mountpoint}}' $v ) | awk -F ': ' '{print $2}' )
                echo -e "${ORAG}$v -> $mountpoint used by $container${NC}"
            fi
        done
        echo ""
    fi
fi

if checkService "$SERVICES"  'cockpit' | grep -qi "is on this machine"; then
    checkService "$SERVICES"  'cockpit'
    echo -e "${ORAG}[!] WE PROBABLY SHOULD KILL COCKPIT${NC}"
fi

if checkService "$SERVICES"  'apache2' | grep -qi "is on this machine"; then
    checkService "$SERVICES"  'apache2'
    APACHE2VHOSTS=$(tail -n +1 /etc/apache2/sites-enabled/* | grep -v '#' |grep -E '==>|VirtualHost|^[^[\t]ServerName|DocumentRoot|^[^[\t]ServerAlias|^[^[\t]*Proxy*')
    echo -e "\n[!] Configuration Details\n"
    echo -e "${ORAG}$APACHE2VHOSTS${NC}"
    APACHE2=true
fi

if checkService "$SERVICES"  'ftp' | grep -qi "is on this machine"; then
    checkService "$SERVICES"  'ftp'
    FTPCONF=$(cat /etc/*ftp* | grep -v '#' | grep -E 'anonymous_enable|guest_enable|no_anon_password|write_enable')
    echo -e "\n[!] Configuration Details\n"
    echo -e "${ORAG}$FTPCONF${NC}"
fi


if checkService "$SERVICES"  'nginx' | grep -qi "is on this machine"; then
    checkService "$SERVICES"  'nginx'
    NGINXCONFIG=$(tail -n +1 /etc/nginx/sites-enabled/* | grep -v '#'  | grep -E '==>|server|^[^[\t]listen|^[^[\t]root|^[^[\t]server_name|proxy_*')
    echo -e "\n[!] Configuration Details\n"
    echo -e "${ORAG}$NGINXCONFIG${NC}"
    NGINX=true
fi

sql_test(){

    if [ -f /lib/systemd/system/mysql.service ]; then
        SQL_SYSD=/lib/systemd/system/mysql.service
    elif [ -f /lib/systemd/system/mariadb.service ]; then
        SQL_SYSD=/lib/systemd/system/mariadb.service
    fi
    
    if [ -n "$SQL_SYSD" ]; then
        SQL_SYSD_INFO=$( grep -RE '^(User=|Group=)' $SQL_SYSD )
    fi
    
    if [ -d /etc/mysql ]; then
        SQLDIR=/etc/mysql
    elif [ -d /etc/my.cnf.d/ ]; then
        SQLDIR=/etc/my.cnf.d/
    fi

    if [ -n "$SQLDIR" ]; then
        SQLCONFINFO=$( DPRINT find $SQLDR *sql*.cnf *-server.cnf | sed 's/:user\s*/ ===> user /' | sed 's/bind-address\s*/ ===> bind-address /' )
    fi

    if [ -n "$SQLCONFINFO" ]; then
        echo -e "${ORAG}$SQLCONFINFO${NC}"
    fi

    if [ -n "$SQL_SYSD_INFO" ]; then
        echo -e "${ORAG}$SQL_SYSD:\n$SQL_SYSD_INFO${NC}\n"
    fi

    SQL_AUTH=1

    if mysql -uroot -e 'bruh' 2>&1 >/dev/null | grep -v '\[Warning\]' | grep -q 'bruh'; then
        echo -e "${RED}Can login as root, with root and no password${NC}\n"
        SQLCMD="mysql -uroot"
    fi

    if mysql -uroot -proot -e 'bruh' 2>&1 >/dev/null | grep -v '\[Warning\]' | grep -q 'bruh'; then
        echo -e "${RED}Can login with root:root${NC}\n"
        SQLCMD="mysql -uroot -proot"
    fi

    if mysql -uroot -ppassword -e 'bruh' 2>&1 >/dev/null | grep -v '\[Warning\]' | grep -q 'bruh'; then
        echo -e "${RED}Can login with root:password${NC}\n"
        SQLCMD="mysql -uroot -ppassword"
    fi

    if [ -n "$DEFAULT_PASS" ]; then
        if mysql -uroot -p"$DEFAULT_PASS" -e 'bruh' 2>&1 >/dev/null | grep -v '\[Warning\]' | grep -q 'bruh'; then
            echo -e "${RED}Can login with root:$DEFAULT_PASS${NC}\n"
            SQLCMD="mysql -uroot -p$DEFAULT_PASS"
        fi
    fi

    if [ -z "$SQLCMD" ]; then
        SQL_AUTH=0
    fi
    
    if [ "$SQL_AUTH" = 1 ]; then
        echo "SQL User Information"
        echo -e "${ORAG}$( DPRINT $SQLCMD -t -e 'select user,host,plugin,authentication_string from mysql.user where password_expired="N";' )${NC}\n" 
        DATABASES=$( DPRINT $SQLCMD -t -e 'show databases' | grep -vE '^\|\s(mysql|information_schema|performance_schema|sys|test)\s+\|' )
        if [ -n "$DATABASES" ]; then
            echo "SQL Databases"
            echo -e "${ORAG}$DATABASES${NC}\n"
        fi
    else
        echo "Cannot login with weak creds or default credentials"
    fi
}
if checkService "$SERVICES"  'mysql' | grep -qi "is on this machine"; then 
    MYSQL=true
    checkService "$SERVICES"  'mysql' 
    sql_test
fi

if checkService "$SERVICES"  'mariadb' 'mysql' | grep -qi "is on this machine"; then 
    MARIADB=true
    checkService "$SERVICES"  'mariadb' 'mysql'
    sql_test
fi

if checkService "$SERVICES"  'postgres' | grep -qi "is on this machine" ; then
    POSTGRESQL=true
    checkService "$SERVICES" 'postgres' || checkService "$SERVICES" 'postgres' 'postmaster'
    PSQLHBA=$( grep -REvh '(#|^\s*$|replication)' $( DPRINT find /etc/postgresql/ /var/lib/pgsql/ /var/lib/postgres* -name pg_hba.conf | head -n 1 ) )
    echo -e "PostgreSQL Authentication Details\n"
    echo -e "${ORAG}$PSQLHBA${NC}\n"

    if DPRINT psql -U postgres -c '\q'; then
        AUTH=1
        DB_CMD=" psql -U postgres -c \l "
    elif DPRINT sudo -u postgres psql -c '\q'; then
        AUTH=1
        DB_CMD=" sudo -u postgres psql -c \l "
    fi
    if [ "$AUTH" = 1 ]; then
        DATABASES="$( DPRINT $DB_CMD | grep -vE '^\s(postgres|template0|template1|\s+)\s+\|' | head -n -2 )"
        if [ "$( echo "$DATABASES" | wc -l )" -gt 2 ]; then
            echo "PostgreSQL Databases"
            echo -e "${ORAG}$DATABASES${NC}\n"
        fi
    fi
fi

# idk about any of these
if checkService "$SERVICES"  'python' | grep -qi "is on this machine"; then checkService "$SERVICES"  'python' ; PYTHON=true; fi | tee -a $FILE
if checkService "$SERVICES"  'dropbear' | grep -qi "is on this machine"; then checkService "$SERVICES"  'dropbear' ; DROPBEAR=true; fi | tee -a $FILE
if checkService "$SERVICES"  'php' | grep -qi "is on this machine"; then checkService "$SERVICES"  'php' ; PHP=true; fi | tee -a $FILE
if checkService "$SERVICES"  'vsftpd' | grep -qi "is on this machine"; then checkService "$SERVICES"  'vsftpd' ; VSFTPD=true; fi | tee -a $FILE
if checkService "$SERVICES"  'pure-ftpd' | grep -qi "is on this machine"; then checkService "$SERVICES"  'pure-ftpd' ; PUREFTPD=true; fi | tee -a $FILE
if checkService "$SERVICES"  'proftpd' | grep -qi "is on this machine"; then checkService "$SERVICES"  'proftpd' ; PROFTPD=true; fi | tee -a $FILE
if checkService "$SERVICES"  'httpd' | grep -qi "is on this machine"; then checkService "$SERVICES"  'httpd' ; HTTPD=true; fi | tee -a $FILE
if checkService "$SERVICES"  'xinetd' | grep -qi "is on this machine"; then checkService "$SERVICES"  'xinetd' ; XINETD=true; fi | tee -a $FILE
if checkService "$SERVICES"  'inetd' | grep -qi "is on this machine"; then checkService "$SERVICES"  'inetd' ; INETD=true; fi | tee -a $FILE
if checkService "$SERVICES"  'tftpd' | grep -qi "is on this machine"; then checkService "$SERVICES"  'tftpd' ; TFTPD=true; fi | tee -a $FILE
if checkService "$SERVICES"  'atftpd' | grep -qi "is on this machine"; then checkService "$SERVICES"  'atftpd' ; ATFTPD=true; fi | tee -a $FILE
if checkService "$SERVICES"  'smbd' | grep -qi "is on this machine"; then checkService "$SERVICES"  'smbd' ; SMBD=true; fi | tee -a $FILE
if checkService "$SERVICES"  'nmbd' | grep -qi "is on this machine"; then checkService "$SERVICES"  'nmbd' ; NMBD=true; fi | tee -a $FILE
if checkService "$SERVICES"  'snmpd' | grep -qi "is on this machine"; then checkService "$SERVICES"  'snmpd' ; SNMPD=true; fi | tee -a $FILE
if checkService "$SERVICES"  'ypbind' | grep -qi "is on this machine"; then checkService "$SERVICES"  'ypbind' ; YPBIND=true; fi | tee -a $FILE
if checkService "$SERVICES"  'rshd' | grep -qi "is on this machine"; then checkService "$SERVICES"  'rshd' ; RSHD=true; fi | tee -a $FILE
if checkService "$SERVICES"  'rexecd' | grep -qi "is on this machine"; then checkService "$SERVICES"  'rexecd' ; REXECD=true; fi | tee -a $FILE
if checkService "$SERVICES"  'rlogin' | grep -qi "is on this machine"; then checkService "$SERVICES"  'rlogin' ; RLOGIN=true; fi | tee -a $FILE
if checkService "$SERVICES"  'telnet' | grep -qi "is on this machine"; then checkService "$SERVICES"  'telnet' ; TELNET=true; fi | tee -a $FILE
if checkService "$SERVICES"  'squid' | grep -qi "is on this machine"; then checkService "$SERVICES"  'squid' ; SQUID=true; fi | tee -a $FILE
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
echo ""
echo "[+] Hardware (Place as Extra Notes if No Hardware Section on Exel Sheet): " | tee -a $FILE
get_ram_info
get_cpu_info
get_storage_info

echo
echo "Done! Wrote to $FILE"

chmod 440 $FILE
chmod 440 *inventory.txt
