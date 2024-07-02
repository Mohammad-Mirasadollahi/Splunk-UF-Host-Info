#!/bin/bash

# Extract hostname
hostname=$(hostname)

# Extract local time information
time=$(timedatectl | grep "Local time:" | awk '{print $3, $4, $5, $6}')

# Extract timezone information
timezone=$(timedatectl | grep "Time zone:" | awk '{print $3}')

# Check NTP service status
NTP=$(timedatectl | grep "NTP service:" | awk '{print $3}')

# Check if the system clock is synchronized
is_time_sync=$(timedatectl | grep "System clock synchronized:" | awk '{print $4}')

# Extract IP addresses
ip_addresses=$(hostname -I)

# Extract OS version
os_version=$(lsb_release -d | awk -F"\t" '{print $2}')

# Initialize info string with information in desired order
info="hostname=\"$hostname\"\nTtime=\"$time\"\nTimezone=\"$timezone\"\nis_using_ntp=\"$NTP\"\nis_time_sync=\"$is_time_sync\""

# Add each IP address to the info string
ip_counter=1
for ip in $ip_addresses; do
    info="$info\ndest_ip$ip_counter=\"$ip\""
    ((ip_counter++))
done

# Add OS version to the info string
info="$info\nOS=\"$os_version\""

# Path to the output file
file_path="/var/log/server_info.log"

# Write the information to the output file
echo -e "$info" > "$file_path"
