@echo off
setlocal enabledelayedexpansion

set "PHONE_IP=10.19.56.62"
if exist "%~dp0last_device_ip.txt" (
    set /p PHONE_IP=<"%~dp0last_device_ip.txt"
)
set "PHONE_IP=!PHONE_IP: =!"

echo =======================================================
echo         CONNECTING WIRELESSLY TO !PHONE_IP!
echo =======================================================
"%~dp0adb.exe" connect !PHONE_IP!:5555

echo.
echo Starting Scrcpy Wireless Mirror...
"%~dp0scrcpy.exe" -s !PHONE_IP!:5555
