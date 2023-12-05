export DEBIAN_FRONTEND=noninteractive

DEBIAN_FRONTEND=noninteractive sudo apt-get update -y && DEBIAN_FRONTEND=noninteractive sudo apt-get install sudo systemd whois iproute2 python-is-python3 python3-venv openssh-server ufw -y
sudo useradd -m -s /bin/bash csun && sudo usermod -aG sudo csun
sudo bash -c "echo 'csun:yeet' | chpasswd"
