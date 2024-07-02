@echo off
setlocal enabledelayedexpansion

:: Check if w32time service is running and start it if not
for /f "tokens=3 delims=: " %%H in ('sc query w32time ^| findstr "STATE"') do (
    if /i "%%H" neq "RUNNING" (
        sc start w32time
        timeout /t 5 >nul
    )
)

:: Get current date and time information
for /f "tokens=2 delims==" %%A in ('wmic os get localdatetime /value ^| find "="') do set datetime=%%A
set time=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2% %datetime:~8,2%:%datetime:~10,2%:%datetime:~12,2%

for /f "tokens=2 delims==" %%A in ('wmic timezone get standardname /value ^| find "="') do set timezone=%%A

for /f "tokens=2 delims==" %%A in ('wmic computersystem get name /value ^| find "="') do set hostname=%%A

:: Get IP addresses
set ip_count=0
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /r /c:"IPv4 Address"') do (
    set "ip=%%A"
    set "ip=!ip:~1!"
    if "!ip:~0,4!" neq "127." if "!ip:~0,8!" neq "169.254." (
        set /a ip_count+=1
        set "ip_address!ip_count!=!ip!"
    )
)

:: Get time service status
w32tm /resync >nul
for /f "tokens=*" %%A in ('w32tm /query /status ^| findstr "Stratum"') do set stratumLine=%%A
set is_time_sync_info=%stratumLine:Stratum: =%

for /f "tokens=*" %%A in ('w32tm /query /status ^| findstr "Last Successful Sync Time"') do set lastSyncTimeLine=%%A

set ntp=no
echo %lastSyncTimeLine% | findstr /i "successful" >nul && set ntp=yes

set is_time_sync=no
echo %is_time_sync_info% | findstr /i "syncd by (S)NTP" >nul && set is_time_sync=yes

:: Get OS version and caption (full name)
for /f "tokens=2 delims==" %%A in ('wmic os get version /value ^| find "="') do set os_version=%%A
for /f "tokens=2 delims==" %%A in ('wmic os get caption /value ^| find "="') do set os_name=%%A

:: Construct information string
(
    echo hostname="%hostname%"
    echo Time="%time%"
    echo Timezone="%timezone%"
    echo Stratum="%is_time_sync_info%"
    echo is_using_ntp="%ntp%"
    echo is_time_sync="%is_time_sync%"
    echo Last_Successful_Sync_Time="%lastSyncTimeLine%"
    for /L %%i in (1,1,%ip_count%) do (
        echo dest_ip%%i="!ip_address%%i!"
    )
    echo OS="%os_name% - %os_version%"
) > "C:\Windows\System32\LogFiles\server_info.log"

endlocal
