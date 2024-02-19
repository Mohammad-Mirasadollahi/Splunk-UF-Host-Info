# Check if w32time service is running and start it if not
$w32timeService = Get-Service -Name w32time

if ($w32timeService.Status -ne 'Running') {
    Start-Service -Name w32time
    Start-Sleep -Seconds 5  # Wait for the service to start
}

# Get current date and time information
$time = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
$timezone = Get-TimeZone
$ip_address = (Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' }).IPAddress
$hostname = $env:COMPUTERNAME

# Filter ip addresses
$dest_ip = $ip_address -replace '^127\..*', '' -replace '^169\.254\..*', ''


# Get time service status
w32tm /resync
$timeServiceStatus = w32tm /query /status
$stratumLine = $timeServiceStatus | Select-String -Pattern "Stratum:"
$is_time_sync_info = ($stratumLine -split ":")[1].Trim()


$lastSyncTimeLine = $timeServiceStatus | Select-String -Pattern "Last Successful Sync Time:"

if ($lastSyncTimeLine -like "*successful*") {
    $ntp = "yes"
} else {
    $ntp = "no"
}

if ($is_time_sync_info -like "*syncd by (S)NTP*") {
    $is_time_sync = "yes"
} else {
    $is_time_sync = "no"
}

# Construct information string
$info = "TIME=$time`nTimezone=$timezone`nis_time_sync_info=Stratum:$is_time_sync_info`nlastSyncTimeLine=$lastSyncTimeLine`nis_using_ntp=$ntp`ndest_ip=$dest_ip`nhostname=$hostname`nis_time_sync=$is_time_sync"

# Write information to the log file
$info > "C:\Windows\System32\LogFiles\server_info.log"
