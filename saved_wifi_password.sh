
#!/bin/bash
# This is only run Linux (root)
get_wifi_password_linux() {
    # Check if the user has root privileges (needed for accessing saved network passwords)
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script requires root privileges. Please run as root or with sudo."
        exit 1
    fi

    # Try to get the SSID of the currently connected WiFi network using nmcli
    ssid=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes"{print $2}')

    # Check if the SSID is found
    if [ -z "$ssid" ]; then
        echo "No active WiFi connection found."
        return 1
    fi

    # Try to get the password of the connected WiFi using nmcli
    password=$(nmcli -s -g 802-11-wireless-security.psk connection show "$ssid" 2>/dev/null)

    if [ -z "$password" ]; then
        echo "No password found for SSID: $ssid. It might be an open network or stored elsewhere."
        # Try reading saved passwords from configuration files if nmcli failed
        get_saved_wifi_passwords
    else
        echo "Connected WiFi Network: $ssid"
        echo "Password: $password"
    fi
}

get_saved_wifi_passwords() {
    echo "Trying to find saved passwords in NetworkManager system files..."
    
    # Check if NetworkManager is available
    network_files="/etc/NetworkManager/system-connections/"
    
    if [ -d "$network_files" ]; then
        for file in "$network_files"*; do
            # Only check files that have a password (psk=)
            if sudo grep -q "psk=" "$file"; then
                echo "Found WiFi network in: $file"
                sudo grep psk= "$file" | cut -d '=' -f2
            fi
        done
    else
        echo "NetworkManager configuration files not found. Please ensure NetworkManager is installed and running."
    fi
}

# Run the function
get_wifi_password_linux
