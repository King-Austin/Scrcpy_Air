@echo off
setlocal enabledelayedexpansion
title SCRCPY - Wireless Setup (Initial Setup / After Phone Reboot)

echo =======================================================
echo          SCRCPY WIRELESS SETUP (ONE-TIME INITIALIZER)
echo =======================================================
echo.
echo Use this script whenever your phone was rebooted or needs
echo wireless mode initialized over USB.
echo.

:CHECK_DEVICE
echo Checking for connected Android device...
set DEVICE_ID=
for /f "tokens=1,2" %%A in ('"%~dp0adb.exe" devices ^| findstr /v "List of devices" ^| findstr /v "^$"') do (
    if "%%B"=="unauthorized" (
        echo.
        echo [!] Device found, but is UNAUTHORIZED!
        echo Please unlock your phone screen and tap 'Allow' on the USB debugging prompt.
        echo Check 'Always allow from this computer' so you won't be prompted again.
        pause
        goto CHECK_DEVICE
    )
    if "%%B"=="device" (
        echo %%A | findstr ":" >nul
        if errorlevel 1 (
            set DEVICE_ID=%%A
            goto FOUND_USB_DEVICE
        )
    )
)

echo.
echo [!] No USB device detected.
echo Please connect your phone with a USB cable and ensure USB Debugging is turned ON.
echo.
pause
goto CHECK_DEVICE

:FOUND_USB_DEVICE
echo [+] Found USB device: %DEVICE_ID%
echo [+] Detecting phone Wi-Fi IP address...

set PHONE_IP=
for /f "tokens=9" %%I in ('"%~dp0adb.exe" -s %DEVICE_ID% shell ip route ^| findstr "src" ^| findstr /v "127.0.0.1"') do (
    set PHONE_IP=%%I
)

if "%PHONE_IP%"=="" (
    for /f "tokens=2 delims=/" %%I in ('"%~dp0adb.exe" -s %DEVICE_ID% shell ip -f inet addr show wlan0 ^| findstr "inet"') do (
        for /f "tokens=1 delims= " %%K in ("%%I") do (
            set PHONE_IP=%%K
        )
    )
)

if "%PHONE_IP%"=="" (
    echo [!] Could not auto-detect Wi-Fi IP.
    set /p PHONE_IP="Please enter your phone's Wi-Fi IP address (e.g. 10.19.56.62): "
) else (
    echo [+] Detected Phone IP: %PHONE_IP%
)

echo %PHONE_IP%> "%~dp0last_device_ip.txt"

echo.
echo [+] Enabling wireless TCP/IP mode on port 5555...
"%~dp0adb.exe" -s %DEVICE_ID% tcpip 5555
if %ERRORLEVEL% neq 0 (
    echo [X] Failed to enable TCP/IP mode.
    pause
    exit /b %ERRORLEVEL%
)

timeout /t 2 /nobreak >nul

echo [+] Connecting wirelessly to %PHONE_IP%:5555...
"%~dp0adb.exe" connect %PHONE_IP%:5555

echo.
echo =======================================================
echo [SUCCESS] Wireless mode enabled and connected!
echo YOU CAN NOW UNPLUG THE USB CABLE AT ANY TIME.
echo =======================================================
echo.
echo Launching wireless scrcpy mirror...
start "" "%~dp0scrcpy.exe" -s %PHONE_IP%:5555

timeout /t 3 >nul
exit /b 0
