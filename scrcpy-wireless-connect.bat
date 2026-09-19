@echo off
setlocal enabledelayedexpansion
title SCRCPY - Wireless Mirroring

echo =======================================================
echo              SCRCPY WIRELESS MIRRORING
echo =======================================================
echo.

set "DEFAULT_IP=10.19.56.62"
if exist "%~dp0last_device_ip.txt" (
    set /p DEFAULT_IP=<"%~dp0last_device_ip.txt"
)
set "DEFAULT_IP=!DEFAULT_IP: =!"

echo Make sure your phone and PC are connected to the same Wi-Fi.
echo.
echo Current Target Phone IP: [!DEFAULT_IP!]
set /p TARGET_IP="Press [ENTER] to connect to [!DEFAULT_IP!], or enter a new IP: "

if "!TARGET_IP!"=="" (
    set "TARGET_IP=!DEFAULT_IP!"
)
set "TARGET_IP=!TARGET_IP: =!"

echo !TARGET_IP!> "%~dp0last_device_ip.txt"

echo.
echo Connecting to !TARGET_IP!:5555 over Wi-Fi...
"%~dp0adb.exe" connect !TARGET_IP!:5555

echo.
echo Starting Scrcpy Wireless Mirror...
start "" "%~dp0scrcpy.exe" -s !TARGET_IP!:5555

echo.
echo Mirror window launched!
timeout /t 3 >nul
exit /b 0
