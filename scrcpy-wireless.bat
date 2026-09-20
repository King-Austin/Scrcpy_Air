@echo off
title SCRCPY AIR - Dynamic Wireless Mirroring
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scrcpy-wireless-auto.ps1"
if %ERRORLEVEL% neq 0 (
    pause
)
