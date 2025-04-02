get_wifi_password_termux() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script requires root privileges. Run with: sudo or su"
        exit 1
    fi

    WIFI_CONFIG="/data/misc/wifi/wpa_supplicant.conf"
    
    if [ ! -f "$WIFI_CONFIG" ]; then
        echo "WiFi configuration file not found. Make sure your device is rooted."
        exit 1
    fi

    echo "Saved WiFi Networks and Passwords:"
    echo "----------------------------------"
    
    grep -E 'ssid|psk' "$WIFI_CONFIG" | sed -e 's/ssid=/WiFi Name: /' -e 's/psk=/Password: /' | sed 's/"//g'
}
