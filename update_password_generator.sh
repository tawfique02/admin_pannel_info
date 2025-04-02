#!/bin/bash

# Function to generate a random password
generate_password() {
    local length=$1
    tr -dc 'A-Za-z0-9!@#$%^&*()_+=-' < /dev/urandom | head -c "$length"
}

# Function to show a loading effect
show_loading() {
    echo -n "Generating password"
    for ((i=1; i<=5; i++)); do
        sleep 0.5
        echo -n "."
    done
    echo -e "\n"
}

clear

# Set the green color code
GREEN="\033[32m"
# Reset the color back to default
RESET="\033[0m"

# Cool filled ASCII art for CYPG
echo -e "${GREEN}============================================="
echo -e "  ______   ______   ____     ______    ____  "
echo -e " / ___\\ \\ / /  _ \\ / ___|   / ___\\ \\  / /  _ \\ "
echo -e "| |    \\ V /| |_) | |  _   | |    \\ V /| |_) |"
echo -e "| |___  | | |  __/| |_| |  | |___  | | |  __/ "
echo -e " \\____| |_| |_|    \\____|   \\____| |_| |_|    "
echo -e "============================================="
echo -e "              Cyber Password Generator        "
echo -e "============================================="
echo -e "Tool Author   :  Tawfique Elahey"
echo -e "Github        :  https://github.com/tawfique02/"
echo -e "Telegram      :  https://t.me/struct0"
echo -e "=============================================${RESET}"
echo ""

# Ask for password length
while true; do
    read -p "Enter The Length Of The Password (must be a number): " length

    # Check if input is a positive integer
    if [[ "$length" =~ ^[0-9]+$ ]] && [ "$length" -gt 0 ]; then
        break
    else
        echo "Invalid input! Please enter a valid number greater than 0."
    fi
done

show_loading

# Generate and display the password in green
echo -e "${GREEN}============================================="
echo -e "Here is the password for you:"
echo -e ""
echo -e "$(generate_password "$length")"
echo -e ""
echo -e "============================================="
echo -e "Believe me, it is strong!${RESET}"
