#!/bin/bash

# Colors for text
RESET="\e[0m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
BOLD="\e[1m"
UNDERLINE="\e[4m"
RED="\e[31m"

# Function to encrypt (Caesar cipher) or decrypt
cipher_text() {
    local text="$1"
    local shift="$2"
    local action="$3"
    local result=""
    local char
    local ascii
    local new_ascii
    local base
    local base_ascii

    # Check if action is 'encrypt' or 'decrypt'
    if [[ "$action" == "encrypt" ]]; then
        shift=$shift
    elif [[ "$action" == "decrypt" ]]; then
        shift=$((26 - shift))  # Reverse shift for decryption
    else
        echo -e "${RED}Error: Action must be 'encrypt' or 'decrypt'!${RESET}"
        return 1
    fi

    # Ensure shift value is between 1 and 25
    if [[ "$shift" -lt 1 || "$shift" -gt 25 ]]; then
        echo -e "${RED}Error: The shift value must be between 1 and 25.${RESET}"
        return 1
    fi

    # Loop through each character in the input text
    for (( i=0; i<${#text}; i++ )); do
        char="${text:i:1}"
        
        # Check if character is a letter
        if [[ "$char" =~ [a-zA-Z] ]]; then
            # Determine base (uppercase or lowercase)
            if [[ "$char" =~ [A-Z] ]]; then
                base="A"
            else
                base="a"
            fi
            
            # Get ASCII value of the character
            ascii=$(printf "%d" "$char")
            
            # Determine the ASCII value of the base letter ('A' or 'a')
            base_ascii=$(printf "%d" "$base")
            
            # Shift character
            new_ascii=$(( (ascii - base_ascii + shift) % 26 + base_ascii ))
            
            # Convert back to character and append to result
            result+=$(printf "\\$(printf '%03o' "$new_ascii")")
        else
            # If not a letter, leave the character as is
            result+="$char"
        fi
    done
    
    echo -e "${CYAN}${BOLD}Result: ${RESET}$result"
}

# Function to display a cool styled button
show_button() {
    local label="$1"
    echo -e "${CYAN}${BOLD}[ ${label} ]${RESET}"
}

# Function to prompt the user for input
prompt_action() {
    echo -e "${YELLOW}${BOLD}Welcome to the Caesar Cipher Tool!${RESET}"
    echo -e "${CYAN}${BOLD}Please select an action below:${RESET}"
    show_button "Encrypt"
    show_button "Decrypt"
    
    read -p "Enter your choice (Encrypt/Decrypt): " choice
    if [[ "$choice" =~ ^[Ee]ncrypt$ ]]; then
        action="encrypt"
    elif [[ "$choice" =~ ^[Dd]ecrypt$ ]]; then
        action="decrypt"
    else
        echo -e "${RED}Invalid choice! Please enter 'Encrypt' or 'Decrypt'.${RESET}"
        return
    fi
    
    # Input validation for text
    read -p "Enter the text to $action: " text
    if [[ -z "$text" ]]; then
        echo -e "${RED}Error: You must provide some text.${RESET}"
        return
    fi
    
    # Input validation for shift value
    while true; do
        read -p "Enter the shift value (e.g., 3): " shift_value
        if [[ "$shift_value" =~ ^[0-9]+$ ]] && [ "$shift_value" -ge 1 ] && [ "$shift_value" -le 25 ]; then
            break
        else
            echo -e "${RED}Error: Please enter a valid number between 1 and 25 for the shift value!${RESET}"
        fi
    done
    
    # Call cipher_text function with user inputs
    cipher_text "$text" "$shift_value" "$action"
}

# Option to keep running the tool or exit
run_tool() {
    while true; do
        prompt_action
        
        # Ask user if they want to run again with properly reset color
        echo -e "${CYAN}${BOLD}Would you like to run again? (y/n): ${RESET}"
        read choice
        if [[ ! "$choice" =~ ^[Yy]$ ]]; then
            echo -e "${CYAN}${BOLD}Thank you for using the Caesar Cipher Tool! Goodbye.${RESET}"
            break
        fi
    done
}

# Start the script with a prompt for action
run_tool
