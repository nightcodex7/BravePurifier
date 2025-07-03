# Welcome to the BravePurifier Wiki

**Ultra-lightweight privacy-focused Brave Browser installer and debloater**

[![Version](https://img.shields.io/badge/version-1.0-blue.svg)](https://github.com/nightcodex7/BravePurifier)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/nightcodex7/BravePurifier/blob/main/LICENSE)
[![Shell Script](https://img.shields.io/badge/shell-bash-orange.svg)](https://github.com/nightcodex7/BravePurifier)

## 🚀 Quick Navigation

- **[Installation Guide](Installation-Guide)** - Complete installation instructions
- **[Privacy Features](Privacy-Features)** - Detailed privacy enhancements
- **[Supported Systems](Supported-Systems)** - Compatible Linux distributions
- **[Configuration](Configuration)** - Advanced configuration options
- **[Troubleshooting](Troubleshooting)** - Common issues and solutions
- **[FAQ](FAQ)** - Frequently asked questions
- **[Contributing](Contributing)** - How to contribute to the project
- **[Changelog](Changelog)** - Version history and updates

## 📖 About BravePurifier

BravePurifier is a comprehensive script that not only installs Brave Browser but also applies maximum privacy hardening with zero bloat. It's designed for privacy-conscious users who want maximum protection with minimal effort.

### Key Benefits

- 🔒 **Maximum Privacy**: Disables all telemetry and tracking
- 🛡️ **Enhanced Security**: Applies hardened security policies
- 🚫 **Zero Bloat**: Removes unnecessary features and components
- 🌐 **Universal**: Supports all major Linux distributions
- ⚡ **Lightweight**: Minimal dependencies and fast execution

## 🎯 Quick Start

```bash
curl -fsSL https://raw.githubusercontent.com/nightcodex7/BravePurifier/main/brave-purifier.sh | sudo bash
```

## 📚 Documentation Structure

This wiki is organized into several sections:

### Installation & Setup
- [Installation Guide](Installation-Guide) - Step-by-step installation
- [System Requirements](System-Requirements) - Prerequisites and compatibility
- [Post-Installation](Post-Installation) - What to do after installation

### Features & Configuration
- [Privacy Features](Privacy-Features) - Complete privacy enhancement list
- [Security Features](Security-Features) - Security hardening details
- [Configuration](Configuration) - Advanced configuration options
- [Customization](Customization) - How to customize settings

### Support & Development
- [Troubleshooting](Troubleshooting) - Common issues and solutions
- [FAQ](FAQ) - Frequently asked questions
- [Contributing](Contributing) - Development guidelines
- [API Reference](API-Reference) - Script functions and variables

## 🔗 External Links

- **Main Repository**: [https://github.com/nightcodex7/BravePurifier](https://github.com/nightcodex7/BravePurifier)
- **Issues**: [GitHub Issues](https://github.com/nightcodex7/BravePurifier/issues)
- **Releases**: [GitHub Releases](https://github.com/nightcodex7/BravePurifier/releases)

## Debloating Features

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

---

*Created by [nightcodex7](https://github.com/nightcodex7)*