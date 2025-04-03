
#!/bin/bash

# Function to update the repository
update_repository() {
    echo -e "\033[1;34m[INFO] Updating repository..."
    if [ -f "update.sh" ]; then
        bash update.sh
        echo -e "\033[1;32m[SUCCESS] Repository updated successfully!"
    else
        echo -e "\033[1;31m[ERROR] update.sh not found. Skipping repository update."
    fi
}

# Function to install required packages with progress display
install_packages() {
    echo -e "\033[1;33m[INFO] Installing required packages... Please wait."
    echo -e "\033[0;36m────────────────────────────────────────────"
    
    # Update and upgrade packages
    apt update && apt upgrade -y | pv -qL 10

    # Install all required packages with one command
    pkg install python python2 cmatrix pv figlet ruby mpv termux-api tree nmap git curl wget -y | pv -qL 10
    apt install figlet ruby mpv -y | pv -qL 10
    pip install lolcat random requests mechanize | pv -qL 10
    pip2 install bs4 requests | pv -qL 10
    pkg install php python3 -y | pv -qL 10

    echo -e "\033[1;32m[SUCCESS] Installation completed!"
    echo -e "\033[0;36m────────────────────────────────────────────"
}

# Main script
clear

# Install `pv` if not installed already
pkg install pv -y >/dev/null 2>&1

# Start installation process
install_packages

# Prompt user for update
read -p "Do you want to update the repository now? (y/n): " choice
if [ "$choice" = "y" ]; then
    update_repository
else
    echo -e "\033[1;33m[INFO] Skipping repository update."
fi

echo -e "\033[1;32m[INFO] Script execution completed. This script is developed by Md.Tawfique Elahey. If you find any problem please, contact me. And Enjoy your setup!"
echo -e "\033[0m"
