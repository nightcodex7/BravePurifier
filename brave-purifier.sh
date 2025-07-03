#!/bin/bash

# --- SUDO/ROOT HANDLING (must be first) ---
if [[ $EUID -ne 0 ]]; then
  if command -v sudo >/dev/null 2>&1; then
    echo "[SUDO] Root privileges required. Re-running with sudo..."
    if ! sudo -n true 2>/dev/null; then
      echo "[ERROR] Sudo requires authentication. Please run as root or ensure sudo access."
      exit 1
    fi
    exec sudo "$0" "$@"
    exit 1
  else
    echo "[ERROR] Root privileges required, and sudo is not available. Please run as root."
    exit 1
  fi
fi

# --- INTERACTIVITY HANDLING ---
# This script is fully interactive and works with 'curl ... | sudo bash' as long as a TTY is available.
# All prompts use /dev/tty if available, so user input is always required.

# Brave Browser Purifier Script
# Ultra-lightweight privacy-focused installer and debloater
# Version: 1.2
# Author: nightcodex7
# Repository: https://github.com/nightcodex7/BravePurifier
# License: MIT

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Minimal color support (works on all distros, but not required)
RED=''; GREEN=''; YELLOW=''; BLUE=''; CYAN=''; NC=''
if [ -t 1 ] && command -v tput >/dev/null 2>&1; then
  RED=$(tput setaf 1); GREEN=$(tput setaf 2); YELLOW=$(tput setaf 3); BLUE=$(tput setaf 4); CYAN=$(tput setaf 6); NC=$(tput sgr0)
fi

# Script metadata
readonly SCRIPT_VERSION="1.2"
readonly SCRIPT_NAME="Brave Purifier"

# Initialize all DEBLOAT_* variables to 0 to prevent unbound variable errors
declare -A DEBLOAT=(
  [AutoplayAllowed]=0
  [DefaultNotificationsSetting]=0
  [DefaultGeolocationSetting]=0
  [DefaultCamerasSetting]=0
  [DefaultMicrophonesSetting]=0
  [DefaultSensorsSetting]=0
  [Translate]=0
  [BookmarksBar]=0
  [ImportHistory]=0
  [CloudPrint]=0
  [Printing]=0
  [MediaRouter]=0
  [CastIcon]=0
  [Rewards]=0
  [Wallet]=0
  [VPN]=0
  [News]=0
  [Talk]=0
  [SafeBrowsing]=0
  [MetricsReporting]=0
  [Autofill]=0
  [PasswordManager]=0
  [SearchSuggestions]=0
  [Spellcheck]=0
  [Sync]=0
  [BackgroundMode]=0
  [WebStore]=0
  [HomeButton]=0
  [Popups]=0
  [WebBluetooth]=0
  [WebUSB]=0
  [FileSystemRead]=0
  [FileSystemWrite]=0
  [Serial]=0
  [HID]=0
  [AudioCapture]=0
  [VideoCapture]=0
  [ScreenCapture]=0
  [Heartbeat]=0
  [LogUpload]=0
  [HomeScreen]=1
)

# Logging functions
log() { echo -e "${BLUE}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
info() { echo -e "${CYAN}[PURIFIER]${NC} $1"; }

# Safe prompt function to avoid abrupt exit on read errors or non-interactive shells
safe_read() {
  local __resultvar=$1
  local prompt="$2"
  local default="$3"
  local input
  if [ -e /dev/tty ]; then
    read -p "$prompt" input < /dev/tty || input=""
  else
    echo "[ERROR] No interactive terminal detected. Cannot prompt for user input. Exiting."
    exit 1
  fi
  if [ -z "$input" ]; then
    input="$default"
  fi
  eval "$__resultvar=\"$input\""
}

# Detect package manager
detect_package_manager() {
  log "Detecting system package manager..."
  IS_MINT=0
  if [[ -f /etc/linuxmint/info ]]; then
    IS_MINT=1
    MINT_VERSION=$(grep 'RELEASE=' /etc/linuxmint/info | cut -d'=' -f2 | tr -d '"')
    warn "Linux Mint detected (version $MINT_VERSION). Mint may have issues with third-party repositories."
  fi

  PM=""
  for pm in apt dnf yum pacman zypper emerge; do
    if command -v "$pm" >/dev/null 2>&1; then
      PM="$pm"
      log "✓ $pm detected"
      break
    fi
  done

  if [[ -z "$PM" ]]; then
    error "No supported package manager found. Supported: apt, dnf, yum, pacman, zypper, emerge"
    exit 1
  fi
}

# Check if Brave repo is present
brave_repo_ok() {
  case $PM in
    apt)
      [[ -f /etc/apt/sources.list.d/brave-browser-release.list ]] && \
      apt-cache policy brave-browser | grep -q 'Candidate:' && return 0
      ;;
    dnf|yum)
      $PM repolist | grep -q brave-browser && return 0
      ;;
    zypper)
      zypper lr | grep -q brave-browser && return 0
      ;;
    *)
      return 0  # Assume okay for pacman/emerge
      ;;
  esac
  return 1
}

# Track unrelated apt errors
UNRELATED_APT_ERROR=0

# Install minimal dependencies
install_dependencies() {
  log "Installing minimal dependencies..."
  case $PM in
    apt)
      if ! apt update -qq 2>apt_update.log; then
        if grep -q 'brave-browser-apt-release.s3.brave.com' apt_update.log 2>/dev/null; then
          error "apt update failed for Brave repo. Check network or repository."
          rm -f apt_update.log
          exit 1
        fi
        UNRELATED_APT_ERROR=1
        warn "apt update encountered unrelated errors. Continuing..."
        rm -f apt_update.log
      fi
      apt install -y curl gnupg >/dev/null 2>&1 || { error "Failed to install dependencies"; exit 1; }
      ;;
    dnf|yum)
      $PM install -y curl gnupg2 >/dev/null 2>&1 || { error "Failed to install dependencies"; exit 1; }
      ;;
    pacman)
      pacman -Sy --noconfirm curl gnupg >/dev/null 2>&1 || { error "Failed to install dependencies"; exit 1; }
      ;;
    zypper)
      zypper refresh -q && zypper install -y curl gpg2 >/dev/null 2>&1 || { error "Failed to install dependencies"; exit 1; }
      ;;
    emerge)
      emerge --sync -q && emerge -q app-crypt/gnupg net-misc/curl || { error "Failed to install dependencies"; exit 1; }
      ;;
  esac
}

# Check if Brave is installed
is_brave_installed() {
  command -v brave-browser >/dev/null 2>&1
}

# Install Brave with retry logic
install_brave() {
  log "Installing Brave Browser..."
  local retries=3
  case $PM in
    apt)
      curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg | \
        gpg --dearmor > /usr/share/keyrings/brave-browser-archive-keyring.gpg 2>/dev/null || \
        { error "Failed to install Brave GPG key"; exit 1; }
      echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | \
        tee /etc/apt/sources.list.d/brave-browser-release.list >/dev/null
      for ((i=1; i<=retries; i++)); do
        if apt update -qq 2>apt_update.log; then
          break
        elif grep -q 'brave-browser-apt-release.s3.brave.com' apt_update.log 2>/dev/null; then
          error "apt update failed for Brave repo (attempt $i/$retries)."
          [[ $i -eq $retries ]] && { rm -f apt_update.log; exit 1; }
          sleep 5
        else
          UNRELATED_APT_ERROR=1
          warn "apt update encountered unrelated errors. Continuing..."
          rm -f apt_update.log
          break
        fi
      done
      apt install -y brave-browser >/dev/null 2>&1 || { error "Failed to install Brave Browser"; exit 1; }
      ;;
    dnf|yum)
      rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc 2>/dev/null || \
        { error "Failed to import Brave RPM key"; exit 1; }
      $PM config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
      $PM install -y brave-browser >/dev/null 2>&1 || { error "Failed to install Brave Browser"; exit 1; }
      ;;
    pacman)
      if command -v yay >/dev/null 2>&1; then
        sudo -u "$(logname 2>/dev/null || echo $SUDO_USER)" yay -S --noconfirm brave-bin || \
          { error "Failed to install Brave via yay"; exit 1; }
      elif command -v paru >/dev/null 2>&1; then
        sudo -u "$(logname 2>/dev/null || echo $SUDO_USER)" paru -S --noconfirm brave-bin || \
          { error "Failed to install Brave via paru"; exit 1; }
      else
        error "AUR helper (yay or paru) required for Arch Linux."
        exit 1
      fi
      ;;
    zypper)
      zypper addrepo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo brave-browser
      zypper --gpg-auto-import-keys refresh brave-browser >/dev/null 2>&1 || \
        { error "Failed to refresh Brave repo"; exit 1; }
      zypper install -y brave-browser >/dev/null 2>&1 || { error "Failed to install Brave Browser"; exit 1; }
      ;;
    emerge)
      echo "www-client/brave-bin" >> /etc/portage/package.accept_keywords
      emerge -q www-client/brave-bin || { error "Failed to install Brave via emerge"; exit 1; }
      ;;
  esac
}

# Update Brave
update_brave() {
  log "Updating Brave Browser..."
  case $PM in
    apt)
      if ! apt update -qq 2>apt_update.log; then
        if grep -q 'brave-browser-apt-release.s3.brave.com' apt_update.log 2>/dev/null; then
          error "apt update failed for Brave repo."
          rm -f apt_update.log
          exit 1
        fi
        UNRELATED_APT_ERROR=1
        warn "apt update encountered unrelated errors. Continuing..."
        rm -f apt_update.log
      fi
      apt upgrade -y brave-browser >/dev/null 2>&1 || warn "Failed to update Brave Browser"
      ;;
    dnf|yum)
      $PM upgrade -y brave-browser >/dev/null 2>&1 || warn "Failed to update Brave Browser"
      ;;
    pacman)
      pacman -Syu --noconfirm brave-browser brave-bin 2>/dev/null || warn "Failed to update Brave Browser"
      ;;
    zypper)
      zypper update -y brave-browser >/dev/null 2>&1 || warn "Failed to update Brave Browser"
      ;;
    emerge)
      emerge -uq www-client/brave-bin || warn "Failed to update Brave Browser"
      ;;
  esac
}

# Define debloat groups
DEBLOAT_GROUPS=(
  "BraveFeaturesServices"
  "PrivacyTracking"
  "AutofillPasswords"
  "Permissions"
  "UISuggestions"
)

# Map group to options
set_debloat_group() {
  local group=$1
  local value=$2
  case $group in
    BraveFeaturesServices)
      for opt in Rewards Wallet VPN News Talk Sync Pings Analytics Crypto Web3; do
        DEBLOAT[$opt]=$value
      done
      ;;
    PrivacyTracking)
      for opt in SafeBrowsing MetricsReporting LogUpload Heartbeat; do
        DEBLOAT[$opt]=$value
      done
      ;;
    AutofillPasswords)
      DEBLOAT[Autofill]=$value
      DEBLOAT[PasswordManager]=$value
      ;;
    Permissions)
      for opt in BackgroundMode WebBluetooth WebUSB Serial HID FileSystemRead FileSystemWrite Popups AudioCapture VideoCapture ScreenCapture; do
        DEBLOAT[$opt]=$value
      done
      ;;
    UISuggestions)
      for opt in Spellcheck HomeButton; do
        DEBLOAT[$opt]=$value
      done
      ;;
  esac
}

# Default: all debloat options enabled
for group in "${DEBLOAT_GROUPS[@]}"; do
  set_debloat_group "$group" 1
done
for opt in SearchSuggestions WebStore BackgroundMode; do
  DEBLOAT[$opt]=1
done

# Prompt for debloat groups
prompt_debloat_groups() {
  echo
  echo "Brave Purifier: Choose which features to debloat"
  safe_read skip_all "Would you like to apply ALL recommended debloat options? [Y/n]: " "Y"
  if [[ $skip_all =~ ^[Yy]$ ]]; then
    info "Applying all recommended debloat options."
    return
  fi
  echo "You will be prompted for each group. Enter 'y' to debloat, 'n' to keep as is."
  for group in "${DEBLOAT_GROUPS[@]}"; do
    case $group in
      BraveFeaturesServices)
        label="Brave Features & Services"
        desc="Disables all Brave-specific services, crypto, rewards, wallet, and telemetry."
        ;;
      PrivacyTracking)
        label="Privacy & Tracking"
        desc="Disables all tracking, telemetry, and privacy-invasive features."
        ;;
      AutofillPasswords)
        label="Autofill & Passwords"
        desc="Disables all autofill (addresses, credit cards, forms) and password manager features."
        ;;
      Permissions)
        label="Permissions"
        desc="Blocks access to sensitive device features and permissions."
        ;;
      UISuggestions)
        label="Other UI & Suggestions"
        desc="Disables UI suggestions."
        ;;
    esac
    echo
    echo "$label"
    echo "  $desc"
    safe_read ans "Debloat this group? [Y/n]: " "Y"
    if [[ $ans =~ ^[Yy]$ ]]; then
      set_debloat_group "$group" 1
      echo "Debloat applied for this group."
    else
      set_debloat_group "$group" 0
      echo "Debloat skipped for this group."
    fi
  done
  echo
  echo "Home Screen Debloat"
  echo "  Removes cards, date & time, top sites, news feed, and widgets from the new tab page."
  safe_read ans "Debloat the home screen? [Y/n]: " "Y"
  if [[ $ans =~ ^[Yy]$ ]]; then
    DEBLOAT[HomeScreen]=1
    echo "Home screen will be debloated."
  else
    DEBLOAT[HomeScreen]=0
    echo "Home screen will remain unchanged."
  fi
  for opt in SearchSuggestions WebStore BackgroundMode; do
    case $opt in
      SearchSuggestions) label="Search Suggestions"; desc="Disables search suggestions in the address bar.";;
      WebStore) label="Web Store"; desc="Hides the web store icon and blocks extension installs.";;
      BackgroundMode) label="Background Mode"; desc="Prevents Brave from running in the background.";;
    esac
    echo
    echo "$label"
    echo "  $desc"
    safe_read ans "Debloat this option? [Y/n]: " "Y"
    if [[ $ans =~ ^[Yy]$ ]]; then
      DEBLOAT[$opt]=1
      echo "Debloat applied for this option."
    else
      DEBLOAT[$opt]=0
      echo "Debloat skipped for this option."
    fi
  done
}

# Reset to Brave defaults
reset_brave_defaults() {
  echo
  warn "This will reset all Brave settings to defaults for all users and system policies."
  warn "It will NOT delete bookmarks, passwords, cookies, credentials, autofill, or sync data."
  safe_read reset_ans "Are you sure you want to reset all settings to Brave defaults? [y/N]: " "N"
  if [[ $reset_ans =~ ^[Yy]$ ]]; then
    rm -f /etc/brave/policies/managed/privacy-policy.json 2>/dev/null
    while IFS=: read -r username user_home; do
      [[ -d "$user_home" ]] || continue
      brave_dir="$user_home/.config/BraveSoftware/Brave-Browser/Default"
      if [[ -f "$brave_dir/Preferences" ]]; then
        mv "$brave_dir/Preferences" "$brave_dir/Preferences.bak.$(date +%s)" 2>/dev/null
      fi
      chown -R "$username:$(id -gn "$username")" "$user_home/.config/BraveSoftware" 2>/dev/null || true
    done < <(getent passwd | awk -F: '$3 >= 1000 && $3 < 65534 && $6 ~ /^\/home\// { print $1":"$6 }')
    info "Brave settings reset to defaults. Bookmarks, passwords, cookies, credentials, autofill, and sync preserved."
  else
    info "Skipping reset to Brave defaults."
  fi
}

# Prompt for default browser
SET_DEFAULT_BROWSER=0
prompt_default_browser() {
  echo
  safe_read ans "Do you want to set Brave as the default browser for your user? [y/N]: " "N"
  if [[ $ans =~ ^[Yy]$ ]]; then
    SET_DEFAULT_BROWSER=1
  fi
}

# Prompt for search engine
SET_GOOGLE_SEARCH=0
prompt_search_engine() {
  echo
  safe_read ans "Do you want to set Google as the default search engine? (Otherwise, DuckDuckGo) [y/N]: " "N"
  if [[ $ans =~ ^[Yy]$ ]]; then
    SET_GOOGLE_SEARCH=1
  fi
}

# Write system policy
write_system_policy() {
  mkdir -p /etc/brave/policies/managed/
  local policy_lines=()
  [[ ${DEBLOAT[AutoplayAllowed]} -eq 1 ]] && policy_lines+=('    "AutoplayAllowed": false')
  [[ ${DEBLOAT[DefaultNotificationsSetting]} -eq 1 ]] && policy_lines+=('    "DefaultNotificationsSetting": 2')
  [[ ${DEBLOAT[DefaultGeolocationSetting]} -eq 1 ]] && policy_lines+=('    "DefaultGeolocationSetting": 2')
  [[ ${DEBLOAT[DefaultCamerasSetting]} -eq 1 ]] && policy_lines+=('    "DefaultCamerasSetting": 2')
  [[ ${DEBLOAT[DefaultMicrophonesSetting]} -eq 1 ]] && policy_lines+=('    "DefaultMicrophonesSetting": 2')
  [[ ${DEBLOAT[DefaultSensorsSetting]} -eq 1 ]] && policy_lines+=('    "DefaultSensorsSetting": 2')
  policy_lines+=('    "DefaultSearchProviderEnabled": true')
  if [[ $SET_GOOGLE_SEARCH -eq 1 ]]; then
    policy_lines+=('    "DefaultSearchProviderName": "Google"')
    policy_lines+=('    "DefaultSearchProviderSearchURL": "https://www.google.com/search?q={searchTerms}"')
    policy_lines+=('    "DefaultSearchProviderSuggestURL": "https://www.google.com/complete/search?output=chrome&q={searchTerms}"')
  else
    policy_lines+=('    "DefaultSearchProviderName": "DuckDuckGo"')
    policy_lines+=('    "DefaultSearchProviderSearchURL": "https://duckduckgo.com/?q={searchTerms}&t=brave"')
    policy_lines+=('    "DefaultSearchProviderSuggestURL": ""')
  fi
  policy_lines+=('    "HomepageLocation": "chrome://newtab/"')
  policy_lines+=('    "NewTabPageLocation": "chrome://newtab/"')
  policy_lines+=('    "RestoreOnStartup": 1')
  [[ ${DEBLOAT[SafeBrowsing]} -eq 1 ]] && policy_lines+=('    "SafeBrowsingEnabled": false')
  [[ ${DEBLOAT[SafeBrowsing]} -eq 1 ]] && policy_lines+=('    "SafeBrowsingExtendedReportingEnabled": false')
  [[ ${DEBLOAT[SearchSuggestions]} -eq 1 ]] && policy_lines+=('    "SearchSuggestEnabled": false')
  [[ ${DEBLOAT[Spellcheck]} -eq 1 ]] && policy_lines+=('    "SpellcheckEnabled": false')
  [[ ${DEBLOAT[Sync]} -eq 1 ]] && policy_lines+=('    "SyncDisabled": true')
  policy_lines+=('    "TorDisabled": false')
  policy_lines+=('    "WebRTCIPHandlingPolicy": "disable_non_proxied_udp"')
  [[ ${DEBLOAT[MetricsReporting]} -eq 1 ]] && policy_lines+=('    "MetricsReportingEnabled": false')
  [[ ${DEBLOAT[Autofill]} -eq 1 ]] && policy_lines+=('    "AutofillAddressEnabled": false')
  [[ ${DEBLOAT[Autofill]} -eq 1 ]] && policy_lines+=('    "AutofillCreditCardEnabled": false')
  [[ ${DEBLOAT[PasswordManager]} -eq 1 ]] && policy_lines+=('    "PasswordManagerEnabled": false')
  [[ ${DEBLOAT[Translate]} -eq 1 ]] && policy_lines+=('    "TranslateEnabled": false')
  policy_lines+=('    "NetworkPredictionOptions": 2')
  [[ ${DEBLOAT[BackgroundMode]} -eq 1 ]] && policy_lines+=('    "BackgroundModeEnabled": false')
  [[ ${DEBLOAT[WebStore]} -eq 1 ]] && policy_lines+=('    "HideWebStoreIcon": true')
  [[ ${DEBLOAT[BookmarksBar]} -eq 1 ]] && policy_lines+=('    "BookmarkBarEnabled": false')
  [[ ${DEBLOAT[HomeButton]} -eq 1 ]] && policy_lines+=('    "ShowHomeButton": false')
  policy_lines+=('    "BrowserSignin": 0')
  [[ ${DEBLOAT[ImportHistory]} -eq 1 ]] && policy_lines+=('    "ImportHistory": false')
  [[ ${DEBLOAT[Popups]} -eq 1 ]] && policy_lines+=('    "DefaultPopupsSetting": 2')
  [[ ${DEBLOAT[WebBluetooth]} -eq 1 ]] && policy_lines+=('    "DefaultWebBluetoothGuardSetting": 2')
  [[ ${DEBLOAT[WebUSB]} -eq 1 ]] && policy_lines+=('    "DefaultWebUsbGuardSetting": 2')
  [[ ${DEBLOAT[FileSystemRead]} -eq 1 ]] && policy_lines+=('    "DefaultFileSystemReadGuardSetting": 2')
  [[ ${DEBLOAT[FileSystemWrite]} -eq 1 ]] && policy_lines+=('    "DefaultFileSystemWriteGuardSetting": 2')
  [[ ${DEBLOAT[Serial]} -eq 1 ]] && policy_lines+=('    "DefaultSerialGuardSetting": 2')
  [[ ${DEBLOAT[HID]} -eq 1 ]] && policy_lines+=('    "DefaultHidGuardSetting": 2')
  [[ ${DEBLOAT[Rewards]} -eq 1 ]] && policy_lines+=('    "BraveRewardsDisabled": true')
  [[ ${DEBLOAT[Wallet]} -eq 1 ]] && policy_lines+=('    "BraveWalletDisabled": true')
  [[ ${DEBLOAT[VPN]} -eq 1 ]] && policy_lines+=('    "BraveVPNDisabled": true')
  [[ ${DEBLOAT[News]} -eq 1 ]] && policy_lines+=('    "BraveNewsDisabled": true')
  [[ ${DEBLOAT[Talk]} -eq 1 ]] && policy_lines+=('    "BraveTalkDisabled": true')
  policy_lines+=('    "BraveSearchDisabled": false')
  policy_lines+=('    "BraveShieldsEnabled": true')
  policy_lines+=('    "BraveShieldsEnabledForUrls": ["*"]')
  policy_lines+=('    "BraveAdBlockEnabled": true')
  policy_lines+=('    "BraveFingerprintingBlockEnabled": true')
  policy_lines+=('    "BraveHTTPSUpgradeEnabled": true')
  policy_lines+=('    "BraveCookieBlockEnabled": true')
  policy_lines+=('    "DefaultCookiesSetting": 4')
  policy_lines+=('    "DefaultJavaScriptSetting": 1')
  policy_lines+=('    "DefaultImagesSetting": 1')
  policy_lines+=('    "DefaultPluginsSetting": 2')
  policy_lines+=('    "DeveloperToolsAvailability": 2')
  policy_lines+=('    "ExtensionInstallBlocklist": ["*"]')
  policy_lines+=('    "ExtensionInstallAllowlist": []')
  [[ ${DEBLOAT[CloudPrint]} -eq 1 ]] && policy_lines+=('    "CloudPrintSubmitEnabled": false')
  policy_lines+=('    "DefaultPrinterSelection": ""')
  [[ ${DEBLOAT[Printing]} -eq 1 ]] && policy_lines+=('    "PrintingEnabled": false')
  [[ ${DEBLOAT[AudioCapture]} -eq 1 ]] && policy_lines+=('    "AudioCaptureAllowed": false')
  [[ ${DEBLOAT[VideoCapture]} -eq 1 ]] && policy_lines+=('    "VideoCaptureAllowed": false')
  [[ ${DEBLOAT[ScreenCapture]} -eq 1 ]] && policy_lines+=('    "ScreenCaptureAllowed": false')
  [[ ${DEBLOAT[MediaRouter]} -eq 1 ]] && policy_lines+=('    "EnableMediaRouter": false')
  [[ ${DEBLOAT[CastIcon]} -eq 1 ]] && policy_lines+=('    "ShowCastIconInToolbar": false')
  policy_lines+=('    "CloudManagementEnrollmentToken": ""')
  [[ ${DEBLOAT[MetricsReporting]} -eq 1 ]] && policy_lines+=('    "ReportVersionData": false')
  [[ ${DEBLOAT[MetricsReporting]} -eq 1 ]] && policy_lines+=('    "ReportPolicyData": false')
  [[ ${DEBLOAT[MetricsReporting]} -eq 1 ]] && policy_lines+=('    "ReportMachineIDData": false')
  [[ ${DEBLOAT[MetricsReporting]} -eq 1 ]] && policy_lines+=('    "ReportUserIDData": false')
  [[ ${DEBLOAT[Heartbeat]} -eq 1 ]] && policy_lines+=('    "HeartbeatEnabled": false')
  [[ ${DEBLOAT[LogUpload]} -eq 1 ]] && policy_lines+=('    "LogUploadEnabled": false')

  # Write policy file without trailing comma
  {
    echo "{"
    for ((i=0; i<${#policy_lines[@]}; i++)); do
      if [[ $i -eq $(( ${#policy_lines[@]} - 1 )) ]]; then
        echo "${policy_lines[$i]}"
      else
        echo "${policy_lines[$i]},"
      fi
    done
    echo "}"
  } > /etc/brave/policies/managed/privacy-policy.json
  chmod 644 /etc/brave/policies/managed/privacy-policy.json
}

# Write user preferences
write_user_preferences() {
  local brave_dir="$1"
  mkdir -p "$brave_dir"
  {
    echo "{"
    echo '   "brave": {'
    echo '      "new_tab_page": {'
    [[ ${DEBLOAT[HomeScreen]} -eq 1 ]] && echo '         "hide_all_widgets": false,'
    [[ ${DEBLOAT[HomeScreen]} -eq 1 ]] && echo '         "show_background_image": false,'
    [[ ${DEBLOAT[HomeScreen]} -eq 1 ]] && echo '         "show_clock": false,'
    [[ ${DEBLOAT[HomeScreen]} -eq 1 ]] && echo '         "show_stats": false,'
    [[ ${DEBLOAT[HomeScreen]} -eq 1 ]] && echo '         "show_top_sites": false,'
    [[ ${DEBLOAT[HomeScreen]} -eq 1 ]] && echo '         "show_news": false,'
    echo '         "enabled": true'
    echo '      },'
    echo "      \"rewards\": { \"enabled\": ${DEBLOAT[Rewards]:-0} == 1 ? false : true },"
    echo "      \"wallet\": { \"enabled\": ${DEBLOAT[Wallet]:-0} == 1 ? false : true },"
    echo "      \"vpn\": { \"enabled\": ${DEBLOAT[VPN]:-0} == 1 ? false : true },"
    echo "      \"news\": { \"enabled\": ${DEBLOAT[News]:-0} == 1 ? false : true },"
    echo "      \"talk\": { \"enabled\": ${DEBLOAT[Talk]:-0} == 1 ? false : true },"
    echo '      "onboarding": {'
    echo '         "enabled": false,'
    echo '         "finished": true'
    echo '      },'
    echo '      "welcome": {'
    echo '         "page_on_startup": false,'
    echo '         "seen": true'
    echo '      }'
    echo '   },'
    echo '   "profile": {'
    echo '      "default_content_setting_values": {'
    echo '         "geolocation": 2,'
    echo '         "media_stream_camera": 2,'
    echo '         "media_stream_mic": 2,'
    echo '         "notifications": 2,'
    echo "         \"popups\": ${DEBLOAT[Popups]:-0} == 1 ? 2 : 1,"
    echo '         "cookies": 4,'
    echo '         "sensors": 2,'
    echo '         "usb_chooser_data": 2,'
    echo '         "serial_chooser_data": 2,'
    echo '         "bluetooth_chooser_data": 2,'
    echo '         "hid_chooser_data": 2'
    echo '      },'
    echo '      "first_run": false'
    echo '   },'
    echo '   "search": {'
    if [[ $SET_GOOGLE_SEARCH -eq 1 ]]; then
      echo '      "default_search_provider": {'
      echo '         "enabled": true,'
      echo '         "name": "Google",'
      echo '         "search_url": "https://www.google.com/search?q={searchTerms}",'
      echo '         "suggest_url": "https://www.google.com/complete/search?output=chrome&q={searchTerms}"'
      echo '      }'
    else
      echo "      \"suggest_enabled\": ${DEBLOAT[SearchSuggestions]:-0} == 1 ? false : true"
    fi
    echo '   },'
    echo "   \"translate\": { \"enabled\": ${DEBLOAT[Translate]:-0} == 1 ? false : true },"
    echo '   "autofill": {'
    echo "      \"profile_enabled\": ${DEBLOAT[Autofill]:-0} == 1 ? false : true,"
    echo "      \"credit_card_enabled\": ${DEBLOAT[Autofill]:-0} == 1 ? false : true"
    echo '   },'
    echo "   \"password_manager\": { \"auto_signin\": ${DEBLOAT[PasswordManager]:-0} == 1 ? false : true },"
    echo "   \"safebrowsing\": { \"enabled\": ${DEBLOAT[SafeBrowsing]:-0} == 1 ? false : true },"
    echo '   "net": { "network_prediction_options": 2 }'
    echo "}"
  } > "$brave_dir/Preferences"
  chmod 600 "$brave_dir/Preferences"
}

# Purge telemetry
purge_telemetry() {
  info "Purging telemetry and tracking components..."
  local telemetry_paths=(
    "/opt/brave.com/brave/brave_crashpad_handler"
    "/opt/brave.com/brave/crash_reporter"
    "/etc/brave/policies/managed/telemetry*"
    "/opt/brave.com/brave/usage*"
  )
  for path in "${telemetry_paths[@]}"; do
    [[ -e "$path" ]] && rm -rf "$path" 2>/dev/null && info "✓ Removed: $path"
  done
  find /home -type d \( -name "Crash Reports" -o -name "Crashpad" \) \
    -path "*/.config/BraveSoftware/Brave-Browser/*" -exec rm -rf {} + 2>/dev/null || true
  info "✓ Telemetry components purged"
}

# Verify installation
verify_installation() {
  log "Verifying Brave Browser installation and privacy settings..."
  if ! command -v brave-browser >/dev/null 2>&1; then
    error "✗ Brave Browser installation failed"
    return 1
  fi
  local version
  version=$(brave-browser --version 2>/dev/null | head -n1 || echo "Unknown")
  log "✓ Brave Browser installed: $version"
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
  echo "BRAVE PURIFIER COMPLETE"
  echo
  info "Brave Browser has been successfully purified for maximum privacy!"
  echo
  echo "Privacy Enhancements Applied:"
  echo "  - All telemetry and tracking disabled"
  echo "  - Ads, trackers, and fingerprinting blocked"
  echo "  - $( [[ $SET_GOOGLE_SEARCH -eq 1 ]] && echo "Google" || echo "DuckDuckGo" ) set as default search engine"
  echo "  - WebRTC IP leak protection enabled"
  echo "  - Unnecessary features disabled (Rewards, Wallet, VPN, etc.)"
  echo "  - Enhanced content blocking and privacy settings"
  echo "  - Hardened security policies applied system-wide"
  echo
  echo "Note: Restart Brave Browser to ensure all settings take effect."
  if [[ $SET_DEFAULT_BROWSER -eq 1 ]]; then
    echo "Brave is set as your default browser."
  fi
  echo "Your privacy is now maximally protected!"
  if [[ $UNRELATED_APT_ERROR -eq 1 ]]; then
    echo
    warn "Some unrelated apt errors were detected. See Troubleshooting in the README."
  fi
  echo
}

# Show help
show_help() {
  echo "$SCRIPT_NAME v$SCRIPT_VERSION"
  echo "Ultra-lightweight privacy-focused Brave Browser installer and debloater"
  echo
  echo "Usage:"
  echo "  sudo $0 [OPTIONS]"
  echo
  echo "Options:"
  echo "  -h, --help     Show this help message"
  echo "  -v, --version  Show version information"
  echo
  echo "Examples:"
  echo "  sudo $0                    # Install/update and purify Brave"
  echo "  sudo $0 --help             # Show help"
  echo
  echo "Repository: https://github.com/nightcodex7/BravePurifier"
}

# Show version
show_version() {
  echo "$SCRIPT_NAME version $SCRIPT_VERSION"
  echo "Author: nightcodex7"
  echo "Repository: https://github.com/nightcodex7/BravePurifier"
  echo "License: MIT"
}

# Parse arguments
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

# Set Brave as default browser
set_brave_default_browser() {
  if [[ $SET_DEFAULT_BROWSER -eq 1 ]]; then
    if command -v xdg-settings >/dev/null 2>&1; then
      xdg-settings set default-web-browser brave-browser.desktop 2>/dev/null && \
        info "Brave set as default browser using xdg-settings."
    elif command -v update-alternatives >/dev/null 2>&1; then
      update-alternatives --set x-www-browser /usr/bin/brave-browser 2>/dev/null && \
        info "Brave set as default browser using update-alternatives."
    else
      warn "Could not set Brave as default browser automatically. Please set it manually."
    fi
  fi
}

# Main execution
main() {
  parse_arguments "$@"
  echo
  echo "BRAVE PURIFIER v$SCRIPT_VERSION"
  echo "Ultra-lightweight privacy-focused installer by nightcodex7"
  echo
  detect_package_manager
  install_dependencies
  if is_brave_installed; then
    log "Brave Browser detected. Updating and debloating."
    update_brave
  else
    log "Brave Browser not detected. Installing..."
    install_brave
  fi
  reset_brave_defaults
  prompt_default_browser
  prompt_debloat_groups
  prompt_search_engine
  write_system_policy
  while IFS=: read -r username user_home; do
    [[ -d "$user_home" ]] || continue
    local brave_dir="$user_home/.config/BraveSoftware/Brave-Browser/Default"
    write_user_preferences "$brave_dir"
    chown -R "$username:$(id -gn "$username")" "$user_home/.config/BraveSoftware" 2>/dev/null || \
      warn "Failed to set ownership for $user_home/.config/BraveSoftware"
    info "Privacy settings applied for user: $username"
  done < <(getent passwd | awk -F: '$3 >= 1000 && $3 < 65534 && $6 ~ /^\/home\// { print $1":"$6 }')
  set_brave_default_browser
  purge_telemetry
  if verify_installation; then
    show_completion
    exit 0
  else
    error "Installation verification failed. Check logs or report an issue."
    exit 1
  fi
}

# Signal handling
trap 'error "Script interrupted"; exit 130' INT TERM HUP QUIT

main "$@"