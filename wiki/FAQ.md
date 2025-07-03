# Frequently Asked Questions (FAQ)

Common questions and answers about BravePurifier.

## 🔍 General Questions

### What is BravePurifier?

**Q**: What exactly does BravePurifier do?

**A**: BravePurifier is an ultra-lightweight script that installs Brave Browser and applies comprehensive privacy hardening. It disables all telemetry, tracking, and unnecessary features while enabling maximum privacy protection. Think of it as a "privacy-first" installation of Brave Browser.

### Why use BravePurifier instead of regular Brave installation?

**Q**: Why not just install Brave normally and configure it manually?

**A**: BravePurifier provides several advantages:
- **Comprehensive**: Applies 50+ privacy settings automatically
- **System-wide**: Configures policies for all users
- **Consistent**: Ensures identical privacy configuration across systems
- **Time-saving**: No manual configuration required
- **Expert-level**: Applies advanced privacy settings most users don't know about

### Is BravePurifier safe to use?

**Q**: Can I trust this script with my system?

**A**: Yes, BravePurifier is designed with safety in mind:
- **Open Source**: All code is publicly available for review
- **No Data Collection**: Script doesn't collect or transmit any data
- **Official Sources**: Only uses official Brave repositories
- **Minimal Dependencies**: Only requires `curl` and `gnupg`
- **Reversible**: All changes can be undone

## 🔧 Installation Questions

### Do I need to uninstall existing Brave first?

**Q**: I already have Brave installed. Do I need to remove it first?

**A**: No, BravePurifier automatically detects existing installations and updates them while applying privacy settings. Your bookmarks and essential data are preserved.

### Can I run BravePurifier multiple times?

**Q**: What happens if I run the script again?

**A**: Running BravePurifier multiple times is safe and recommended for updates. It will:
- Update Brave Browser to the latest version
- Reapply privacy policies
- Fix any configuration drift
- Preserve user customizations where possible

### Why does the script require root privileges?

**Q**: Why do I need to run the script with `sudo`?

**A**: Root privileges are required to:
- Install packages system-wide
- Add official Brave repositories
- Apply system-wide privacy policies
- Configure settings for all users
- Remove telemetry components

### Which Linux distributions are supported?

**Q**: Will BravePurifier work on my Linux distribution?

**A**: BravePurifier supports all major Linux distributions:
- **Debian/Ubuntu** (APT)
- **Fedora/RHEL/CentOS** (DNF/YUM)
- **Arch Linux** (Pacman + AUR)
- **openSUSE** (Zypper)
- **Gentoo** (Portage)

See [Supported Systems](Supported-Systems) for the complete list.

## 🔒 Privacy Questions

### What privacy features are enabled?

**Q**: What specific privacy enhancements does BravePurifier apply?

**A**: BravePurifier enables comprehensive privacy protection:
- **Telemetry**: All data collection disabled
- **Tracking**: Ads, trackers, and fingerprinting blocked
- **Permissions**: Camera, microphone, location access blocked
- **Search**: DuckDuckGo set as default search engine
- **Network**: WebRTC IP leak protection enabled
- **Features**: Brave Rewards, Wallet, VPN, News disabled
- **Cookies**: Aggressive third-party cookie blocking

See [Privacy Features](Privacy-Features) for the complete list.

### Can I re-enable disabled features?

**Q**: What if I want to use Brave Rewards or other disabled features?

**A**: Yes, you can re-enable features through Brave's settings:
- Open Brave Browser
- Go to `Settings` → `Privacy and security`
- Adjust individual settings as needed
- Some features may require restarting Brave

However, re-enabling features may reduce your privacy protection.

### Does BravePurifier break any websites?

**Q**: Will the aggressive privacy settings break websites I visit?

**A**: Most websites work perfectly with BravePurifier settings. However:
- **Some sites** may require enabling JavaScript or cookies
- **Video calls** may need camera/microphone permissions
- **Location services** will need to be enabled per-site
- **Payment sites** may need to be whitelisted

You can adjust settings per-site using Brave's shield controls.

## 🛠️ Technical Questions

### How do I verify the privacy settings are working?

**Q**: How can I test that the privacy features are actually working?

**A**: Test your privacy protection using these tools:
- **WebRTC Leaks**: [browserleaks.com/webrtc](https://browserleaks.com/webrtc)
- **Fingerprinting**: [amiunique.org](https://amiunique.org)
- **Trackers**: [privacybadger.org](https://privacybadger.org)
- **DNS Leaks**: [dnsleaktest.com](https://dnsleaktest.com)

You should see minimal fingerprinting, no WebRTC leaks, and blocked trackers.

### Where are the configuration files stored?

**Q**: Where does BravePurifier store its configuration?

**A**: Configuration is stored in multiple locations:
- **System policies**: `/etc/brave/policies/managed/`
- **User settings**: `~/.config/BraveSoftware/Brave-Browser/Default/`
- **Script logs**: `/var/log/brave-purifier.log` (if logging enabled)

### Can I customize the privacy settings?

**Q**: Can I modify the privacy policies applied by BravePurifier?

**A**: Yes, you can customize settings:
- **System-wide**: Edit `/etc/brave/policies/managed/privacy-policy.json`
- **Per-user**: Modify `~/.config/BraveSoftware/Brave-Browser/Default/Preferences`
- **Runtime**: Use Brave's settings interface

See [Configuration](Configuration) for detailed customization options.

## 🔄 Update Questions

### How do I update Brave Browser?

**Q**: How do I keep Brave Browser updated?

**A**: Simply run BravePurifier again:
```bash
sudo ./brave-purifier.sh
```

This will update Brave while preserving your privacy settings.

### Do privacy settings persist after updates?

**Q**: Will my privacy settings be lost when Brave updates?

**A**: No, privacy settings persist because:
- **System policies** are stored separately from Brave
- **User preferences** are preserved during updates
- **BravePurifier** can be re-run to restore settings if needed

### How often should I run BravePurifier?

**Q**: How frequently should I run the script?

**A**: Run BravePurifier:
- **Monthly**: To get latest Brave updates
- **After system updates**: To ensure compatibility
- **When settings drift**: If you notice privacy settings changed
- **For new users**: When adding users to the system

## 🚫 Uninstallation Questions

### How do I uninstall Brave Browser?

**Q**: How do I completely remove Brave Browser and BravePurifier settings?

**A**: Complete removal process:

```bash
# Remove Brave Browser
sudo apt remove --purge brave-browser  # Debian/Ubuntu
sudo dnf remove brave-browser          # Fedora
sudo pacman -Rns brave-browser         # Arch Linux

# Remove privacy policies
sudo rm -rf /etc/brave/

# Remove user data
rm -rf ~/.config/BraveSoftware/

# Remove repositories (optional)
sudo rm -f /etc/apt/sources.list.d/brave-browser-release.list
```

### Can I revert to default Brave settings?

**Q**: How do I undo BravePurifier changes and use default Brave settings?

**A**: To revert to default settings:

```bash
# Remove privacy policies
sudo rm -rf /etc/brave/policies/

# Reset user preferences
rm -rf ~/.config/BraveSoftware/Brave-Browser/Default/Preferences

# Restart Brave Browser
pkill brave-browser
brave-browser
```

## 🔧 Troubleshooting Questions

### The script fails with permission errors

**Q**: I get "Permission denied" errors when running the script

**A**: Ensure you're running with proper permissions:
```bash
# Make script executable
chmod +x brave-purifier.sh

# Run with sudo
sudo ./brave-purifier.sh
```

### Brave won't start after installation

**Q**: Brave Browser won't launch after running BravePurifier

**A**: Try these solutions:
```bash
# Check if Brave is installed
brave-browser --version

# Try launching with debug output
brave-browser --enable-logging --log-level=0

# Reset user data if needed
mv ~/.config/BraveSoftware ~/.config/BraveSoftware.backup
brave-browser
```

### Package manager not detected

**Q**: The script says my package manager is unsupported

**A**: Verify your package manager is installed:
```bash
# Check available package managers
which apt || which dnf || which pacman || which zypper

# For Arch Linux, install AUR helper first
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

## 🌐 Network Questions

### Can I use BravePurifier behind a corporate firewall?

**Q**: Will BravePurifier work in corporate environments with restricted internet?

**A**: BravePurifier may work with additional configuration:
- **Proxy settings**: Configure proxy environment variables
- **Firewall rules**: Ensure access to Brave repositories
- **Certificate issues**: May need to import corporate certificates

Contact your IT department for assistance with corporate network configuration.

### Does BravePurifier work with VPNs?

**Q**: Can I use BravePurifier while connected to a VPN?

**A**: Yes, BravePurifier works perfectly with VPNs and actually enhances privacy when combined with VPN usage. The script doesn't interfere with VPN connections.

## 📱 Platform Questions

### Does BravePurifier work on mobile devices?

**Q**: Can I use BravePurifier on Android or iOS?

**A**: No, BravePurifier is designed specifically for Linux desktop systems. Mobile platforms have different security models and don't support the same level of system-wide configuration.

### What about Windows or macOS?

**Q**: Will BravePurifier ever support Windows or macOS?

**A**: Currently, BravePurifier is Linux-only. However:
- **Windows**: You could use WSL (Windows Subsystem for Linux)
- **macOS**: Similar privacy configurations could be developed for Homebrew
- **Future**: Cross-platform support may be considered

## 🤝 Contributing Questions

### How can I contribute to BravePurifier?

**Q**: I want to help improve BravePurifier. How can I contribute?

**A**: Contributions are welcome:
- **Bug Reports**: Submit issues on GitHub
- **Feature Requests**: Suggest improvements
- **Code Contributions**: Submit pull requests
- **Documentation**: Help improve the wiki
- **Testing**: Test on different distributions

See [Contributing](Contributing) for detailed guidelines.

### Can I suggest new privacy features?

**Q**: I have ideas for additional privacy enhancements

**A**: Absolutely! Submit feature requests:
- **GitHub Issues**: Create a feature request
- **Discussions**: Start a discussion thread
- **Pull Requests**: Implement and submit changes

All privacy enhancement suggestions are carefully evaluated.

---

*Don't see your question here? Check the [Troubleshooting](Troubleshooting) page or create an issue on GitHub.*