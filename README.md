# Splunk UF Host Info
Scripts for checking the Splunk Universal Forwarder host information on Windows and Linux

You can use these scripts, for Windows and Linux, to check the information of the hosts where Splunk Universal Forwarder is installed.

You can apply these scripts to all your UFs using the Deployment Server.

Note: When applying the script on Linux, make sure to grant executable permission to the .sh file.

These scripts store all relevant information in the following paths, and you can change the default logs path by modifying the scripts.

Default paths:

Windows: C:\Windows\System32\LogFiles\server_info.log 

Linux: /var/log/server_info.log

Example: 

Windows:

hostname="DESKTOP-test"
Time="2024-07-02 20:43:21"
Timezone="Test Standard Time"
Stratum="4 (secondary reference - syncd by (S)NTP)"
is_using_ntp="yes"
is_time_sync="yes"
Last_Successful_Sync_Time="Last Successful Sync Time: 7/2/2024 8:43:22 PM"
dest_ip1="10.10.21.113"
dest_ip2="172.30.1.2"
dest_ip3="192.168.1.7"
dest_ip4="10.3.3.249"
dest_ip5="10.1.1.249"
OS="Microsoft Windows 11 - 11.0"

Linux:

hostname="linux-01"
Time="Tue 2024-07-02 20:48:21 +0330"
Timezone="Test/test"
is_using_ntp="n/a"
is_time_sync="yes"
dest_ip1="10.1.1.1"
OS="Ubuntu 20.04 LTS"


