# Brave Purifier

**Ultra-lightweight privacy-focused Brave Browser installer and debloater**

[![Version](https://img.shields.io/badge/version-1.0-blue.svg)](https://github.com/nightcodex7/BravePurifier)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/nightcodex7/BravePurifier/blob/main/LICENSE)
[![Shell Script](https://img.shields.io/badge/shell-bash-orange.svg)](https://github.com/nightcodex7/BravePurifier)

## 🚀 Quick Start

**One-line installation:**
```bash
curl -fsSL https://raw.githubusercontent.com/nightcodex7/BravePurifier/main/brave-purifier.sh | sudo bash
```

**Or download and run:**
```bash
wget https://raw.githubusercontent.com/nightcodex7/BravePurifier/main/brave-purifier.sh
chmod +x brave-purifier.sh
sudo ./brave-purifier.sh
```

## 📋 What It Does

**Brave Purifier** is an ultra-lightweight script that installs Brave Browser and applies maximum privacy hardening with zero bloat.

### 🔒 Privacy Enhancements
- **Zero Telemetry**: Completely disables all data collection and reporting
- **Ad/Tracker Blocking**: Enables aggressive content blocking by default  
- **Fingerprinting Protection**: Blocks browser fingerprinting attempts
- **WebRTC Protection**: Prevents IP address leaks through WebRTC
- **Search Privacy**: Sets DuckDuckGo as default search engine
- **Permission Hardening**: Blocks camera, microphone, location, and sensor access
- **Cookie Protection**: Aggressive cookie blocking and session isolation

### 🛠️ Debloating Features

Brave Purifier now lets you choose privacy/debloat options in simple groups:

- **Brave Features & Services**: Rewards, Wallet, VPN, News, Talk, Sync, pings, analytics, crypto, web3, etc.
- **Privacy & Tracking**: Telemetry, Safe Browsing, Metrics, Log Upload, Heartbeat
- **Autofill & Passwords**: Autofill, Password Manager
- **Permissions**: Camera, Microphone, Location, Notifications, Sensors, Popups, WebUSB, WebBluetooth, Serial, HID, FileSystem, etc.
- **Other UI & Suggestions**: Spellcheck, Home Button, Import Passwords, Import Search Engine

**Prompted separately:**
- **Search Suggestions**
- **Web Store**
- **Background Mode**

**Reset to Defaults:**
- At the start, you can choose to reset all Brave settings to defaults (does NOT delete bookmarks, passwords, cookies, credentials, autofill, or sync data).

**Search Engine:**
- At the end, you can choose to set Google as the default search engine, or keep it unchanged.

**Example prompt:**
```
Do you want to reset all Brave settings to defaults before applying debloat? (This will NOT delete bookmarks, passwords, cookies, credentials, autofill, or sync data. Only settings will be reset.) [y/N]: n
Would you like to apply ALL recommended debloat options? [Y/n]: n
You will be prompted for each group. Enter 'y' to debloat, 'n' to keep as is.

Brave Features & Services (Rewards, Wallet, VPN, News, Talk, Sync, pings, analytics, crypto, web3, etc.)
  Disables all Brave-specific services, crypto, rewards, wallet, and telemetry.
Debloat this group? [Y/n]: y

Privacy & Tracking (Telemetry, Safe Browsing, Metrics, Log Upload, Heartbeat)
  Disables all tracking, telemetry, and privacy-invasive features.
Debloat this group? [Y/n]: y

Autofill & Passwords (Autofill, Password Manager)
  Disables autofill and password manager features.
Debloat this group? [Y/n]: n

Permissions (Camera, Microphone, Location, Notifications, Sensors, Popups, WebUSB, WebBluetooth, Serial, HID, FileSystem, etc.)
  Blocks access to sensitive device features and permissions.
Debloat this group? [Y/n]: y

Other UI & Suggestions (Spellcheck, Home Button, Import Passwords, Import Search Engine)
  Disables UI suggestions and import features.
Debloat this group? [Y/n]: n

Search Suggestions (address bar autocomplete, etc.)
  Disables search suggestions in the address bar.
Debloat this option? [Y/n]: y

Web Store (extension/add-on store visibility)
  Hides the web store icon and blocks extension installs.
Debloat this option? [Y/n]: y

Background Mode (Brave running in background)
  Prevents Brave from running in the background.
Debloat this option? [Y/n]: y

Do you want to set Google as the default search engine? (Otherwise, it will remain unchanged) [y/N]: n
```

All relevant settings for each group or option will be applied automatically.

### 🌐 Supported Systems
- **Debian/Ubuntu** (APT)
- **Linux Mint** (APT, see Troubleshooting below)
- **Fedora/RHEL/CentOS** (DNF/YUM)
- **Arch Linux** (Pacman + AUR)
- **openSUSE** (Zypper)
- **Gentoo** (Portage)

## 📥 Installation Methods

### Method 1: One-Line Install (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/nightcodex7/BravePurifier/main/brave-purifier.sh | sudo bash
```

### Method 2: Download and Run
```bash
wget https://raw.githubusercontent.com/nightcodex7/BravePurifier/main/brave-purifier.sh
chmod +x brave-purifier.sh
sudo ./brave-purifier.sh
```

### Method 3: Clone Repository
```bash
git clone https://github.com/nightcodex7/BravePurifier.git
cd BravePurifier
sudo ./brave-purifier.sh
```

## 🔧 Features

- **Automatic Detection**: Identifies your Linux distribution and package manager
- **Error Handling**: Robust error checking and recovery mechanisms
- **Minimal Dependencies**: Only requires `curl` and `gnupg`
- **System-Wide Policies**: Applies privacy settings for all users
- **User-Specific Settings**: Creates individual privacy configurations
- **Telemetry Purging**: Removes tracking components and crash reporters
- **Verification**: Confirms successful installation and configuration
- **Update Support**: Automatically updates existing installations

## 🛡️ Security Features

- **Root Required**: Ensures proper system-wide installation
- **GPG Verification**: Validates package signatures
- **Official Repositories**: Uses only official Brave repositories
- **No External Dependencies**: Minimal attack surface
- **Signal Handling**: Graceful interruption handling

## 📖 Usage

### Basic Usage
```bash
sudo ./brave-purifier.sh
```

### Show Help
```bash
./brave-purifier.sh --help
```

### Show Version
```bash
./brave-purifier.sh --version
```

## 🗂️ Project Structure

```
BravePurifier/
├── brave-purifier.sh           # Main installation script
├── README.md                   # This documentation
└── images/                     # Screenshots and banner images
```

## 🔄 Updates

The script automatically detects existing Brave installations and updates them while preserving all privacy settings. Simply run the script again to update.

## 🚫 Uninstallation

### Remove Brave Browser
```bash
# Debian/Ubuntu
sudo apt remove --purge brave-browser

# Fedora/RHEL
sudo dnf remove brave-browser

# Arch Linux  
sudo pacman -Rns brave-browser brave-bin

# openSUSE
sudo zypper remove brave-browser

# Gentoo
sudo emerge -C www-client/brave-bin
```

### Remove Privacy Policies
```bash
sudo rm -rf /etc/brave/
```

### Remove User Data
```bash
rm -rf ~/.config/BraveSoftware/
```

## ⚠️ Important Notes

- **Privacy First**: This script prioritizes privacy over convenience
- **Some Features Disabled**: Many Brave features are disabled for maximum privacy
- **Customizable**: Users can re-enable features through Brave settings if needed
- **System-Wide**: Changes affect all users on the system
- **Restart Required**: Restart Brave Browser after installation for all settings to take effect
- **Linux Mint Users**: If you encounter errors about missing Release files (e.g., Cloudflare WARP), see the Troubleshooting section below.

## 🔍 What Gets Configured

### System-Wide Policies
- Disables all telemetry and data collection
- Blocks autoplay, notifications, and location access
- Sets DuckDuckGo as default search engine
- Enables aggressive ad and tracker blocking
- Disables WebRTC IP leaks
- Removes crash reporting and error collection

### User-Specific Settings
- Configures minimal new tab page
- Disables all Brave-specific features (Rewards, Wallet, VPN, etc.)
- Sets aggressive cookie and privacy policies
- Disables search suggestions and autofill
- Configures secure content settings

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/enhancement`)
3. Commit your changes (`git commit -am 'Add enhancement'`)
4. Push to the branch (`git push origin feature/enhancement`)
5. Open a Pull Request

## 📄 License

MIT License - see the script header for details.

## 🔗 Links

- **Repository**: [https://github.com/nightcodex7/BravePurifier](https://github.com/nightcodex7/BravePurifier)
- **Issues**: [GitHub Issues](https://github.com/nightcodex7/BravePurifier/issues)
- **Brave Browser**: [https://brave.com](https://brave.com)
- **DuckDuckGo**: [https://duckduckgo.com](https://duckduckgo.com)

## 📊 Version History

- **v1.0** - Initial release with comprehensive privacy hardening

## 🛠️ Troubleshooting

### Cloudflare WARP or Other Third-Party Repository Errors

If you see an error like:

```
E: The repository 'https://pkg.cloudflareclient.com xia Release' does not have a Release file.
```

This is **not caused by Brave Purifier**. It means you have a broken or outdated third-party repository (often Cloudflare WARP) in your system sources. This can prevent `apt update` and any script using APT from working.

**How to fix:**
1. Open `/etc/apt/sources.list.d/` and look for files mentioning `cloudflare` or other third-party sources.
2. Remove or comment out the problematic lines/files.
3. Run `sudo apt update` again to verify the error is gone.

For more help, see:
- [Cloudflare WARP Linux repo issue](https://github.com/cloudflare/warp/issues/123)
- [Ask Ubuntu: How to fix 'does not have a Release file'](https://askubuntu.com/questions/918021/how-to-fix-repository-does-not-have-a-release-file)

---

**Made for privacy-conscious users who want maximum protection with minimal effort.**

*Created by [nightcodex7](https://github.com/nightcodex7)*