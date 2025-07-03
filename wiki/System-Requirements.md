# System Requirements

Detailed system requirements and compatibility information for BravePurifier.

## 🖥️ Minimum System Requirements

### Hardware Requirements
- **CPU**: 64-bit processor (x86_64/amd64)
- **RAM**: 2 GB minimum (4 GB recommended)
- **Storage**: 500 MB free disk space
- **Network**: Internet connection for package downloads

### Software Requirements
- **Operating System**: Linux (64-bit)
- **Kernel**: Linux kernel 3.10 or newer
- **Package Manager**: One of the supported package managers
- **Shell**: Bash 4.0 or newer
- **Root Access**: sudo privileges or root account

## 🐧 Supported Operating Systems

### Debian-Based Systems
| Distribution | Version | Status | Notes |
|--------------|---------|--------|-------|
| Ubuntu | 18.04 LTS | ✅ Supported | Bionic Beaver |
| Ubuntu | 20.04 LTS | ✅ Supported | Focal Fossa |
| Ubuntu | 22.04 LTS | ✅ Supported | Jammy Jellyfish |
| Ubuntu | 23.04+ | ✅ Supported | Latest releases |
| Debian | 10 (Buster) | ✅ Supported | Stable |
| Debian | 11 (Bullseye) | ✅ Supported | Stable |
| Debian | 12 (Bookworm) | ✅ Supported | Current stable |
| Linux Mint | 19.x | ✅ Supported | Based on Ubuntu 18.04 |
| Linux Mint | 20.x | ✅ Supported | Based on Ubuntu 20.04 |
| Linux Mint | 21.x | ✅ Supported | Based on Ubuntu 22.04 |
| Elementary OS | 6.x | ✅ Supported | Odin |
| Elementary OS | 7.x | ✅ Supported | Horus |
| Pop!_OS | 20.04+ | ✅ Supported | System76 distribution |
| Zorin OS | 16.x | ✅ Supported | Based on Ubuntu 20.04 |
| Zorin OS | 17.x | ✅ Supported | Based on Ubuntu 22.04 |

### Red Hat-Based Systems
| Distribution | Version | Status | Notes |
|--------------|---------|--------|-------|
| Fedora | 36 | ✅ Supported | EOL but functional |
| Fedora | 37 | ✅ Supported | EOL but functional |
| Fedora | 38 | ✅ Supported | Current |
| Fedora | 39 | ✅ Supported | Latest |
| RHEL | 8.x | ✅ Supported | Enterprise |
| RHEL | 9.x | ✅ Supported | Latest enterprise |
| CentOS | 8.x | ✅ Supported | Stream |
| CentOS | 9.x | ✅ Supported | Stream |
| Rocky Linux | 8.x | ✅ Supported | RHEL compatible |
| Rocky Linux | 9.x | ✅ Supported | RHEL compatible |
| AlmaLinux | 8.x | ✅ Supported | RHEL compatible |
| AlmaLinux | 9.x | ✅ Supported | RHEL compatible |

### Arch-Based Systems
| Distribution | Version | Status | Notes |
|--------------|---------|--------|-------|
| Arch Linux | Rolling | ✅ Supported | Requires AUR helper |
| Manjaro | 21.x | ✅ Supported | Stable branch |
| Manjaro | 22.x | ✅ Supported | Stable branch |
| Manjaro | 23.x | ✅ Supported | Current stable |
| EndeavourOS | Latest | ✅ Supported | Arch-based |
| Garuda Linux | Latest | ✅ Supported | Gaming-focused |
| ArcoLinux | Latest | ✅ Supported | Educational |

### SUSE-Based Systems
| Distribution | Version | Status | Notes |
|--------------|---------|--------|-------|
| openSUSE Leap | 15.3 | ✅ Supported | Stable |
| openSUSE Leap | 15.4 | ✅ Supported | Stable |
| openSUSE Leap | 15.5 | ✅ Supported | Current stable |
| openSUSE Tumbleweed | Rolling | ✅ Supported | Rolling release |
| SUSE Linux Enterprise | 15.x | ✅ Supported | Enterprise |

### Gentoo-Based Systems
| Distribution | Version | Status | Notes |
|--------------|---------|--------|-------|
| Gentoo Linux | Latest | ✅ Supported | Source-based |
| Calculate Linux | Latest | ✅ Supported | Gentoo derivative |

## 🏗️ Architecture Support

### Supported Architectures
- **x86_64 (amd64)**: Full support on all distributions
- **ARM64 (aarch64)**: Limited support, depends on Brave availability

### Unsupported Architectures
- **i386 (32-bit)**: Not supported by Brave Browser
- **ARM32**: Not supported by Brave Browser
- **RISC-V**: Not supported by Brave Browser
- **PowerPC**: Not supported by Brave Browser

## 📦 Package Manager Requirements

### APT (Debian/Ubuntu)
```bash
# Required commands
apt --version          # APT package manager
curl --version         # Download tool
gpg --version          # GPG verification

# Minimum versions
apt >= 1.6.0
curl >= 7.58.0
gnupg >= 2.2.0
```

### DNF (Fedora)
```bash
# Required commands
dnf --version          # DNF package manager
curl --version         # Download tool
gpg2 --version         # GPG verification

# Minimum versions
dnf >= 4.0.0
curl >= 7.61.0
gnupg2 >= 2.2.0
```

### YUM (RHEL/CentOS)
```bash
# Required commands
yum --version          # YUM package manager
curl --version         # Download tool
gpg2 --version         # GPG verification

# Minimum versions
yum >= 3.4.0
curl >= 7.29.0
gnupg2 >= 2.0.0
```

### Pacman (Arch Linux)
```bash
# Required commands
pacman --version       # Pacman package manager
curl --version         # Download tool
gpg --version          # GPG verification
yay --version          # AUR helper (recommended)

# Minimum versions
pacman >= 5.0.0
curl >= 7.60.0
gnupg >= 2.2.0
```

### Zypper (openSUSE)
```bash
# Required commands
zypper --version       # Zypper package manager
curl --version         # Download tool
gpg2 --version         # GPG verification

# Minimum versions
zypper >= 1.14.0
curl >= 7.60.0
gnupg2 >= 2.2.0
```

### Portage (Gentoo)
```bash
# Required commands
emerge --version       # Portage package manager
curl --version         # Download tool
gpg --version          # GPG verification

# Minimum versions
portage >= 2.3.0
curl >= 7.60.0
gnupg >= 2.2.0
```

## 🌐 Network Requirements

### Internet Connectivity
- **Bandwidth**: Minimum 1 Mbps for package downloads
- **Protocols**: HTTP/HTTPS access required
- **DNS**: Functional DNS resolution
- **Firewall**: Outbound connections on ports 80/443

### Repository Access
BravePurifier requires access to:
- **Brave Repositories**: 
  - `brave-browser-apt-release.s3.brave.com` (Debian/Ubuntu)
  - `brave-browser-rpm-release.s3.brave.com` (Fedora/RHEL)
- **Distribution Repositories**: Standard package repositories
- **GPG Key Servers**: For signature verification

### Corporate Networks
For corporate environments:
- **Proxy Support**: Configure HTTP_PROXY/HTTPS_PROXY environment variables
- **Certificate Validation**: May need corporate CA certificates
- **Firewall Rules**: Whitelist required domains and ports

## 💾 Storage Requirements

### Disk Space
- **BravePurifier Script**: < 1 MB
- **Brave Browser**: ~200 MB
- **Dependencies**: ~50 MB
- **Configuration**: < 1 MB
- **Total Recommended**: 500 MB free space

### File System
- **Type**: Any standard Linux file system (ext4, xfs, btrfs, etc.)
- **Permissions**: Standard POSIX permissions support
- **Case Sensitivity**: Case-sensitive file system required

## 🔒 Security Requirements

### User Privileges
- **Root Access**: Required for system-wide installation
- **sudo Configuration**: Proper sudo setup for non-root users
- **File Permissions**: Ability to modify system directories

### Security Features
- **GPG Support**: For package signature verification
- **SSL/TLS**: For secure downloads
- **File System Security**: Standard Linux security model

## 🖱️ Desktop Environment

### Supported Desktop Environments
- **GNOME**: Full support
- **KDE Plasma**: Full support
- **XFCE**: Full support
- **MATE**: Full support
- **Cinnamon**: Full support
- **LXQt**: Full support
- **i3/Sway**: Full support (tiling window managers)

### Display Servers
- **X11**: Full support
- **Wayland**: Full support (with some limitations)

### Graphics Requirements
- **OpenGL**: OpenGL 2.0 or newer
- **Hardware Acceleration**: Optional but recommended
- **Display**: Minimum 1024x768 resolution

## 🔧 Development Requirements

### For Contributors
- **Git**: Version control system
- **Text Editor**: Any text editor or IDE
- **Bash Knowledge**: For script development
- **Testing Environment**: Virtual machines or containers recommended

### Testing Requirements
- **Multiple Distributions**: Access to various Linux distributions
- **Virtual Machines**: For safe testing
- **Network Simulation**: For testing network conditions

## ⚠️ Known Limitations

### Unsupported Systems
- **Windows**: Not supported (use WSL as alternative)
- **macOS**: Not supported
- **BSD Systems**: FreeBSD, OpenBSD, NetBSD not supported
- **Mobile**: Android, iOS not supported

### Architecture Limitations
- **32-bit Systems**: Not supported due to Brave Browser limitations
- **Embedded Systems**: May not have sufficient resources

### Network Limitations
- **Offline Installation**: Not supported (requires internet)
- **Air-Gapped Systems**: Not compatible
- **Restricted Networks**: May require additional configuration

## 🔍 Compatibility Testing

### Verification Commands
```bash
# Check system architecture
uname -m

# Check available memory
free -h

# Check disk space
df -h /

# Check package manager
which apt || which dnf || which pacman || which zypper || which emerge

# Check network connectivity
ping -c 4 google.com

# Check GPG support
gpg --version

# Check curl support
curl --version
```

### Pre-Installation Check Script
```bash
#!/bin/bash
# check-compatibility.sh

echo "BravePurifier Compatibility Check"
echo "================================="

# Architecture check
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    echo "✅ Architecture: $ARCH (supported)"
else
    echo "❌ Architecture: $ARCH (not supported)"
    exit 1
fi

# Memory check
MEM_GB=$(free -g | awk '/^Mem:/{print $2}')
if [[ $MEM_GB -ge 2 ]]; then
    echo "✅ Memory: ${MEM_GB}GB (sufficient)"
else
    echo "⚠️  Memory: ${MEM_GB}GB (minimum 2GB recommended)"
fi

# Disk space check
DISK_GB=$(df -BG / | awk 'NR==2{print $4}' | sed 's/G//')
if [[ $DISK_GB -ge 1 ]]; then
    echo "✅ Disk Space: ${DISK_GB}GB available (sufficient)"
else
    echo "❌ Disk Space: ${DISK_GB}GB available (insufficient)"
    exit 1
fi

# Package manager check
if command -v apt >/dev/null 2>&1; then
    echo "✅ Package Manager: APT detected"
elif command -v dnf >/dev/null 2>&1; then
    echo "✅ Package Manager: DNF detected"
elif command -v yum >/dev/null 2>&1; then
    echo "✅ Package Manager: YUM detected"
elif command -v pacman >/dev/null 2>&1; then
    echo "✅ Package Manager: Pacman detected"
elif command -v zypper >/dev/null 2>&1; then
    echo "✅ Package Manager: Zypper detected"
elif command -v emerge >/dev/null 2>&1; then
    echo "✅ Package Manager: Portage detected"
else
    echo "❌ Package Manager: None supported detected"
    exit 1
fi

echo "✅ System is compatible with BravePurifier"
```

---

*For specific compatibility questions or issues, please create an issue on GitHub with your system details.*