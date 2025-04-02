
get_wifi_password_linux() {
    # Get the current connected SSID
    ssid=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes"{print $2}')

    # If no SSID is found, notify the user
    if [ -z "$ssid" ]; then
        echo "No active WiFi connection found."
        return 1
    fi

    # Get the password for the connected WiFi
    password=$(nmcli -s -g 802-11-wireless-security.psk connection show "$ssid" 2>/dev/null)

    # If no password is found, print a message
    if [ -z "$password" ]; then
        echo "No password found for SSID: $ssid (It might be an open network or stored elsewhere)"
    else
        echo "Connected WiFi Network: $ssid"
        echo "Password: $password"
    fi
}
