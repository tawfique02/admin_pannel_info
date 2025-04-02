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
            ascii=$(printf "%d" "$char")   # Fix this line
            
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
