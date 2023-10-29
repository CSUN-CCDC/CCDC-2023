FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt install sudo systemd whois iproute2 -y && rm -rf /var/lib/apt/lists/*

RUN echo 'root:yeet' | chpasswd

CMD [ "/lib/systemd/systemd" ]