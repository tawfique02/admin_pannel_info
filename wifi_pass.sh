#!/bin/bash

# Function to get the current connected WiFi password
get_current_wifi_password() {
    # Check if we're connected to a WiFi network
    ssid=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes"{print $2}')
    
    if [ -z "$ssid" ]; then
        echo "No active WiFi connection found."
        return 1
    fi
    
    # Try to get the password for the current WiFi connection
    password=$(nmcli -s -g 802-11-wireless-security.psk connection show "$ssid" 2>/dev/null)
    
    if [ -z "$password" ]; then
        echo "No password found for SSID: $ssid. It might be an open network or stored elsewhere."
    else
        echo "Connected WiFi Network: $ssid"
        echo "Password: $password"
    fi
}

# Function to search for saved WiFi passwords in NetworkManager files
get_saved_wifi_passwords() {
    network_files="/etc/NetworkManager/system-connections/"
    
    if [ ! -d "$network_files" ]; then
        echo "No saved network files found. Ensure NetworkManager is installed."
        return 1
    fi

    echo "Searching for saved WiFi passwords in NetworkManager files..."
    
    for file in "$network_files"*; do
        # Check if the file contains a WiFi password (psk)
        if sudo grep -q "psk=" "$file"; then
            echo "Found WiFi password in: $file"
            sudo grep psk= "$file" | cut -d '=' -f2
        fi
    done
}

# Main function to find the WiFi password (current and saved networks)
find_wifi_password() {
    # First, try to find the current WiFi password
    get_current_wifi_password || echo "Trying to find saved passwords..."
    
    # Then, attempt to find saved WiFi passwords
    get_saved_wifi_passwords
}

# Run the function
find_wifi_password
