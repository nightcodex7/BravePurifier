# Installation Guide

This guide provides detailed instructions for installing BravePurifier on various Linux distributions.

## 🚀 Quick Installation

### One-Line Installation (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/nightcodex7/BravePurifier/main/brave-purifier.sh | sudo bash
```

### Alternative Methods

#### Method 1: Download and Run
```bash
wget https://raw.githubusercontent.com/nightcodex7/BravePurifier/main/brave-purifier.sh
chmod +x brave-purifier.sh
sudo ./brave-purifier.sh
```

#### Method 2: Clone Repository
```bash
git clone https://github.com/nightcodex7/BravePurifier.git
cd BravePurifier
sudo ./brave-purifier.sh
```

## 📋 Prerequisites

### System Requirements
- **Root Access**: Script must be run with `sudo` or as root
- **Internet Connection**: Required for downloading packages
- **Supported Linux Distribution**: See [Supported Systems](Supported-Systems)

### Minimal Dependencies
The script automatically installs these minimal dependencies:
- `curl` - For downloading packages and keys
- `gnupg` - For package signature verification

## 🔧 Installation Process

### Step 1: Download Script
Choose one of the download methods above.

### Step 2: Make Executable (if downloaded manually)
```bash
chmod +x brave-purifier.sh
```

### Step 3: Run with Root Privileges
```bash
sudo ./brave-purifier.sh
```

### Step 4: Follow On-Screen Instructions
The script will:
1. Detect your package manager
2. Install minimal dependencies
3. Add Brave repository
4. Install/update Brave Browser
5. Apply privacy policies
6. Configure user settings
7. Remove telemetry components
8. Verify installation

## 🖥️ Distribution-Specific Instructions

### Debian/Ubuntu (APT)
```bash
# The script automatically:
# 1. Adds Brave GPG key
# 2. Adds Brave repository
# 3. Updates package list
# 4. Installs brave-browser
```

### Fedora/RHEL/CentOS (DNF/YUM)
```bash
# The script automatically:
# 1. Imports Brave GPG key
# 2. Adds Brave repository
# 3. Installs brave-browser
```

### Arch Linux (Pacman)
```bash
# Requires AUR helper (yay or paru)
# Install AUR helper first if not available:
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

### openSUSE (Zypper)
```bash
# The script automatically:
# 1. Adds Brave repository
# 2. Imports GPG keys
# 3. Installs brave-browser
```

### Gentoo (Portage)
```bash
# The script automatically:
# 1. Adds package keywords
# 2. Emerges brave-bin
```

## ✅ Verification

After installation, verify that Brave is properly installed:

```bash
# Check if Brave is installed
brave-browser --version

# Check if privacy policies are applied
ls -la /etc/brave/policies/managed/

# Check user settings (replace username)
ls -la /home/username/.config/BraveSoftware/Brave-Browser/Default/
```

## 🔄 Updates

To update an existing installation:
```bash
sudo ./brave-purifier.sh
```

The script automatically detects existing installations and updates them while preserving privacy settings.

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

- **Backup**: Consider backing up existing Brave settings before running
- **Restart Required**: Restart Brave Browser after installation
- **System-Wide**: Changes affect all users on the system
- **Privacy First**: Some features will be disabled for maximum privacy

## 🆘 Troubleshooting

If you encounter issues, see the [Troubleshooting](Troubleshooting) page or check [FAQ](FAQ) for common solutions.