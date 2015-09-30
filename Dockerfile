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

#install fbturbo as per:
#https://medium.com/@icebob/jessie-on-raspberry-pi-2-with-docker-and-chromium-c43b8d80e7e1
RUN apt-get update && apt-get install -yq \
    git \
    build-essential \
    xorg-dev \
    xutils-dev \
    x11proto-dri2-dev \
    libltdl-dev \
    libtool \
    automake \
    libdrm-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY /xf86-video-fbturbo/ /xf86-video-fbturbo/
RUN cd xf86-video-fbturbo && \
    autoreconf -vi && \
    ./configure --prefix=/usr && \
    make && \
    sudo make install

COPY 99-fbturbo.conf /usr/share/X11/xorg.conf.d/99-fbturbo.conf

RUN echo "deb http://vontaene.de/raspbian-updates/ . main" >>  /etc/apt/sources.list
RUN cat /etc/apt/sources.list
RUN gpg --keyserver pgp.mit.edu --recv-keys F0DAA5410C667A3E
RUN gpg --armor --export F0DAA5410C667A3E | sudo apt-key add -

ENV LC_ALL C
RUN apt-get update && apt-get update && apt-get install -yq \
    libwebkitgtk-3.0 \
    gstreamer1.0-omx=1.2.0-1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get --no-install-recommends install -yq \
    xserver-xorg \
    matchbox \
    x11-xserver-utils \
    xwit \
    fbset \
    xinit \
    xserver-xorg-video-fbdev \
    libraspberrypi0 \
    libraspberrypi-bin \
    epiphany-browser \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get --no-install-recommends install -yq \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-alsa \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV INITSYSTEM off
COPY start.sh start.sh
COPY src/ /usr/src/app

CMD ["bash", "/start.sh"]
