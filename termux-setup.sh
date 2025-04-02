#!/bin/bash

# Function to update the repository
update_repository() {
    echo "Updating repository..."
    bash update.sh
    echo "Repository updated successfully!"
}

# Main script
clear
echo
pkg install pv -y >/dev/null 2>&1
echo -e "\033[32m\033[1m{───────────────────────────────────────────────────}"
echo -e "\033[33m\033[1m   Installing All Required Packages! Please Wait..." | pv -qL 10
apt update                    
apt upgrade -y 
pkg install python -y 
pkg install cmatrix -y 
pkg install pv -y 
apt install figlet -y  
apt install ruby -y 
apt install mpv -y 
pip install lolcat 
pip install random 
pip install requests 
pip install mechanize 
pip2 install bs4
pip2 install requests
pkg install php -y
pkg install python2 -y 
pkg install termux-api -y 
pkg install python3 -y
pkg install tree -y
pkg install nmap -y
pkg install git -y
pkg install curl -y
pkg install wget -y

echo -e "\033[31m\033[1m        INSTALLATION COMPLETED \033[32m[\033[36m✓\033[32m]" | pv -qL 12
echo -e "\033[33m\033[1m]────────────────────────────────────────────["
termux-setup-storage
cp login.sh $PREFIX/etc
# Prompt user for update
read -p "Do you want to update the repository now? (y/n): " choice
if [ "$choice" = "y" ]; then
    update_repository
fi

# Run login script
bash login.sh
