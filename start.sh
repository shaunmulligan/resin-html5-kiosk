#!/bin/bash

# Make sudo actually work
HOSTNAME=$(cat /etc/hostname)
echo "127.0.1.1 $HOSTNAME" >> /etc/hosts
hostname $HOSTNAME

if [ "$INITSYSTEM" != "on" ]; then
  /usr/sbin/sshd &
fi

bash /usr/src/app/startup.sh
