# Troubleshooting

Common issues and solutions for BravePurifier installation and configuration.

## 🚨 Common Installation Issues

### Permission Denied Errors

**Problem**: Script fails with permission denied errors
```bash
bash: ./brave-purifier.sh: Permission denied
```

**Solution**:
```bash
# Make script executable
chmod +x brave-purifier.sh

# Run with sudo
sudo ./brave-purifier.sh
```

### Root Privileges Required

**Problem**: Script exits with "Root privileges required"
```bash
[ERROR] Root privileges required. Please run with sudo:
```

**Solution**:
```bash
# Always run with sudo
sudo ./brave-purifier.sh

# Or run as root
su -
./brave-purifier.sh
```

### Package Manager Not Found

**Problem**: Script cannot detect package manager
```bash
[ERROR] Unsupported package manager. Supported: APT, DNF, YUM, Pacman, Zypper, Portage
```

**Solution**:
```bash
# Check if your package manager is installed
which apt || which dnf || which yum || which pacman || which zypper || which emerge

# For Arch Linux, install AUR helper first
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

## 🌐 Network and Repository Issues

### Repository Access Denied

**Problem**: Cannot access Brave repositories
```bash
[ERROR] Failed to add Brave repository
```

**Solution**:
```bash
# Check internet connection
ping -c 4 google.com

# Check DNS resolution
nslookup brave-browser-apt-release.s3.brave.com

# Try with different DNS
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

# For corporate networks, check proxy settings
export http_proxy=http://proxy.company.com:8080
export https_proxy=http://proxy.company.com:8080
```

### GPG Key Import Failed

**Problem**: GPG key verification fails
```bash
[ERROR] GPG key import failed
```

**Solution**:
```bash
# Clear GPG cache
sudo rm -rf /tmp/tmp.*

# Import key manually (Debian/Ubuntu)
curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | \
    sudo gpg --dearmor -o /usr/share/keyrings/brave-browser-archive-keyring.gpg

# Import key manually (Fedora/RHEL)
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
```

### Package Download Failed

**Problem**: Package download fails or times out
```bash
[ERROR] Failed to download brave-browser package
```

**Solution**:
```bash
# Update package lists
sudo apt update  # Debian/Ubuntu
sudo dnf makecache  # Fedora
sudo pacman -Sy  # Arch Linux

# Clear package cache
sudo apt clean  # Debian/Ubuntu
sudo dnf clean all  # Fedora
sudo pacman -Sc  # Arch Linux

# Retry with verbose output
sudo apt install -y brave-browser -o Debug::pkgAcquire::Worker=1
```

## 🔧 System-Specific Issues

### Debian/Ubuntu Issues

**Problem**: Dependency conflicts
```bash
[ERROR] The following packages have unmet dependencies
```

**Solution**:
```bash
# Fix broken packages
sudo apt --fix-broken install

# Update system first
sudo apt update && sudo apt upgrade

# Install dependencies manually
sudo apt install curl gnupg

# Force package installation
sudo apt install -f brave-browser
```

### Fedora/RHEL Issues

**Problem**: Repository configuration fails
```bash
[ERROR] Cannot add repository
```

**Solution**:
```bash
# Check SELinux status
getenforce

# Temporarily disable SELinux if needed
sudo setenforce 0

# Add repository manually
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

# Import key manually
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
```

### Arch Linux Issues

**Problem**: AUR helper not found
```bash
[ERROR] AUR helper not found. Please install an AUR helper (yay/paru) first.
```

**Solution**:
```bash
# Install yay
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si

# Or install paru
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si

# Then run BravePurifier again
sudo ./brave-purifier.sh
```

### openSUSE Issues

**Problem**: Zypper repository conflicts
```bash
[ERROR] Repository conflicts detected
```

**Solution**:
```bash
# Remove conflicting repositories
sudo zypper removerepo brave-browser

# Refresh repositories
sudo zypper refresh

# Add repository manually
sudo zypper addrepo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo brave-browser
sudo zypper --gpg-auto-import-keys refresh brave-browser
```

## 🔒 Policy and Configuration Issues

### Policies Not Applied

**Problem**: Privacy policies don't seem to be working
```bash
[WARN] Privacy policies may not be applied correctly
```

**Solution**:
```bash
# Check if policy directory exists
ls -la /etc/brave/policies/managed/

# Verify policy file content
cat /etc/brave/policies/managed/privacy-policy.json

# Check file permissions
sudo chmod 644 /etc/brave/policies/managed/privacy-policy.json

# Restart Brave Browser completely
pkill brave-browser
brave-browser
```

### User Settings Not Applied

**Problem**: User-specific settings not working
```bash
[WARN] User settings may not be applied
```

**Solution**:
```bash
# Check user config directory
ls -la ~/.config/BraveSoftware/Brave-Browser/Default/

# Verify preferences file
cat ~/.config/BraveSoftware/Brave-Browser/Default/Preferences

# Fix ownership issues
sudo chown -R $USER:$USER ~/.config/BraveSoftware/

# Remove and recreate preferences
rm ~/.config/BraveSoftware/Brave-Browser/Default/Preferences
sudo ./brave-purifier.sh
```

### Brave Won't Start

**Problem**: Brave Browser fails to launch
```bash
[ERROR] Brave Browser failed to start
```

**Solution**:
```bash
# Check if Brave is installed
which brave-browser

# Try launching with debug output
brave-browser --enable-logging --log-level=0

# Check for conflicting processes
pkill brave-browser

# Reset user data
mv ~/.config/BraveSoftware ~/.config/BraveSoftware.backup
brave-browser

# Check system logs
journalctl -u brave-browser
```

## 🖥️ Display and Graphics Issues

### Hardware Acceleration Problems

**Problem**: Brave crashes or has display issues
```bash
[ERROR] GPU process crashed
```

**Solution**:
```bash
# Disable hardware acceleration
brave-browser --disable-gpu

# Use software rendering
brave-browser --disable-gpu --disable-software-rasterizer

# Check graphics drivers
lspci | grep VGA
glxinfo | grep "direct rendering"
```

### Wayland Compatibility

**Problem**: Issues on Wayland desktop environments
```bash
[ERROR] Wayland display server issues
```

**Solution**:
```bash
# Force X11 backend
brave-browser --ozone-platform=x11

# Or use Wayland native
brave-browser --ozone-platform=wayland --enable-features=UseOzonePlatform

# Check current display server
echo $XDG_SESSION_TYPE
```

## 🔍 Debugging and Diagnostics

### Enable Verbose Logging

```bash
# Run script with verbose output
VERBOSE=true sudo ./brave-purifier.sh

# Enable Brave debug logging
brave-browser --enable-logging --log-level=0 --v=1

# Check system logs
sudo journalctl -f | grep brave
```

### Collect System Information

```bash
# System information
uname -a
lsb_release -a

# Package manager version
apt --version || dnf --version || pacman --version

# Brave version
brave-browser --version

# Check dependencies
which curl gnupg
```

### Test Installation

```bash
# Verify Brave installation
brave-browser --version

# Test policy application
brave-browser chrome://policy/

# Check settings
brave-browser chrome://settings/

# Test privacy features
brave-browser https://browserleaks.com/webrtc
```

## 🔄 Recovery and Reset

### Complete Reset

If all else fails, perform a complete reset:

```bash
# Remove Brave completely
sudo apt remove --purge brave-browser  # Debian/Ubuntu
sudo dnf remove brave-browser          # Fedora
sudo pacman -Rns brave-browser         # Arch Linux

# Remove all configuration
sudo rm -rf /etc/brave/
rm -rf ~/.config/BraveSoftware/

# Remove repositories
sudo rm -f /etc/apt/sources.list.d/brave-browser-release.list  # Debian/Ubuntu
sudo rm -f /etc/yum.repos.d/brave-browser.repo                # Fedora/RHEL

# Clean package cache
sudo apt autoremove && sudo apt autoclean  # Debian/Ubuntu
sudo dnf autoremove && sudo dnf clean all  # Fedora

# Reinstall with BravePurifier
sudo ./brave-purifier.sh
```

### Backup and Restore

```bash
# Backup current settings
cp -r ~/.config/BraveSoftware ~/.config/BraveSoftware.backup
sudo cp -r /etc/brave /etc/brave.backup

# Restore from backup
rm -rf ~/.config/BraveSoftware
cp -r ~/.config/BraveSoftware.backup ~/.config/BraveSoftware
sudo rm -rf /etc/brave
sudo cp -r /etc/brave.backup /etc/brave
```

## 📞 Getting Additional Help

### Log Collection

When reporting issues, collect these logs:

```bash
# System information
uname -a > system-info.txt
lsb_release -a >> system-info.txt

# Package manager logs
sudo journalctl -u packagekit >> package-logs.txt

# Brave logs
brave-browser --enable-logging --log-level=0 2>&1 | tee brave-debug.log

# Script output
sudo ./brave-purifier.sh 2>&1 | tee purifier-output.log
```

### Reporting Issues

When creating a GitHub issue, include:

1. **System Information**: OS, version, architecture
2. **Error Messages**: Complete error output
3. **Steps to Reproduce**: What you did before the error
4. **Log Files**: Relevant log excerpts
5. **Expected Behavior**: What should have happened

### Community Support

- **GitHub Issues**: [Report bugs and issues](https://github.com/nightcodex7/BravePurifier/issues)
- **Discussions**: [Community discussions](https://github.com/nightcodex7/BravePurifier/discussions)
- **Wiki**: [Documentation and guides](https://github.com/nightcodex7/BravePurifier/wiki)

### Emergency Contacts

For critical security issues:
- **Security Email**: security@nightcodex7.dev
- **GPG Key**: Available on GitHub profile

---

*If you can't find a solution here, please create a detailed issue report on GitHub.*