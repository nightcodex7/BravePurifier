#!/bin/bash

# Brave Browser Installer, Updater and Debloater Script
# This script automatically installs/updates Brave browser and applies custom debloating settings
# Version: 1.0
# Author: GitHub Community
# License: MIT

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check for root privileges
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        error "Please run as root (use sudo)"
        exit 1
    fi
}

# Function to detect package manager
detect_package_manager() {
    log "Detecting package manager..."
    
    if command -v apt &>/dev/null; then
        PM="apt"
        log "Detected: APT (Debian/Ubuntu)"
    elif command -v dnf &>/dev/null; then
        PM="dnf"
        log "Detected: DNF (Fedora/RHEL)"
    elif command -v pacman &>/dev/null; then
        PM="pacman"
        log "Detected: Pacman (Arch Linux)"
    elif command -v zypper &>/dev/null; then
        PM="zypper"
        log "Detected: Zypper (openSUSE)"
    else
        error "Unsupported package manager. This script supports APT, DNF, Pacman, and Zypper."
        exit 1
    fi
}

# Install dependencies
install_dependencies() {
    log "Installing dependencies..."
    
    case $PM in
        "apt")
            apt update
            apt install -y curl gnupg software-properties-common
            ;;
        "dnf")
            dnf install -y curl gnupg2
            ;;
        "pacman")
            pacman -Sy --noconfirm curl gnupg
            ;;
        "zypper")
            zypper refresh
            zypper install -y curl gpg2
            ;;
    esac
}

# Install Brave Browser based on package manager
install_brave() {
    log "Installing Brave Browser..."
    
    case $PM in
        "apt")
            # Add Brave repository
            curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list
            apt update
            apt install -y brave-browser
            ;;
        "dnf")
            # Add Brave repository
            dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
            rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
            dnf install -y brave-browser
            ;;
        "pacman")
            # Install from AUR (requires yay or manual installation)
            if command -v yay &>/dev/null; then
                sudo -u $(logname) yay -S --noconfirm brave-bin
            else
                warn "AUR helper not found. Installing from official repository..."
                pacman -S --noconfirm brave-browser
            fi
            ;;
        "zypper")
            # Add Brave repository for openSUSE
            zypper addrepo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
            zypper --gpg-auto-import-keys refresh
            zypper install -y brave-browser
            ;;
    esac
}

# Update Brave if already installed
update_brave() {
    log "Updating Brave Browser..."
    
    case $PM in
        "apt")
            apt update && apt upgrade -y brave-browser
            ;;
        "dnf")
            dnf upgrade -y brave-browser
            ;;
        "pacman")
            pacman -Syu --noconfirm brave-browser
            ;;
        "zypper")
            zypper update brave-browser
            ;;
    esac
}

# Create user-specific Brave configuration
create_user_config() {
    local username=$1
    local user_home="/home/$username"
    
    if [ "$username" = "root" ]; then
        user_home="/root"
    fi
    
    local brave_config_dir="$user_home/.config/BraveSoftware/Brave-Browser"
    
    # Create config directory if it doesn't exist
    mkdir -p "$brave_config_dir"
    
    # Set proper ownership
    if [ "$username" != "root" ]; then
        chown -R "$username:$username" "$brave_config_dir"
    fi
}

# Debloat Brave settings using system policies
debloat_brave_system() {
    log "Applying system-wide debloating policies..."
    
    # Create Brave policies directory
    mkdir -p /etc/brave/policies/managed/
    
    # Create comprehensive policy file with debloating settings
    cat > /etc/brave/policies/managed/policy.json << 'EOF'
{
    "AutoplayAllowed": false,
    "DefaultNotificationsSetting": 2,
    "DefaultGeolocationSetting": 2,
    "DefaultCamerasSetting": 2,
    "DefaultMicrophonesSetting": 2,
    "DefaultSearchProviderEnabled": true,
    "DefaultSearchProviderName": "DuckDuckGo",
    "DefaultSearchProviderSearchURL": "https://duckduckgo.com/?q={searchTerms}",
    "DefaultSearchProviderSuggestURL": "",
    "HomepageLocation": "about:blank",
    "NewTabPageLocation": "about:blank",
    "RestoreOnStartup": 1,
    "SafeBrowsingEnabled": false,
    "SafeBrowsingExtendedReportingEnabled": false,
    "SearchSuggestEnabled": false,
    "SpellcheckEnabled": true,
    "SyncDisabled": true,
    "TorDisabled": false,
    "WebRTCIPHandlingPolicy": "disable_non_proxied_udp",
    "MetricsReportingEnabled": false,
    "AutofillAddressEnabled": false,
    "AutofillCreditCardEnabled": false,
    "PasswordManagerEnabled": false,
    "TranslateEnabled": false,
    "NetworkPredictionOptions": 2,
    "BackgroundModeEnabled": false,
    "HideWebStoreIcon": true,
    "BookmarkBarEnabled": false,
    "ShowHomeButton": false,
    "BrowserSignin": 0,
    "ImportBookmarks": false,
    "ImportHistory": false,
    "ImportSavedPasswords": false,
    "ImportSearchEngine": false,
    "DefaultPopupsSetting": 2,
    "DefaultWebBluetoothGuardSetting": 2,
    "DefaultWebUsbGuardSetting": 2,
    "DefaultFileSystemReadGuardSetting": 2,
    "DefaultFileSystemWriteGuardSetting": 2,
    "DefaultSensorsSetting": 2,
    "DefaultSerialGuardSetting": 2,
    "BraveRewardsDisabled": true,
    "BraveWalletDisabled": true,
    "BraveVPNDisabled": true,
    "BraveNewsDisabled": true,
    "BraveTalkDisabled": true,
    "BraveSearchDisabled": false,
    "BraveShieldsEnabled": true,
    "BraveShieldsEnabledForUrls": ["*"],
    "BraveAdBlockEnabled": true,
    "BraveFingerprintingBlockEnabled": true,
    "BraveHTTPSUpgradeEnabled": true
}
EOF
    
    log "System-wide policies applied successfully"
}

# Create user preferences for additional debloating
create_user_preferences() {
    log "Creating user-specific debloating preferences..."
    
    # Get all regular users (UID >= 1000)
    local users=$(getent passwd | awk -F: '$3 >= 1000 && $3 < 65534 { print $1 }')
    
    for username in $users; do
        local user_home=$(getent passwd "$username" | cut -d: -f6)
        local brave_dir="$user_home/.config/BraveSoftware/Brave-Browser/Default"
        
        # Create directory if it doesn't exist
        mkdir -p "$brave_dir"
        
        # Create Preferences file with additional privacy settings
        cat > "$brave_dir/Preferences" << 'EOF'
{
   "brave": {
      "new_tab_page": {
         "hide_all_widgets": true,
         "show_background_image": false,
         "show_clock": false,
         "show_stats": false,
         "show_top_sites": false
      },
      "rewards": {
         "enabled": false
      },
      "wallet": {
         "enabled": false
      }
   },
   "profile": {
      "default_content_setting_values": {
         "geolocation": 2,
         "media_stream_camera": 2,
         "media_stream_mic": 2,
         "notifications": 2,
         "popups": 2
      },
      "default_content_settings": {
         "geolocation": 2,
         "media_stream_camera": 2,
         "media_stream_mic": 2,
         "notifications": 2,
         "popups": 2
      }
   },
   "search": {
      "suggest_enabled": false
   }
}
EOF
        
        # Set proper ownership
        chown -R "$username:$username" "$user_home/.config/BraveSoftware" 2>/dev/null || true
        
        log "Preferences created for user: $username"
    done
}

# Verify installation
verify_installation() {
    log "Verifying Brave Browser installation..."
    
    if command -v brave-browser &>/dev/null; then
        local version=$(brave-browser --version 2>/dev/null | head -n1)
        log "✓ Brave Browser installed successfully: $version"
        return 0
    else
        error "✗ Brave Browser installation failed"
        return 1
    fi
}

# Display completion message
show_completion_message() {
    echo
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    INSTALLATION COMPLETE                     ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
    log "Brave Browser has been successfully installed and debloated!"
    echo
    echo -e "${BLUE}Applied optimizations:${NC}"
    echo "  • Disabled telemetry and data collection"
    echo "  • Blocked ads and trackers by default"
    echo "  • Disabled unnecessary features (Rewards, Wallet, VPN)"
    echo "  • Enhanced privacy settings"
    echo "  • Set DuckDuckGo as default search engine"
    echo "  • Disabled autoplay and notifications"
    echo "  • Enabled HTTPS upgrades"
    echo
    echo -e "${YELLOW}Note:${NC} Some settings may require restarting Brave Browser to take effect."
    echo -e "${YELLOW}Note:${NC} Users can still modify these settings through Brave's preferences if needed."
    echo
}

# Main execution function
main() {
    echo -e "${BLUE}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║        BRAVE BROWSER INSTALLER & DEBLOATER SCRIPT           ║
║                                                              ║
║  This script will install/update Brave Browser and apply    ║
║  privacy-focused debloating settings automatically.         ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    # Check prerequisites
    check_root
    detect_package_manager
    install_dependencies
    
    # Install or update Brave
    if command -v brave-browser &>/dev/null; then
        log "Brave Browser is already installed. Checking for updates..."
        update_brave
    else
        log "Brave Browser not found. Installing..."
        install_brave
    fi
    
    # Apply debloating settings
    debloat_brave_system
    create_user_preferences
    
    # Verify and complete
    if verify_installation; then
        show_completion_message
    else
        error "Installation verification failed. Please check the logs above."
        exit 1
    fi
}

# Handle script interruption
trap 'error "Script interrupted by user"; exit 130' INT

# Run main function
main "$@"