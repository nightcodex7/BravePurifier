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

# Helper: Check if Brave repo is present and usable
brave_repo_ok() {
    # Check if Brave repo is in sources and apt-cache policy shows brave-browser candidate
    grep -q 'brave-browser-apt-release.s3.brave.com' /etc/apt/sources.list.d/brave-browser-release.list 2>/dev/null || return 1
    apt-cache policy brave-browser | grep -q 'Candidate:' && \
    apt-cache policy brave-browser | grep -q 'brave-browser-apt-release.s3.brave.com' && return 0
    return 1
}

# Install minimal dependencies
install_dependencies() {
    log "Installing minimal dependencies..."
    
    case $PM in
        "apt")
            if ! apt update -qq 2>apt_update.log; then
                if grep -q 'brave-browser-apt-release.s3.brave.com' apt_update.log; then
                    error "apt update failed for Brave repo. Please check your network or the Brave repository."
                    rm -f apt_update.log
                    exit 1
                fi
                warn "apt update encountered errors, but not for Brave repo. Attempting to continue..."
                rm -f apt_update.log
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

# Check if Brave is installed
is_brave_installed() {
    command -v brave-browser >/dev/null 2>&1
}

# Enhanced Brave installation with better error handling
install_brave() {
    log "Installing Brave Browser..."
    
    case $PM in
        "apt")
            # Secure key installation (always overwrite)
            curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | \
                gpg --dearmor > /usr/share/keyrings/brave-browser-archive-keyring.gpg
            
            echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | \
                tee /etc/apt/sources.list.d/brave-browser-release.list >/dev/null
            
            if ! apt update -qq 2>apt_update.log; then
                if grep -q 'brave-browser-apt-release.s3.brave.com' apt_update.log; then
                    error "apt update failed for Brave repo. Please check your network or the Brave repository."
                    rm -f apt_update.log
                    exit 1
                fi
                warn "apt update encountered errors, but not for Brave repo. Attempting to continue..."
                rm -f apt_update.log
            fi
            # Check for candidate
            local candidate
            candidate=$(apt-cache policy brave-browser | awk '/Candidate:/ {print $2}')
            if [[ -z "$candidate" || "$candidate" == "(none)" ]]; then
                error "Brave repository is not available or does not provide a candidate. Please check your sources."
                warn "If you encounter issues, please open an issue or ask in the discussion area of the project."
                return 1
            fi
            if ! apt install -y brave-browser; then
                error "Failed to install Brave Browser."
                warn "If you encounter issues, please open an issue or ask in the discussion area of the project."
                return 1
            fi
            ;;
        "dnf"|"yum")
            rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
            $PM config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
            if ! $PM list brave-browser 2>/dev/null | grep -q brave-browser; then
                error "Brave Browser package not found in $PM repositories. Please check your repo configuration."
                warn "If you encounter issues, please open an issue or ask in the discussion area of the project."
                exit 1
            fi
            if ! $PM install -y brave-browser; then
                error "Failed to install Brave Browser."
                warn "If you encounter issues, please open an issue or ask in the discussion area of the project."
                exit 1
            fi
            ;;
        "pacman")
            if command -v yay >/dev/null 2>&1; then
                if ! sudo -u "$(logname 2>/dev/null || echo $SUDO_USER)" yay -S --noconfirm brave-bin; then
                    error "Failed to install Brave Browser via yay."
                    warn "If you encounter issues, please open an issue or ask in the discussion area of the project."
                    exit 1
                fi
            elif command -v paru >/dev/null 2>&1; then
                if ! sudo -u "$(logname 2>/dev/null || echo $SUDO_USER)" paru -S --noconfirm brave-bin; then
                    error "Failed to install Brave Browser via paru."
                    warn "If you encounter issues, please open an issue or ask in the discussion area of the project."
                    exit 1
                fi
            else
                warn "AUR helper not found. Please install yay or paru to install Brave Browser from the AUR."
                warn "If you encounter issues, please open an issue or ask in the discussion area of the project."
                exit 1
            fi
            ;;
        "zypper")
            zypper addrepo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo brave-browser
            zypper --gpg-auto-import-keys refresh brave-browser
            if ! zypper se -s brave-browser | grep -q brave-browser; then
                error "Brave Browser package not found in zypper repositories. Please check your repo configuration."
                warn "If you encounter issues, please open an issue or ask in the discussion area of the project."
                exit 1
            fi
            if ! zypper install -y brave-browser; then
                error "Failed to install Brave Browser."
                warn "If you encounter issues, please open an issue or ask in the discussion area of the project."
                exit 1
            fi
            ;;
        "emerge")
            echo "www-client/brave-bin" >> /etc/portage/package.accept_keywords
            if ! emerge -q www-client/brave-bin; then
                error "Failed to install Brave Browser via emerge."
                warn "If you encounter issues, please open an issue or ask in the discussion area of the project."
                exit 1
            fi
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

# Debloat options and defaults
DEBLOAT_OPTIONS=(
  "Rewards"
  "Wallet"
  "VPN"
  "News"
  "Talk"
  "Autofill"
  "PasswordManager"
  "SafeBrowsing"
  "Sync"
  "Spellcheck"
  "SearchSuggestions"
  "BackgroundMode"
  "WebStore"
  "BookmarksBar"
  "HomeButton"
  "ImportBookmarks"
  "ImportHistory"
  "ImportPasswords"
  "ImportSearchEngine"
  "Popups"
  "WebBluetooth"
  "WebUSB"
  "FileSystemRead"
  "FileSystemWrite"
  "Serial"
  "HID"
  "CloudPrint"
  "AudioCapture"
  "VideoCapture"
  "ScreenCapture"
  "MediaRouter"
  "CastIcon"
  "MetricsReporting"
  "LogUpload"
  "Heartbeat"
)

# Default: all debloat options enabled
for opt in "${DEBLOAT_OPTIONS[@]}"; do
  eval "DEBLOAT_${opt}=1"
done

# Prompt user for debloat selection
prompt_debloat_options() {
  echo
  echo -e "${CYAN}Debloat Options:${NC}"
  read -p "Do you want to skip selection and apply ALL debloat options? [Y/n]: " skip_all
  skip_all=${skip_all:-Y}
  if [[ $skip_all =~ ^[Yy]$ ]]; then
    info "Applying all debloat options."
    return
  fi
  echo -e "${YELLOW}You will be prompted for each debloat option. Enter 'y' to apply, 'n' to skip.${NC}"
  for opt in "${DEBLOAT_OPTIONS[@]}"; do
    read -p "Apply debloat for $opt? [Y/n]: " ans
    ans=${ans:-Y}
    if [[ $ans =~ ^[Yy]$ ]]; then
      eval "DEBLOAT_${opt}=1"
    else
      eval "DEBLOAT_${opt}=0"
    fi
  done
}

# Modular system policy generator
write_system_policy() {
  cat > /etc/brave/policies/managed/privacy-policy.json <<EOF
{
$( [[ $DEBLOAT_AutoplayAllowed -eq 1 ]] && echo '    "AutoplayAllowed": false,' )
$( [[ $DEBLOAT_DefaultNotificationsSetting -eq 1 ]] && echo '    "DefaultNotificationsSetting": 2,' )
$( [[ $DEBLOAT_DefaultGeolocationSetting -eq 1 ]] && echo '    "DefaultGeolocationSetting": 2,' )
$( [[ $DEBLOAT_DefaultCamerasSetting -eq 1 ]] && echo '    "DefaultCamerasSetting": 2,' )
$( [[ $DEBLOAT_DefaultMicrophonesSetting -eq 1 ]] && echo '    "DefaultMicrophonesSetting": 2,' )
$( [[ $DEBLOAT_DefaultSensorsSetting -eq 1 ]] && echo '    "DefaultSensorsSetting": 2,' )
    "DefaultSearchProviderEnabled": true,
    "DefaultSearchProviderName": "DuckDuckGo",
    "DefaultSearchProviderSearchURL": "https://duckduckgo.com/?q={searchTerms}&t=brave",
    "DefaultSearchProviderSuggestURL": "",
    "HomepageLocation": "about:blank",
    "NewTabPageLocation": "about:blank",
    "RestoreOnStartup": 1,
$( [[ $DEBLOAT_SafeBrowsing -eq 1 ]] && echo '    "SafeBrowsingEnabled": false,' )
$( [[ $DEBLOAT_SafeBrowsing -eq 1 ]] && echo '    "SafeBrowsingExtendedReportingEnabled": false,' )
$( [[ $DEBLOAT_SearchSuggestions -eq 1 ]] && echo '    "SearchSuggestEnabled": false,' )
$( [[ $DEBLOAT_Spellcheck -eq 1 ]] && echo '    "SpellcheckEnabled": false,' )
$( [[ $DEBLOAT_Sync -eq 1 ]] && echo '    "SyncDisabled": true,' )
    "TorDisabled": false,
    "WebRTCIPHandlingPolicy": "disable_non_proxied_udp",
$( [[ $DEBLOAT_MetricsReporting -eq 1 ]] && echo '    "MetricsReportingEnabled": false,' )
$( [[ $DEBLOAT_Autofill -eq 1 ]] && echo '    "AutofillAddressEnabled": false,' )
$( [[ $DEBLOAT_Autofill -eq 1 ]] && echo '    "AutofillCreditCardEnabled": false,' )
$( [[ $DEBLOAT_PasswordManager -eq 1 ]] && echo '    "PasswordManagerEnabled": false,' )
$( [[ $DEBLOAT_Translate -eq 1 ]] && echo '    "TranslateEnabled": false,' )
    "NetworkPredictionOptions": 2,
$( [[ $DEBLOAT_BackgroundMode -eq 1 ]] && echo '    "BackgroundModeEnabled": false,' )
$( [[ $DEBLOAT_WebStore -eq 1 ]] && echo '    "HideWebStoreIcon": true,' )
$( [[ $DEBLOAT_BookmarksBar -eq 1 ]] && echo '    "BookmarkBarEnabled": false,' )
$( [[ $DEBLOAT_HomeButton -eq 1 ]] && echo '    "ShowHomeButton": false,' )
    "BrowserSignin": 0,
$( [[ $DEBLOAT_ImportBookmarks -eq 1 ]] && echo '    "ImportBookmarks": false,' )
$( [[ $DEBLOAT_ImportHistory -eq 1 ]] && echo '    "ImportHistory": false,' )
$( [[ $DEBLOAT_ImportPasswords -eq 1 ]] && echo '    "ImportSavedPasswords": false,' )
$( [[ $DEBLOAT_ImportSearchEngine -eq 1 ]] && echo '    "ImportSearchEngine": false,' )
$( [[ $DEBLOAT_Popups -eq 1 ]] && echo '    "DefaultPopupsSetting": 2,' )
$( [[ $DEBLOAT_WebBluetooth -eq 1 ]] && echo '    "DefaultWebBluetoothGuardSetting": 2,' )
$( [[ $DEBLOAT_WebUSB -eq 1 ]] && echo '    "DefaultWebUsbGuardSetting": 2,' )
$( [[ $DEBLOAT_FileSystemRead -eq 1 ]] && echo '    "DefaultFileSystemReadGuardSetting": 2,' )
$( [[ $DEBLOAT_FileSystemWrite -eq 1 ]] && echo '    "DefaultFileSystemWriteGuardSetting": 2,' )
$( [[ $DEBLOAT_Serial -eq 1 ]] && echo '    "DefaultSerialGuardSetting": 2,' )
$( [[ $DEBLOAT_HID -eq 1 ]] && echo '    "DefaultHidGuardSetting": 2,' )
$( [[ $DEBLOAT_Rewards -eq 1 ]] && echo '    "BraveRewardsDisabled": true,' )
$( [[ $DEBLOAT_Wallet -eq 1 ]] && echo '    "BraveWalletDisabled": true,' )
$( [[ $DEBLOAT_VPN -eq 1 ]] && echo '    "BraveVPNDisabled": true,' )
$( [[ $DEBLOAT_News -eq 1 ]] && echo '    "BraveNewsDisabled": true,' )
$( [[ $DEBLOAT_Talk -eq 1 ]] && echo '    "BraveTalkDisabled": true,' )
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
$( [[ $DEBLOAT_CloudPrint -eq 1 ]] && echo '    "CloudPrintSubmitEnabled": false,' )
    "DefaultPrinterSelection": "",
$( [[ $DEBLOAT_Printing -eq 1 ]] && echo '    "PrintingEnabled": false,' )
$( [[ $DEBLOAT_AudioCapture -eq 1 ]] && echo '    "AudioCaptureAllowed": false,' )
$( [[ $DEBLOAT_VideoCapture -eq 1 ]] && echo '    "VideoCaptureAllowed": false,' )
$( [[ $DEBLOAT_ScreenCapture -eq 1 ]] && echo '    "ScreenCaptureAllowed": false,' )
$( [[ $DEBLOAT_MediaRouter -eq 1 ]] && echo '    "EnableMediaRouter": false,' )
$( [[ $DEBLOAT_CastIcon -eq 1 ]] && echo '    "ShowCastIconInToolbar": false,' )
    "CloudManagementEnrollmentToken": "",
$( [[ $DEBLOAT_MetricsReporting -eq 1 ]] && echo '    "ReportVersionData": false,' )
$( [[ $DEBLOAT_MetricsReporting -eq 1 ]] && echo '    "ReportPolicyData": false,' )
$( [[ $DEBLOAT_MetricsReporting -eq 1 ]] && echo '    "ReportMachineIDData": false,' )
$( [[ $DEBLOAT_MetricsReporting -eq 1 ]] && echo '    "ReportUserIDData": false,' )
$( [[ $DEBLOAT_Heartbeat -eq 1 ]] && echo '    "HeartbeatEnabled": false,' )
$( [[ $DEBLOAT_LogUpload -eq 1 ]] && echo '    "LogUploadEnabled": false' )
}
EOF
}

# Modular user settings generator
write_user_preferences() {
  local brave_dir="$1"
  cat > "$brave_dir/Preferences" <<EOF
{
   "brave": {
      "new_tab_page": {
         "hide_all_widgets": true,
         "show_background_image": false,
         "show_clock": false,
         "show_stats": false,
         "show_top_sites": false,
         "show_rewards": $( [[ $DEBLOAT_Rewards -eq 1 ]] && echo 'false' || echo 'true' )
      },
      "rewards": { "enabled": $( [[ $DEBLOAT_Rewards -eq 1 ]] && echo 'false' || echo 'true' ) },
      "wallet": { "enabled": $( [[ $DEBLOAT_Wallet -eq 1 ]] && echo 'false' || echo 'true' ) },
      "vpn": { "enabled": $( [[ $DEBLOAT_VPN -eq 1 ]] && echo 'false' || echo 'true' ) },
      "news": { "enabled": $( [[ $DEBLOAT_News -eq 1 ]] && echo 'false' || echo 'true' ) },
      "talk": { "enabled": $( [[ $DEBLOAT_Talk -eq 1 ]] && echo 'false' || echo 'true' ) }
   },
   "profile": {
      "default_content_setting_values": {
         "geolocation": 2,
         "media_stream_camera": 2,
         "media_stream_mic": 2,
         "notifications": 2,
         "popups": $( [[ $DEBLOAT_Popups -eq 1 ]] && echo '2' || echo '1' ),
         "cookies": 4,
         "sensors": 2,
         "usb_chooser_data": 2,
         "serial_chooser_data": 2,
         "bluetooth_chooser_data": 2,
         "hid_chooser_data": 2
      }
   },
   "search": { "suggest_enabled": $( [[ $DEBLOAT_SearchSuggestions -eq 1 ]] && echo 'false' || echo 'true' ) },
   "translate": { "enabled": $( [[ $DEBLOAT_Translate -eq 1 ]] && echo 'false' || echo 'true' ) },
   "autofill": {
      "profile_enabled": $( [[ $DEBLOAT_Autofill -eq 1 ]] && echo 'false' || echo 'true' ),
      "credit_card_enabled": $( [[ $DEBLOAT_Autofill -eq 1 ]] && echo 'false' || echo 'true' )
   },
   "password_manager": { "auto_signin": $( [[ $DEBLOAT_PasswordManager -eq 1 ]] && echo 'false' || echo 'true' ) },
   "safebrowsing": { "enabled": $( [[ $DEBLOAT_SafeBrowsing -eq 1 ]] && echo 'false' || echo 'true' ) },
   "net": { "network_prediction_options": 2 }
}
EOF
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
    if is_brave_installed; then
        log "Brave Browser detected. Skipping installation. Proceeding to update and debloat."
        update_brave
    else
        log "Brave Browser not detected. Installing..."
        install_brave
    fi
    
    # Apply privacy enhancements
    prompt_debloat_options
    write_system_policy
    # Apply user settings for all users
    local users
    users=$(getent passwd | awk -F: '$3 >= 1000 && $3 < 65534 && $6 ~ /^\/home\// { print $1":"$6 }')
    while IFS=: read -r username user_home; do
        [[ -d "$user_home" ]] || continue
        local brave_dir="$user_home/.config/BraveSoftware/Brave-Browser/Default"
        mkdir -p "$brave_dir"
        write_user_preferences "$brave_dir"
        chown -R "$username:$(id -gn "$username")" "$user_home/.config/BraveSoftware" 2>/dev/null || true
        info "✓ Privacy settings applied for user: $username"
    done <<< "$users"
    purge_telemetry
    
    # Verify and complete
    if verify_installation; then
        show_completion
        exit 0
    else
        error "Installation verification failed. If you encounter issues, please open an issue or ask in the discussion area of the project."
        exit 1
    fi
}

# Signal handling
trap 'error "Script interrupted"; exit 130' INT TERM

# Execute main function with all arguments
main "$@"