#!/bin/bash

# Make sudo actually work
HOSTNAME=$(cat /etc/hostname)
echo "127.0.1.1 $HOSTNAME" >> /etc/hosts
hostname $HOSTNAME

if [ "$INITSYSTEM" != "on" ]; then
  /usr/sbin/sshd &
fi

ldconfig
useradd -m pi
gpasswd -a pi video

echo "allowed_users=anybody" > /etc/X11/Xwrapper.config
#xinit /usr/src/app/startup.sh
bash /usr/src/app/startBrowser.sh
