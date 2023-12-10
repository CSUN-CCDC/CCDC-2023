FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install sudo systemd whois iproute2 python-is-python3 python3-venv openssh-server ufw -y && rm -rf /var/lib/apt/lists/*

RUN adduser moon && usermod -aG sudo moon

RUN echo 'csun:yeet' | chpasswd

RUN echo 'root:yeet' | chpasswd

CMD [ "/lib/systemd/systemd" ]
