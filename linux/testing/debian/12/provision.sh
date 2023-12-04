export DEBIAN_FRONTEND=noninteractive

DEBIAN_FRONTEND=noninteractive sudo apt-get update -y && DEBIAN_FRONTEND=noninteractive sudo apt-get install sudo systemd whois iproute2 python-is-python3 python3-venv openssh-server ufw -y
sudo adduser moon && sudo usermod -aG sudo moon
echo 'moon:yeet' | sudo chpasswd
