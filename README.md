# Brave Browser Installer and Debloater Script

A comprehensive bash script that automatically installs/updates Brave Browser and applies privacy-focused debloating settings across multiple Linux distributions.

![Brave Debloater](https://github.com/yourusername/Brave-installer-and-debloater-script/raw/main/images/brave-debloater-for-linux-v0-jepfv8q5vwke1.webp)

## Features

### 🚀 **Multi-Distribution Support**
- **Debian/Ubuntu** (APT)
- **Fedora/RHEL/CentOS** (DNF)
- **Arch Linux** (Pacman)
- **openSUSE** (Zypper)

### 🔒 **Privacy & Security Enhancements**
- Disables telemetry and data collection
- Blocks ads and trackers by default
- Removes unnecessary bloatware features
- Sets DuckDuckGo as default search engine
- Disables autoplay and notifications
- Enhances fingerprinting protection
- Forces HTTPS upgrades

### 🛠️ **Debloating Features**
- **Brave Rewards**: Disabled
- **Brave Wallet**: Disabled
- **Brave VPN**: Disabled
- **Brave News**: Disabled
- **Brave Talk**: Disabled
- **Background sync**: Disabled
- **Search suggestions**: Disabled
- **Geolocation**: Blocked
- **Camera/Microphone**: Blocked
- **WebRTC IP leaks**: Prevented

## Installation

### Quick Install (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/Brave-installer-and-debloater-script/main/brave-installer.sh | sudo bash
```

### Manual Installation
1. **Download the script:**
   ```bash
   wget https://raw.githubusercontent.com/yourusername/Brave-installer-and-debloater-script/main/brave-installer.sh
   ```

2. **Make it executable:**
   ```bash
   chmod +x brave-installer.sh
   ```

3. **Run the script:**
   ```bash
   sudo ./brave-installer.sh
   ```

## What the Script Does

### 1. **System Detection**
- Automatically detects your Linux distribution
- Identifies the appropriate package manager
- Installs necessary dependencies

### 2. **Brave Installation/Update**
- Adds official Brave repositories
- Installs or updates Brave Browser
- Verifies successful installation

### 3. **System-Wide Policies**
Creates `/etc/brave/policies/managed/policy.json` with:
- Privacy-focused default settings
- Disabled tracking and telemetry
- Enhanced security configurations
- Blocked unnecessary permissions

### 4. **User-Specific Preferences**
Applies additional privacy settings for all users:
- Custom new tab page settings
- Disabled widgets and background images
- Enhanced content blocking
- Stricter permission defaults

## Supported Distributions

| Distribution | Package Manager | Status |
|--------------|----------------|---------|
| Ubuntu/Debian | APT | ✅ Fully Supported |
| Fedora/RHEL/CentOS | DNF | ✅ Fully Supported |
| Arch Linux | Pacman | ✅ Fully Supported |
| openSUSE | Zypper | ✅ Fully Supported |

## Configuration Details

### System Policies Applied
```json
{
    "AutoplayAllowed": false,
    "DefaultNotificationsSetting": 2,
    "DefaultGeolocationSetting": 2,
    "SafeBrowsingEnabled": false,
    "SyncDisabled": true,
    "BraveRewardsDisabled": true,
    "BraveWalletDisabled": true,
    "WebRTCIPHandlingPolicy": "disable_non_proxied_udp"
}
```

### Privacy Enhancements
- **Search Engine**: DuckDuckGo (privacy-focused)
- **Homepage**: about:blank (no tracking)
- **New Tab**: about:blank (clean start)
- **Autoplay**: Disabled globally
- **Notifications**: Blocked by default
- **Location Access**: Denied
- **Camera/Mic**: Blocked
- **WebRTC**: IP leak protection enabled

## Customization

### Modifying Settings
Users can still customize settings through Brave's interface:
1. Open Brave Browser
2. Go to `brave://settings/`
3. Modify preferences as needed

### Advanced Configuration
Edit the policy file for system-wide changes:
```bash
sudo nano /etc/brave/policies/managed/policy.json
```

## Troubleshooting

### Common Issues

**1. Permission Denied**
```bash
# Solution: Run with sudo
sudo ./brave-installer.sh
```

**2. Package Manager Not Found**
```bash
# Check if your distribution is supported
cat /etc/os-release
```

**3. Repository Issues**
```bash
# Clear package cache and retry
sudo apt clean && sudo apt update  # For Debian/Ubuntu
sudo dnf clean all && sudo dnf refresh  # For Fedora/RHEL
```

### Logs and Debugging
The script provides colored output for easy debugging:
- 🟢 **Green**: Successful operations
- 🟡 **Yellow**: Warnings
- 🔴 **Red**: Errors

## Uninstallation

### Remove Brave Browser
```bash
# Debian/Ubuntu
sudo apt remove --purge brave-browser

# Fedora/RHEL
sudo dnf remove brave-browser

# Arch Linux
sudo pacman -Rns brave-browser

# openSUSE
sudo zypper remove brave-browser
```

### Remove Policies
```bash
sudo rm -rf /etc/brave/
```

### Remove User Data
```bash
rm -rf ~/.config/BraveSoftware/
```

## Security Considerations

- Script requires root privileges for system-wide installation
- All downloads are from official Brave repositories
- GPG signatures are verified automatically
- No external dependencies beyond standard tools

## Contributing

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/improvement
   ```
3. **Commit your changes**
   ```bash
   git commit -am 'Add new feature'
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/improvement
   ```
5. **Create a Pull Request**

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This script modifies system settings and browser configurations. While designed to enhance privacy and security, users should review the changes and ensure they meet their specific requirements.

## Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/Brave-installer-and-debloater-script/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/Brave-installer-and-debloater-script/discussions)
- **Wiki**: [Project Wiki](https://github.com/yourusername/Brave-installer-and-debloater-script/wiki)

---

**Made with ❤️ for privacy-conscious Linux users**