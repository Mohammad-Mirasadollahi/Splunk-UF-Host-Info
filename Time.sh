#!/bin/bash

time=$(timedatectl | grep "Local time:" | awk '{print $3 ,$4, $5, $6}')
timezone=$(timedatectl | grep "Time zone:" | awk '{print $3}')
ip_address=$(hostname -I)
hostname=$(hostname)
is_time_sync=$(timedatectl | grep "System clock synchronized:" | awk '{print $4}')
NTP=$(timedatectl | grep "NTP service:" | awk '{print $3}')

info="TIME=$time\nTimezone=$timezone\nis_time_sync=$is_time_sync\nis_using_ntp=$NTP\ndest_ip=$ip_address\nhostname=$hostname"

file_path="/var/log/server_info.log"

echo -e "$info" > "$file_path"
