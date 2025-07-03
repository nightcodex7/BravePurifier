# Supported Systems

BravePurifier supports all major Linux distributions through automatic package manager detection.

## 🐧 Supported Linux Distributions

### Debian-Based Systems (APT)
- **Ubuntu** (18.04 LTS, 20.04 LTS, 22.04 LTS, 23.04+)
- **Debian** (10 Buster, 11 Bullseye, 12 Bookworm)
- **Linux Mint** (19.x, 20.x, 21.x)
- **Elementary OS** (6.x, 7.x)
- **Pop!_OS** (20.04, 22.04)
- **Zorin OS** (16.x, 17.x)
- **MX Linux** (21.x, 23.x)
- **Kali Linux** (2022.x, 2023.x)

### Red Hat-Based Systems (DNF/YUM)
- **Fedora** (36, 37, 38, 39)
- **Red Hat Enterprise Linux** (8.x, 9.x)
- **CentOS** (8.x, 9.x)
- **Rocky Linux** (8.x, 9.x)
- **AlmaLinux** (8.x, 9.x)
- **Oracle Linux** (8.x, 9.x)

### Arch-Based Systems (Pacman)
- **Arch Linux** (Rolling release)
- **Manjaro** (21.x, 22.x, 23.x)
- **EndeavourOS** (Latest)
- **Garuda Linux** (Latest)
- **ArcoLinux** (Latest)

**Note**: Requires AUR helper (yay or paru) for optimal experience.

### SUSE-Based Systems (Zypper)
- **openSUSE Leap** (15.3, 15.4, 15.5)
- **openSUSE Tumbleweed** (Rolling release)
- **SUSE Linux Enterprise** (15.x)

### Gentoo-Based Systems (Portage)
- **Gentoo Linux** (Latest)
- **Calculate Linux** (Latest)

## 🔧 Package Manager Support

### APT (Advanced Package Tool)
```bash
# Distributions: Debian, Ubuntu, Mint, etc.
# Commands used: apt update, apt install
# Repository: https://brave-browser-apt-release.s3.brave.com/
```

### DNF (Dandified YUM)
```bash
# Distributions: Fedora, RHEL 8+, CentOS 8+
# Commands used: dnf install, dnf config-manager
# Repository: https://brave-browser-rpm-release.s3.brave.com/
```

### YUM (Yellowdog Updater Modified)
```bash
# Distributions: RHEL 7, CentOS 7, older systems
# Commands used: yum install, yum-config-manager
# Repository: https://brave-browser-rpm-release.s3.brave.com/
```

### Pacman
```bash
# Distributions: Arch Linux, Manjaro, EndeavourOS
# Commands used: pacman -S, AUR helpers (yay/paru)
# Source: AUR (brave-bin)
```

### Zypper
```bash
# Distributions: openSUSE, SUSE Linux Enterprise
# Commands used: zypper addrepo, zypper install
# Repository: https://brave-browser-rpm-release.s3.brave.com/
```

### Portage (Emerge)
```bash
# Distributions: Gentoo, Calculate Linux
# Commands used: emerge
# Package: www-client/brave-bin
```

## 🏗️ Architecture Support

### Supported Architectures
- **x86_64 (amd64)**: Full support on all distributions
- **ARM64**: Limited support (check distribution-specific availability)

### Unsupported Architectures
- **i386 (32-bit)**: Not supported by Brave Browser
- **ARM32**: Not supported by Brave Browser

## 📋 System Requirements

### Minimum Requirements
- **RAM**: 2 GB (4 GB recommended)
- **Storage**: 500 MB free space
- **CPU**: 64-bit processor
- **Network**: Internet connection for installation

### Recommended Requirements
- **RAM**: 4 GB or more
- **Storage**: 1 GB free space
- **CPU**: Multi-core 64-bit processor
- **Network**: Broadband internet connection

## 🔍 Detection Process

BravePurifier automatically detects your system using this priority order:

1. **APT** - Checks for `apt` command
2. **DNF** - Checks for `dnf` command
3. **YUM** - Checks for `yum` command
4. **Pacman** - Checks for `pacman` command
5. **Zypper** - Checks for `zypper` command
6. **Portage** - Checks for `emerge` command

## ⚠️ Special Considerations

### Arch Linux
- **AUR Helper Required**: Install `yay` or `paru` before running BravePurifier
- **Base Development Tools**: Ensure `base-devel` group is installed

```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

### Gentoo Linux
- **Package Keywords**: Script automatically adds necessary keywords
- **Compilation Time**: Binary package (brave-bin) is used for faster installation

### Enterprise Systems
- **RHEL/CentOS**: May require EPEL repository for dependencies
- **Corporate Networks**: Ensure firewall allows access to Brave repositories

## 🚫 Unsupported Systems

### Operating Systems
- **Windows**: Use Windows Subsystem for Linux (WSL) with supported distribution
- **macOS**: Not supported (use Homebrew for macOS Brave installation)
- **BSD Systems**: Not supported (FreeBSD, OpenBSD, NetBSD)

### Package Managers
- **Snap**: Not used (prefer native packages)
- **Flatpak**: Not used (prefer native packages)
- **AppImage**: Not used (prefer native packages)

## 🔧 Troubleshooting by Distribution

### Ubuntu/Debian Issues
```bash
# Update package lists
sudo apt update

# Fix broken packages
sudo apt --fix-broken install

# Clear package cache
sudo apt clean
```

### Fedora Issues
```bash
# Update system
sudo dnf update

# Clear cache
sudo dnf clean all

# Rebuild cache
sudo dnf makecache
```

### Arch Linux Issues
```bash
# Update system
sudo pacman -Syu

# Clear cache
sudo pacman -Sc

# Update AUR helper
yay -Syu
```

### openSUSE Issues
```bash
# Refresh repositories
sudo zypper refresh

# Update system
sudo zypper update

# Clear cache
sudo zypper clean
```

## 📞 Getting Help

If your distribution is not listed or you encounter issues:

1. **Check Issues**: [GitHub Issues](https://github.com/nightcodex7/BravePurifier/issues)
2. **Create Issue**: Report your distribution and error details
3. **Community Support**: Check distribution-specific forums

## 🔄 Future Support

Planned support for additional systems:
- **Alpine Linux** (APK package manager)
- **Void Linux** (XBPS package manager)
- **NixOS** (Nix package manager)

Submit feature requests for additional distribution support!