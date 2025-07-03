# Brave Purifier

**Ultra-lightweight privacy-focused Brave Browser installer and debloater**

![Brave Purifier](https://raw.githubusercontent.com/yourusername/brave-purifier/main/brave-purifier-banner.png)

## 🚀 Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/brave-purifier/main/brave-purifier.sh | sudo bash
```

## 📋 What It Does

**Brave Purifier** is an ultra-lightweight script that installs Brave Browser and applies maximum privacy hardening:

### 🔒 Privacy Enhancements
- **Zero Telemetry**: Completely disables all data collection and reporting
- **Ad/Tracker Blocking**: Enables aggressive content blocking by default  
- **Fingerprinting Protection**: Blocks browser fingerprinting attempts
- **WebRTC Protection**: Prevents IP address leaks through WebRTC
- **Search Privacy**: Sets DuckDuckGo as default search engine
- **Permission Hardening**: Blocks camera, microphone, location, and sensor access

### 🛠️ Debloating Features
- **Brave Rewards**: Disabled
- **Brave Wallet**: Disabled  
- **Brave VPN**: Disabled
- **Brave News**: Disabled
- **Brave Talk**: Disabled
- **Background Sync**: Disabled
- **Search Suggestions**: Disabled
- **Autofill/Passwords**: Disabled
- **Translation**: Disabled
- **Safe Browsing**: Disabled (uses local protection)

### 🌐 Supported Systems
- **Debian/Ubuntu** (APT)
- **Fedora/RHEL/CentOS** (DNF/YUM)
- **Arch Linux** (Pacman + AUR)
- **openSUSE** (Zypper)
- **Gentoo** (Portage)

## 📥 Installation Methods

### Method 1: Direct Download & Run
```bash
wget https://raw.githubusercontent.com/yourusername/brave-purifier/main/brave-purifier.sh
chmod +x brave-purifier.sh
sudo ./brave-purifier.sh
```

### Method 2: Clone Repository
```bash
git clone https://github.com/yourusername/brave-purifier.git
cd brave-purifier
sudo ./brave-purifier.sh
```

## 🔧 Features

- **Automatic Detection**: Identifies your Linux distribution and package manager
- **Error Handling**: Robust error checking and recovery
- **Minimal Dependencies**: Only requires `curl` and `gnupg`
- **System-Wide Policies**: Applies privacy settings for all users
- **User-Specific Settings**: Creates individual privacy configurations
- **Telemetry Purging**: Removes tracking components and crash reporters
- **Verification**: Confirms successful installation and configuration

## 🛡️ Security

- **Root Required**: Ensures proper system-wide installation
- **GPG Verification**: Validates package signatures
- **Official Repositories**: Uses only official Brave repositories
- **No External Dependencies**: Minimal attack surface

## 🗂️ File Structure

```
brave-purifier/
├── brave-purifier.sh    # Main installation script
├── README.md           # This documentation
└── brave-purifier-banner.png  # Banner image
```

## 🔄 Updates

The script automatically detects existing Brave installations and updates them while preserving privacy settings.

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

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/enhancement`)
3. Commit your changes (`git commit -am 'Add enhancement'`)
4. Push to the branch (`git push origin feature/enhancement`)
5. Open a Pull Request

## 📄 License

MIT License - see the script header for details.

## 🔗 Links

- **Brave Browser**: [https://brave.com](https://brave.com)
- **DuckDuckGo**: [https://duckduckgo.com](https://duckduckgo.com)
- **Issues**: [GitHub Issues](https://github.com/yourusername/brave-purifier/issues)

---

**Made for privacy-conscious users who want maximum protection with minimal effort.**