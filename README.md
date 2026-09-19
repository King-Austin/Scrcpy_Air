# 📡 Scrcpy Air

> **A zero-cable, 1-click wireless wrapper around Scrcpy and ADB for seamless Android screen mirroring and developer device monitoring over Wi-Fi.**

[![Platform: Windows](https://img.shields.io/badge/Platform-Windows-0078D6?logo=windows&logoColor=white)](#)
[![Scrcpy: v4.1+](https://img.shields.io/badge/Scrcpy-v4.1+-brightgreen.svg)](https://github.com/Genymobile/scrcpy)
[![ADB: Fastboot & Tools](https://img.shields.io/badge/ADB-Included-blueviolet.svg)](#)
[![Connection: Wireless TCP/IP](https://img.shields.io/badge/Connection-Wireless%20TCP%2FIP-orange.svg)](#)
[![License](https://img.shields.io/badge/License-Apache%202.0-lightgrey.svg)](LICENSE.txt)

---

## 🌟 Why Scrcpy Air?

Standard `scrcpy` is an exceptional screen mirroring tool, but setting up wireless mirroring often requires repeatedly looking up phone IP addresses, typing `adb tcpip 5555`, managing disconnections, and dealing with lingering console windows.

**Scrcpy Air** packages **Scrcpy v4.1** and **ADB** with automated helper scripts and silent launchers so you can mirror and monitor your Android device wirelessly with a single click.

---

## ✨ Features

- ⚡ **1-Click Wireless Mirroring**: Launch your mirrored screen over Wi-Fi instantly with no terminal commands required.
- 🔕 **Silent Launch Mode (`.vbs`)**: Run screen mirroring cleanly without intrusive black command prompt windows popping up.
- 🔄 **Smart IP Persistence**: Auto-saves your phone's last known Wi-Fi IP so subsequent connections are instantaneous.
- 🛠️ **Automated Setup (`scrcpy-wireless-setup.bat`)**: Auto-detects device status, checks authorization, fetches IP subnet routes, and configures port `5555` automatically.
- 🎮 **Full Keyboard & Mouse Control**: Click, swipe, and type on your Android device directly from your PC desktop.
- 🚀 **Hardware-Accelerated**: Ultra low-latency Direct3D 11 rendering up to full native device resolution (e.g. 1072x2448).

---

## 📂 Project Structure & Included Launchers

```text
scrcpy-air/
│
├── scrcpy-wireless.bat            # ⚡ Instant 1-Click launcher using saved IP
├── scrcpy-wireless-noconsole.vbs  # 🔕 Completely silent launcher (zero console windows)
├── scrcpy-wireless-connect.bat    # 🔁 Interactive launcher (press Enter or type new IP)
├── scrcpy-wireless-setup.bat      # 🔌 Initial setup & re-initializer (after phone reboot)
├── README.md                      # 📖 Project documentation
├── .gitignore                     # 🛡️ Prevents committing device-specific IP cache
├── scrcpy.exe                     # 🖥️ Scrcpy 4.1 engine
├── adb.exe                        # 📱 Android Debug Bridge
└── [dependencies]                 # SDL3, FFmpeg codecs, and ADB drivers
```

---

## 🚀 Quick Start Guide

### Step 1: Initial Setup (One-time per phone reboot)
1. Connect your Android phone to your PC with a USB cable.
2. Ensure **Developer Options** and **USB Debugging** are enabled on your phone.
3. When prompted on your phone, check **"Always allow from this computer"** and tap **Allow**.
4. Double-click:
   👉 **`scrcpy-wireless-setup.bat`**
5. Once the script says `[SUCCESS]`, **unplug your USB cable**! You are now completely wireless.

---

### Step 2: Daily Reconnect (No Cables Ever Needed)
Whenever your phone and PC are on the same Wi-Fi:

- **Option A (Instant)**: Double-click **`scrcpy-wireless.bat`**
- **Option B (Silent)**: Double-click **`scrcpy-wireless-noconsole.vbs`** (opens the phone screen silently with no pop-up terminal)
- **Option C (Custom IP)**: Double-click **`scrcpy-wireless-connect.bat`** if your router assigned a new IP address.

---

## ⌨️ Essential Keyboard Shortcuts

| Shortcut (PC) | Action |
|---|---|
| `Alt` + `F` | Toggle fullscreen |
| `Alt` + `O` | Turn device screen **OFF** while keeping PC mirror active *(saves phone battery)* |
| `Alt` + `Shift` + `O` | Turn device screen back **ON** |
| `Alt` + `H` | Home button |
| `Alt` + `B` *(or Right-Click)* | Back button |
| `Alt` + `S` | App switcher (recent apps) |
| `Alt` + `Up` / `Down` | Volume Up / Down |
| `Ctrl` + `C` → `Ctrl` + `V` | Copy text on PC and paste directly into phone |
| `Alt` + `P` | Power button (screen lock/unlock) |

---

## 🔧 Troubleshooting

- **Target machine actively refused it (10061)**:
  - The Android TCP/IP daemon resets whenever your phone reboots.
  - Simply plug in the USB cable once and double-click `scrcpy-wireless-setup.bat`.
- **Device unauthorized**:
  - Unlock your phone screen and accept the USB Debugging RSA authorization prompt.
- **Different Wi-Fi Subnets**:
  - Make sure your PC and Android device are connected to the same Wi-Fi network (or connect your PC to the phone's mobile hotspot). Ensure AP Client Isolation is turned off in router settings.

---

## 📄 License
This project is built upon [Genymobile/scrcpy](https://github.com/Genymobile/scrcpy) and Android Platform Tools. Distributed under the terms of the Apache 2.0 / GPL licenses.
