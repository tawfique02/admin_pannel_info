#!/bin/bash

# Function to generate a secure random password
generate_password() {
    local length=$1
    tr -dc 'A-Za-z0-9!@#$%^&*()_+=-' < /dev/urandom | head -c "$length"
}

# Function to show a loading effect
show_loading() {
    echo -n "Generating password"
    for i in {1..5}; do
        sleep 0.5
        echo -n "."
    done
    echo -e "\n"
}

# Clear screen and display banner
clear
echo "================================================="
echo -e "      \e[1;32m██████  ██    ██ ███████  ██████  \e[0m"
echo -e "      \e[1;32m██   ██ ██    ██ ██      ██       \e[0m"
echo -e "      \e[1;32m██   ██ ██    ██ █████   ██   ███ \e[0m"
echo -e "      \e[1;32m██   ██  ██  ██  ██      ██    ██ \e[0m"
echo -e "      \e[1;32m██████    ████   ███████  ██████  \e[0m"
echo "================================================="
echo -e "            \e[1;34mPassword Generator\e[0m"
echo "================================================="
echo -e "\e[1;33mTool Author   :  white-eagle\e[0m"
echo -e "\e[1;33mGithub        :  https://github.com/tawfique02/\e[0m"
echo -e "\e[1;33mTelegram      :  https://t.me/struct0\e[0m"
echo "================================================="
echo ""

# Ask for password length
read -p "Enter The Length Of The Password : " length

# Validate input
if !  "$length" =~ ^[0-9]+$  || [ "$length" -le 0 ]; then
    echo -e "\e[1;31mInvalid input! Please enter a positive number.\e[0m"
    exit 1
fi

# Show loading animation
show_loading

# Generate and display the password
echo "================================================="
echo -e "\e[1;32mHere is the password for you:\e[0m"
echo ""
echo -e "\e[1;35m$(generate_password "$length")\e[0m"
echo ""
echo "================================================="
echo -e "\e[1;36mBelieve me, it is strong!\e[0m"
echo "================================================="
