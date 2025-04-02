#!/bin/bash

generate_password() {
    local length=$1
    tr -dc 'A-Za-z0-9!@#$%^&*()_+=-' < /dev/urandom | head -c "$length"
}

show_loading() {
    echo -n "Generating password"
    for i in {1..5}; do
        sleep 0.5
        echo -n "."
    done
    echo -e "\n"
}

clear
echo "============================================="
echo "        Welcome to Password Generator        "
echo "============================================="

read -p "Enter The Length Of The Password: " length

show_loading

echo "============================================="
echo "Here is the password for you:"
echo ""
echo "$(generate_password "$length")"
echo ""
echo "============================================="
echo "Believe me, it is strong!"
