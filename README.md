# Splunk-UF-Time-Sync
Scripts for checking the Splunk Universal Forwarder time on Windows and Linux

You can use these scripts, for Windows and Linux, to check the health of the time on hosts where Splunk Universal Forwarder is installed. You can apply these scripts to all your UFs using the Deployment Server.

Note: When applying the script on Linux, make sure to grant executable permission to the .sh file.

These scripts store all relevant information in the following paths, and you can change the default logs path by modifying the scripts.

Default paths:

Windows: C:\Windows\System32\LogFiles\server_info.log 

Linux: /var/log/server_info.log
