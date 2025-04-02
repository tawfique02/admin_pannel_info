
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
echo "============================================="
echo "        ██████  ██    ██ ███████  ██████  "
echo "        ██   ██ ██    ██ ██      ██       "
echo "        ██   ██ ██    ██ █████   ██   ███ "
echo "        ██   ██  ██  ██  ██      ██    ██ "
echo "        ██████    ████   ███████  ██████  "
echo "============================================="
echo "              Password Generator            "
echo "============================================="
echo -e "Tool Author   :  white-eagle"
echo -e "Github        :  https://github.com/tawfique02/"
echo -e "Telegram      :  https://t.me/struct0"
echo "============================================="
echo ""

# Ask for password length
read -p "Enter The Length Of The Password : " length

show_loading

# Generate and display the password
echo "============================================="
echo "Here is the password for you:"
echo ""
echo "$(generate_password "$length")"
echo ""
echo "============================================="
echo "Believe me, it is strong!"
