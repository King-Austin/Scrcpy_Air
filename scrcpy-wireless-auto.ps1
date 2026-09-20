$ErrorActionPreference = "SilentlyContinue"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Adb = Join-Path $ScriptDir "adb.exe"
$Scrcpy = Join-Path $ScriptDir "scrcpy.exe"
$IpFile = Join-Path $ScriptDir "last_device_ip.txt"

Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "         SCRCPY AIR - DYNAMIC WIRELESS LAUNCHER         " -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host ""

# Function to launch Scrcpy on an endpoint
function Launch-Scrcpy($target) {
    Write-Host "[+] Connecting to $target..." -ForegroundColor Green
    & $Adb connect $target | Out-Null
    $target | Out-File -FilePath $IpFile -Encoding utf8
    Write-Host "[+] Launching Scrcpy Screen Mirror..." -ForegroundColor Cyan
    & $Scrcpy -s $target
    exit $LASTEXITCODE
}

# 1. Check if a device is ALREADY connected in adb devices
$activeDevices = @(& $Adb devices | Where-Object { $_ -match "\tdevice$" })
if ($activeDevices.Count -gt 0) {
    $firstDevice = (($activeDevices[0] -split '\s+')[0]).Trim()
    Write-Host "[+] Found active connected device: $firstDevice" -ForegroundColor Green
    Launch-Scrcpy $firstDevice
}

# 2. Try dynamic mDNS discovery (Wireless Debugging on Android 11+)
Write-Host "[*] Searching for devices with Wireless Debugging (mDNS)..." -ForegroundColor Yellow
$mdnsOutput = @(& $Adb mdns services)
$connectServices = @($mdnsOutput | Where-Object { $_ -match "_adb-tls-connect\._tcp" })

if ($connectServices.Count -gt 0) {
    $endpoint = (($connectServices[0] -split '\s+')[-1]).Trim()
    Write-Host "[+] Discovered phone via Wireless Debugging at: $endpoint" -ForegroundColor Green
    Launch-Scrcpy $endpoint
}

# 3. Check for USB device to auto-switch to wireless
$usbDevices = @(& $Adb devices | Where-Object { $_ -match "\tdevice$" -and $_ -notmatch ":" })
if ($usbDevices.Count -gt 0) {
    $usbSerial = (($usbDevices[0] -split '\s+')[0]).Trim()
    Write-Host "[+] USB device detected ($usbSerial). Switching to wireless mode..." -ForegroundColor Cyan
    & $Adb -s $usbSerial tcpip 5555
    Start-Sleep -Seconds 2
    $ipRoute = @(& $Adb -s $usbSerial shell ip route | Select-String "src" | Select-String -NotMatch "127.0.0.1")
    if ($ipRoute.Count -gt 0) {
        $phoneIp = (($ipRoute[0] -split '\s+')[-1]).Trim()
        if ($phoneIp) {
            Launch-Scrcpy "$($phoneIp):5555"
        }
    }
}

# 4. Fallback: Try saved IP address
if (Test-Path $IpFile) {
    $savedEndpoint = (Get-Content $IpFile -Raw).Trim()
    if ($savedEndpoint) {
        Write-Host "[*] Trying last known address: $savedEndpoint..." -ForegroundColor Yellow
        $result = & $Adb connect $savedEndpoint
        if ($result -match "connected") {
            Write-Host "[+] Reconnected to $savedEndpoint!" -ForegroundColor Green
            & $Scrcpy -s $savedEndpoint
            exit $LASTEXITCODE
        }
    }
}

# 5. If all automatic methods failed:
Write-Host ""
Write-Host "[!] Could not automatically find a wireless device." -ForegroundColor Red
Write-Host "Please ensure:" -ForegroundColor Yellow
Write-Host "  1. Your phone and PC are on the SAME Wi-Fi network."
Write-Host "  2. In phone Settings -> Developer Options -> 'Wireless Debugging' is turned ON."
Write-Host ""
$manual = Read-Host "Or enter your phone IP:PORT manually (e.g. 192.168.1.6:45337)"
if ($manual) {
    $manual = $manual.Trim()
    Launch-Scrcpy $manual
}
