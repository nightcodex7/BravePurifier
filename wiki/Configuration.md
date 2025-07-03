# Configuration

Advanced configuration options for customizing BravePurifier behavior and Brave Browser settings.

## 🔧 Script Configuration

### Environment Variables

You can customize BravePurifier behavior using environment variables:

```bash
# Skip dependency installation
export SKIP_DEPS=true

# Force specific package manager
export FORCE_PM="apt"

# Custom policy directory
export POLICY_DIR="/custom/path/policies"

# Verbose output
export VERBOSE=true

# Skip user settings application
export SKIP_USER_SETTINGS=true
```

### Command Line Options

```bash
# Show help
./brave-purifier.sh --help

# Show version
./brave-purifier.sh --version

# Dry run (show what would be done)
./brave-purifier.sh --dry-run

# Force reinstall
./brave-purifier.sh --force
```

## 📁 Policy Configuration

### System-Wide Policies

Policies are stored in `/etc/brave/policies/managed/privacy-policy.json`

#### Core Privacy Policies
```json
{
    "MetricsReportingEnabled": false,
    "SafeBrowsingEnabled": false,
    "SearchSuggestEnabled": false,
    "SyncDisabled": true,
    "AutofillAddressEnabled": false,
    "AutofillCreditCardEnabled": false,
    "PasswordManagerEnabled": false
}
```

#### Content Blocking Policies
```json
{
    "DefaultNotificationsSetting": 2,
    "DefaultGeolocationSetting": 2,
    "DefaultCamerasSetting": 2,
    "DefaultMicrophonesSetting": 2,
    "DefaultPopupsSetting": 2,
    "DefaultCookiesSetting": 4
}
```

#### Brave-Specific Policies
```json
{
    "BraveRewardsDisabled": true,
    "BraveWalletDisabled": true,
    "BraveVPNDisabled": true,
    "BraveNewsDisabled": true,
    "BraveTalkDisabled": true
}
```

### Custom Policy Creation

Create custom policies for specific needs:

```bash
# Create custom policy file
sudo mkdir -p /etc/brave/policies/managed/
sudo nano /etc/brave/policies/managed/custom-policy.json
```

Example custom policy:
```json
{
    "HomepageLocation": "https://duckduckgo.com",
    "RestoreOnStartup": 4,
    "RestoreOnStartupURLs": ["https://duckduckgo.com"],
    "BookmarkBarEnabled": true,
    "ShowHomeButton": true
}
```

## 👤 User-Specific Configuration

### User Preferences

User settings are stored in `~/.config/BraveSoftware/Brave-Browser/Default/Preferences`

#### Privacy Settings
```json
{
    "profile": {
        "default_content_setting_values": {
            "geolocation": 2,
            "media_stream_camera": 2,
            "media_stream_mic": 2,
            "notifications": 2,
            "popups": 2
        }
    }
}
```

#### Search Configuration
```json
{
    "default_search_provider": {
        "enabled": true,
        "name": "DuckDuckGo",
        "search_url": "https://duckduckgo.com/?q={searchTerms}&t=brave",
        "suggest_url": ""
    }
}
```

### Per-User Customization

Apply different settings for different users:

```bash
# Create user-specific script
sudo nano /usr/local/bin/brave-user-config.sh
```

```bash
#!/bin/bash
USER_HOME="/home/$1"
BRAVE_DIR="$USER_HOME/.config/BraveSoftware/Brave-Browser/Default"

# Custom preferences for specific user
cat > "$BRAVE_DIR/Preferences" << 'EOF'
{
    "brave": {
        "new_tab_page": {
            "show_background_image": true,
            "show_clock": true
        }
    }
}
EOF

chown -R "$1:$1" "$USER_HOME/.config/BraveSoftware"
```

## 🛡️ Security Configuration

### Enhanced Security Policies

For high-security environments:

```json
{
    "DeveloperToolsAvailability": 2,
    "ExtensionInstallBlocklist": ["*"],
    "DefaultJavaScriptSetting": 2,
    "DefaultPluginsSetting": 2,
    "RemoteAccessHostFirewallTraversal": false,
    "EnableMediaRouter": false
}
```

### Network Security
```json
{
    "WebRTCIPHandlingPolicy": "disable_non_proxied_udp",
    "NetworkPredictionOptions": 2,
    "DnsOverHttpsMode": "secure",
    "DnsOverHttpsTemplates": "https://cloudflare-dns.com/dns-query"
}
```

## 🔍 Search Engine Configuration

### Default Search Engines

Configure alternative search engines:

#### DuckDuckGo (Default)
```json
{
    "name": "DuckDuckGo",
    "search_url": "https://duckduckgo.com/?q={searchTerms}&t=brave",
    "suggest_url": ""
}
```

#### Startpage
```json
{
    "name": "Startpage",
    "search_url": "https://www.startpage.com/sp/search?query={searchTerms}",
    "suggest_url": ""
}
```

#### Searx
```json
{
    "name": "Searx",
    "search_url": "https://searx.org/search?q={searchTerms}",
    "suggest_url": ""
}
```

## 🎨 Interface Configuration

### New Tab Page Customization

```json
{
    "brave": {
        "new_tab_page": {
            "hide_all_widgets": false,
            "show_background_image": true,
            "show_clock": true,
            "show_stats": true,
            "show_top_sites": false,
            "show_rewards": false
        }
    }
}
```

### Toolbar Configuration
```json
{
    "bookmark_bar": {
        "show_on_all_tabs": true
    },
    "browser": {
        "show_home_button": true
    }
}
```

## 🔌 Extension Configuration

### Allowed Extensions

Create whitelist for trusted extensions:

```json
{
    "ExtensionInstallBlocklist": ["*"],
    "ExtensionInstallAllowlist": [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm",  // uBlock Origin
        "gcbommkclmclpchllfjekcdonpmejbdp",  // HTTPS Everywhere
        "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"   // Privacy Badger
    ]
}
```

### Extension Policies
```json
{
    "ExtensionSettings": {
        "cjpalhdlnbpafiamejdnhcphjbkeiagm": {
            "installation_mode": "force_installed",
            "update_url": "https://clients2.google.com/service/update2/crx"
        }
    }
}
```

## 📊 Monitoring Configuration

### Logging Settings

Enable specific logging for troubleshooting:

```bash
# Enable verbose logging
brave-browser --enable-logging --log-level=0 --v=1

# Log specific components
brave-browser --enable-logging --vmodule=brave_shields*=1
```

### Performance Monitoring
```json
{
    "PerformanceMonitoringEnabled": false,
    "MetricsReportingEnabled": false,
    "HeartbeatEnabled": false
}
```

## 🔄 Update Configuration

### Automatic Updates

Control update behavior:

```json
{
    "AutoUpdateCheckPeriodMinutes": 0,
    "UpdatesSuppressed": true,
    "ComponentUpdatesEnabled": false
}
```

### Manual Update Control
```bash
# Disable automatic updates
sudo systemctl disable brave-browser-update.service
sudo systemctl mask brave-browser-update.service
```

## 🛠️ Advanced Configuration

### Command Line Flags

Create custom launcher with specific flags:

```bash
# Create custom launcher
sudo nano /usr/local/bin/brave-private
```

```bash
#!/bin/bash
exec /usr/bin/brave-browser \
    --disable-background-networking \
    --disable-background-timer-throttling \
    --disable-backgrounding-occluded-windows \
    --disable-renderer-backgrounding \
    --disable-features=TranslateUI \
    --disable-ipc-flooding-protection \
    --disable-client-side-phishing-detection \
    --disable-component-update \
    --disable-default-apps \
    --disable-domain-reliability \
    --disable-extensions \
    --disable-features=AutofillServerCommunication \
    --disable-hang-monitor \
    --disable-prompt-on-repost \
    --disable-sync \
    --disable-web-security \
    --no-default-browser-check \
    --no-first-run \
    --no-pings \
    --no-service-autorun \
    --password-store=basic \
    --use-mock-keychain \
    "$@"
```

### Profile Management

Create isolated profiles:

```bash
# Create work profile
brave-browser --user-data-dir=/home/user/.config/brave-work

# Create personal profile
brave-browser --user-data-dir=/home/user/.config/brave-personal
```

## 📝 Configuration Validation

### Verify Policies

Check if policies are applied correctly:

```bash
# Check system policies
ls -la /etc/brave/policies/managed/

# Verify policy content
cat /etc/brave/policies/managed/privacy-policy.json | jq .

# Check user preferences
cat ~/.config/BraveSoftware/Brave-Browser/Default/Preferences | jq .
```

### Test Configuration

```bash
# Test with specific configuration
brave-browser --user-data-dir=/tmp/brave-test --no-first-run
```

## 🔧 Troubleshooting Configuration

### Reset to Defaults

```bash
# Reset system policies
sudo rm -rf /etc/brave/policies/

# Reset user settings
rm -rf ~/.config/BraveSoftware/

# Rerun BravePurifier
sudo ./brave-purifier.sh
```

### Debug Configuration Issues

```bash
# Check policy application
brave-browser --show-component-extension-options

# Verify settings
brave-browser chrome://policy/
brave-browser chrome://settings/
```

For more troubleshooting help, see [Troubleshooting](Troubleshooting) page.