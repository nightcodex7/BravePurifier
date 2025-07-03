#!/bin/bash

# Brave Browser Purifier Script
# Ultra-lightweight privacy-focused installer and debloater
# Version: 1.0
# Author: nightcodex7
# Repository: https://github.com/nightcodex7/BravePurifier
# License: MIT

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors for clean output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

# Script metadata
readonly SCRIPT_VERSION="1.0"
readonly SCRIPT_NAME="Brave Purifier"

# Logging functions
log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
info() { echo -e "${CYAN}[PURIFIER]${NC} $1"; }

# Check root privileges
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "Root privileges required. Please run with sudo:"
        echo -e "${CYAN}sudo $0${NC}"
        exit 1
    fi
}

# Detect package manager with enhanced support
detect_package_manager() {
    log "Detecting system package manager..."
    
    # Detect Linux Mint
    if [ -f /etc/linuxmint/info ]; then
        IS_MINT=1
        MINT_VERSION=$(grep 'RELEASE=' /etc/linuxmint/info | cut -d'=' -f2 | tr -d '"')
        warn "Linux Mint detected (version $MINT_VERSION). Mint sometimes has issues with third-party repositories. If you encounter 'does not have a Release file' errors, check your sources in /etc/apt/sources.list.d/."
    else
        IS_MINT=0
    fi

    if command -v apt >/dev/null 2>&1; then
        PM="apt" && log "\u2713 APT detected (Debian/Ubuntu/Mint)"
    elif command -v dnf >/dev/null 2>&1; then
        PM="dnf" && log "\u2713 DNF detected (Fedora/RHEL)"
    elif command -v yum >/dev/null 2>&1; then
        PM="yum" && log "\u2713 YUM detected (CentOS/RHEL)"
    elif command -v pacman >/dev/null 2>&1; then
        PM="pacman" && log "\u2713 Pacman detected (Arch Linux)"
    elif command -v zypper >/dev/null 2>&1; then
        PM="zypper" && log "\u2713 Zypper detected (openSUSE)"
    elif command -v emerge >/dev/null 2>&1; then
        PM="emerge" && log "\u2713 Portage detected (Gentoo)"
    else
        error "Unsupported package manager. Supported: APT, DNF, YUM, Pacman, Zypper, Portage"
        exit 1
    fi
}

# Install minimal dependencies
install_dependencies() {
    log "Installing minimal dependencies..."
    
    case $PM in
        "apt")
            if ! apt update -qq; then
                error "apt update failed. This may be due to a broken or third-party repository (e.g., Cloudflare WARP). Please check /etc/apt/sources.list.d/ and remove or fix any problematic sources."
                warn "For the error: 'does not have a Release file', see the Troubleshooting section in the README."
                exit 1
            fi
            apt install -y curl gnupg >/dev/null 2>&1
            ;;
        "dnf"|"yum")
            $PM install -y curl gnupg2 >/dev/null 2>&1
            ;;
        "pacman")
            pacman -Sy --noconfirm curl gnupg >/dev/null 2>&1
            ;;
        "zypper")
            zypper refresh -q && zypper install -y curl gpg2 >/dev/null 2>&1
            ;;
        "emerge")
            emerge --sync -q && emerge -q app-crypt/gnupg net-misc/curl
            ;;
    esac
}

# Enhanced Brave installation with better error handling
install_brave() {
    log "Installing Brave Browser..."
    
    case $PM in
        "apt")
            # Secure key installation
            curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | \
                gpg --dearmor -o /usr/share/keyrings/brave-browser-archive-keyring.gpg
            
            echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | \
                tee /etc/apt/sources.list.d/brave-browser-release.list >/dev/null
            
            if ! apt update -qq; then
                error "apt update failed after adding Brave repo. This may be due to a broken or third-party repository (e.g., Cloudflare WARP). Please check /etc/apt/sources.list.d/ and remove or fix any problematic sources."
                warn "For the error: 'does not have a Release file', see the Troubleshooting section in the README."
                exit 1
            fi
            if ! apt install -y brave-browser; then
                error "Failed to install Brave Browser. This may be due to broken sources or network issues."
                exit 1
            fi
            ;;
        "dnf"|"yum")
            rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
            $PM config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
            $PM install -y brave-browser
            ;;
        "pacman")
            # Use AUR if available, fallback to manual
            if command -v yay >/dev/null 2>&1; then
                sudo -u "$(logname 2>/dev/null || echo $SUDO_USER)" yay -S --noconfirm brave-bin
            elif command -v paru >/dev/null 2>&1; then
                sudo -u "$(logname 2>/dev/null || echo $SUDO_USER)" paru -S --noconfirm brave-bin
            else
                warn "AUR helper not found. Installing from official repositories..."
                pacman -S --noconfirm brave-browser 2>/dev/null || {
                    error "Brave not available in official repos. Please install an AUR helper (yay/paru) first."
                    exit 1
                }
            fi
            ;;
        "zypper")
            zypper addrepo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo brave-browser
            zypper --gpg-auto-import-keys refresh brave-browser
            zypper install -y brave-browser
            ;;
        "emerge")
            echo "www-client/brave-bin" >> /etc/portage/package.accept_keywords
            emerge -q www-client/brave-bin
            ;;
    esac
}

# Update existing Brave installation
update_brave() {
    log "Updating Brave Browser..."
    
    case $PM in
        "apt")
            apt update -qq && apt upgrade -y brave-browser
            ;;
        "dnf"|"yum")
            $PM upgrade -y brave-browser
            ;;
        "pacman")
            pacman -Syu --noconfirm brave-browser brave-bin 2>/dev/null || true
            ;;
        "zypper")
            zypper update -y brave-browser
            ;;
        "emerge")
            emerge -uq www-client/brave-bin
            ;;
    esac
}

# Ultra-hardened privacy policies
apply_system_policies() {
    info "Applying ultra-hardened privacy policies..."
    
    mkdir -p /etc/brave/policies/managed/
    
    cat > /etc/brave/policies/managed/privacy-policy.json << 'EOF'
{
    "AutoplayAllowed": false,
    "DefaultNotificationsSetting": 2,
    "DefaultGeolocationSetting": 2,
    "DefaultCamerasSetting": 2,
    "DefaultMicrophonesSetting": 2,
    "DefaultSensorsSetting": 2,
    "DefaultSearchProviderEnabled": true,
    "DefaultSearchProviderName": "DuckDuckGo",
    "DefaultSearchProviderSearchURL": "https://duckduckgo.com/?q={searchTerms}&t=brave",
    "DefaultSearchProviderSuggestURL": "",
    "HomepageLocation": "about:blank",
    "NewTabPageLocation": "about:blank",
    "RestoreOnStartup": 1,
    "SafeBrowsingEnabled": false,
    "SafeBrowsingExtendedReportingEnabled": false,
    "SearchSuggestEnabled": false,
    "SpellcheckEnabled": false,
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
    "DefaultSerialGuardSetting": 2,
    "DefaultHidGuardSetting": 2,
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
    "BraveHTTPSUpgradeEnabled": true,
    "BraveCookieBlockEnabled": true,
    "DefaultCookiesSetting": 4,
    "DefaultJavaScriptSetting": 1,
    "DefaultImagesSetting": 1,
    "DefaultPluginsSetting": 2,
    "DeveloperToolsAvailability": 2,
    "ExtensionInstallBlocklist": ["*"],
    "ExtensionInstallAllowlist": [],
    "CloudPrintSubmitEnabled": false,
    "DefaultPrinterSelection": "",
    "PrintingEnabled": false,
    "AudioCaptureAllowed": false,
    "VideoCaptureAllowed": false,
    "ScreenCaptureAllowed": false,
    "RemoteAccessHostFirewallTraversal": false,
    "EnableMediaRouter": false,
    "ShowCastIconInToolbar": false,
    "CloudManagementEnrollmentToken": "",
    "ReportVersionData": false,
    "ReportPolicyData": false,
    "ReportMachineIDData": false,
    "ReportUserIDData": false,
    "HeartbeatEnabled": false,
    "LogUploadEnabled": false
}
EOF
    
    info "✓ Ultra-hardened system policies applied"
}

# Enhanced user-specific privacy settings
apply_user_settings() {
    info "Applying user-specific privacy settings..."
    
    # Get all users with home directories
    local users
    users=$(getent passwd | awk -F: '$3 >= 1000 && $3 < 65534 && $6 ~ /^\/home\// { print $1":"$6 }')
    
    while IFS=: read -r username user_home; do
        [[ -d "$user_home" ]] || continue
        
        local brave_dir="$user_home/.config/BraveSoftware/Brave-Browser/Default"
        mkdir -p "$brave_dir"
        
        # Ultra-minimal preferences
        cat > "$brave_dir/Preferences" << 'EOF'
{
   "brave": {
      "new_tab_page": {
         "hide_all_widgets": true,
         "show_background_image": false,
         "show_clock": false,
         "show_stats": false,
         "show_top_sites": false,
         "show_rewards": false
      },
      "rewards": { "enabled": false },
      "wallet": { "enabled": false },
      "vpn": { "enabled": false },
      "news": { "enabled": false },
      "talk": { "enabled": false }
   },
   "profile": {
      "default_content_setting_values": {
         "geolocation": 2,
         "media_stream_camera": 2,
         "media_stream_mic": 2,
         "notifications": 2,
         "popups": 2,
         "cookies": 4,
         "sensors": 2,
         "usb_chooser_data": 2,
         "serial_chooser_data": 2,
         "bluetooth_chooser_data": 2,
         "hid_chooser_data": 2
      }
   },
   "search": { "suggest_enabled": false },
   "translate": { "enabled": false },
   "autofill": {
      "profile_enabled": false,
      "credit_card_enabled": false
   },
   "password_manager": { "auto_signin": false },
   "safebrowsing": { "enabled": false },
   "net": { "network_prediction_options": 2 }
}
EOF
        
        # Set ownership
        chown -R "$username:$(id -gn "$username")" "$user_home/.config/BraveSoftware" 2>/dev/null || true
        
        info "✓ Privacy settings applied for user: $username"
    done <<< "$users"
}

# Remove telemetry and tracking files
purge_telemetry() {
    info "Purging telemetry and tracking components..."
    
    # System-wide telemetry removal
    local telemetry_paths=(
        "/opt/brave.com/brave/brave_crashpad_handler"
        "/opt/brave.com/brave/crash_reporter"
        "/etc/brave/policies/managed/telemetry*"
    )
    
    for path in "${telemetry_paths[@]}"; do
        [[ -e "$path" ]] && rm -rf "$path" && info "✓ Removed: $path"
    done
    
    # User-specific telemetry cleanup
    find /home -name ".config/BraveSoftware/Brave-Browser/*/Crash Reports" -type d -exec rm -rf {} + 2>/dev/null || true
    find /home -name ".config/BraveSoftware/Brave-Browser/*/Crashpad" -type d -exec rm -rf {} + 2>/dev/null || true
    
    info "✓ Telemetry components purged"
}

# Verify installation and settings
verify_installation() {
    log "Verifying Brave Browser installation and privacy settings..."
    
    if ! command -v brave-browser >/dev/null 2>&1; then
        error "✗ Brave Browser installation failed"
        return 1
    fi
    
    local version
    version=$(brave-browser --version 2>/dev/null | head -n1)
    log "✓ Brave Browser installed: $version"
    
    # Verify policy file
    if [[ -f "/etc/brave/policies/managed/privacy-policy.json" ]]; then
        log "✓ Privacy policies applied successfully"
    else
        warn "⚠ Privacy policies may not be applied correctly"
    fi
    
    return 0
}

# Display completion summary
show_completion() {
    echo
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                  BRAVE PURIFIER COMPLETE                     ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo
    info "Brave Browser has been successfully purified for maximum privacy!"
    echo
    echo -e "${BLUE}Privacy Enhancements Applied:${NC}"
    echo "  🔒 All telemetry and tracking disabled"
    echo "  🚫 Ads, trackers, and fingerprinting blocked"
    echo "  🔍 DuckDuckGo set as default search engine"
    echo "  🌐 WebRTC IP leak protection enabled"
    echo "  📵 All unnecessary features disabled (Rewards, Wallet, VPN, etc.)"
    echo "  🛡️ Enhanced content blocking and privacy settings"
    echo "  🔐 Hardened security policies applied system-wide"
    echo
    echo -e "${YELLOW}Note:${NC} Restart Brave Browser to ensure all settings take effect."
    echo -e "${GREEN}Your privacy is now maximally protected!${NC}"
    echo
}

# Show help information
show_help() {
    echo -e "${BLUE}$SCRIPT_NAME v$SCRIPT_VERSION${NC}"
    echo "Ultra-lightweight privacy-focused Brave Browser installer and debloater"
    echo
    echo -e "${CYAN}Usage:${NC}"
    echo "  sudo $0 [OPTIONS]"
    echo
    echo -e "${CYAN}Options:${NC}"
    echo "  -h, --help     Show this help message"
    echo "  -v, --version  Show version information"
    echo
    echo -e "${CYAN}Examples:${NC}"
    echo "  sudo $0                    # Install/update and purify Brave"
    echo "  sudo $0 --help             # Show help"
    echo
    echo -e "${CYAN}Repository:${NC} https://github.com/nightcodex7/brave-purifier"
}

# Show version information
show_version() {
    echo -e "${BLUE}$SCRIPT_NAME${NC} version ${GREEN}$SCRIPT_VERSION${NC}"
    echo "Author: nightcodex7"
    echo "Repository: https://github.com/nightcodex7/brave-purifier"
    echo "License: MIT"
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                show_version
                exit 0
                ;;
            *)
                error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
        shift
    done
}

# Main execution with enhanced error handling
main() {
    # Parse command line arguments
    parse_arguments "$@"
    
    echo -e "${BLUE}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                    BRAVE PURIFIER v1.0                      ║
║          Ultra-Lightweight Privacy-Focused Installer        ║
║                    by nightcodex7                           ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    # Prerequisites
    check_root
    detect_package_manager
    install_dependencies
    
    # Install or update Brave
    if command -v brave-browser >/dev/null 2>&1; then
        log "Brave Browser detected. Updating..."
        update_brave
    else
        log "Installing Brave Browser..."
        install_brave
    fi
    
    # Apply privacy enhancements
    apply_system_policies
    apply_user_settings
    purge_telemetry
    
    # Verify and complete
    if verify_installation; then
        show_completion
        exit 0
    else
        error "Installation verification failed"
        exit 1
    fi
}

# Signal handling
trap 'error "Script interrupted"; exit 130' INT TERM

# Execute main function with all arguments
main "$@"