#!/bin/bash
while true
do
    # keep checking if we have ip address
    wifi_info=$(ip -4 -o addr  show wlp2s0 )
    while [ -n "$wifi_info" ];
    do
       wifi_info=$(ip -4 -o addr  show wlp2s0 )
       sleep 0.25
    done

    # We get here only if IP address is lost
    # which means we're off-line
    # restart wifi
    nmcli radio wifi off && sleep 10 && nmcli radio wifi on
done
