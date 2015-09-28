FROM resin/raspberrypi-systemd:wheezy
MAINTAINER Shaun Mulligan <shaun@resin.io>

RUN apt-get update && apt-get install -yq \
    openssh-server \
    dbus && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd
RUN echo 'root:resin' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV DEBIAN_FRONTEND noninteractive
RUN echo "deb http://archive.raspbian.org/raspbian jessie rpi" >>  /etc/apt/sources.list
RUN apt-key adv --keyserver pgp.mit.edu  --recv-key 0x9165938D90FDDD2E
RUN apt-get update && apt-get install -yq \
    xorg \
    lxde \
    xautomation \
    libraspberrypi0 \
    libraspberrypi-bin \
    epiphany-browser \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV INITSYSTEM off
COPY start.sh start.sh
COPY src/ /usr/src/app

CMD ["bash", "/start.sh"]
