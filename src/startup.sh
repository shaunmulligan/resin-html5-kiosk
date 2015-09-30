#/bin/bash

# Disable DPMS / Screen blanking
 xset -dpms
 xset s off
 xset s noblank

mkdir /root/.config
url=$URL
default='http://camendesign.co.uk/code/video_for_everybody/test.html'
sudo matchbox-window-manager -use_cursor no -use_titlebar no &
xte 'sleep 15' 'key F11'&
epiphany-browser -a --profile /root/.config ${url:-$default} --display=:0
sleep 2s

while [ 1 ]
do
    echo "waiting.."
    sleep 30
done
