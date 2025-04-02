
#!/bin/bash

# Colors for text
RESET="\e[0m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
BOLD="\e[1m"
RED="\e[31m"
BOX="\e[36m"  # Color for the box

# Function to display a message inside a box
display_in_box() {
    local message="$1"
    local len=${#message}
    local border=$(printf "%0.s=" $(seq 1 $((len + 4))))  # Create border of length len+4

    echo -e "${BOX}${border}${RESET}"
    echo -e "${BOX}  ${message}  ${RESET}"
    echo -e "${BOX}${border}${RESET}"
}

# Display script credit with box
clear
display_in_box "${BOLD}This script is developed by James${RESET}"

# Function to install required packages
install_packages() {
    echo -e "${YELLOW}${BOLD}   Installing All Required Packages! Please Wait...${RESET}"
     echo -e "${YELLOW}${BOLD}]────────────────────────────────────────────[${RESET}"| pv -qL 10
    packages=(
        "python"
        "cmatrix"
        "pv"
        "figlet"
        "ruby"
        "mpv"
        "python2"
        "termux-api"
        "python3"
        "tree"
        "nmap"
        "git"
        "curl"
        "wget"
        "php"
    )
    
    for pkg in "${packages[@]}"; do
        echo -e "Installing: ${GREEN}$pkg${RESET}"
        pkg install "$pkg" -y >/dev/null 2>&1
    done
    
    # Python packages via pip
    echo -e "Installing Python packages..."
    pip install lolcat random requests mechanize || echo -e "${RED}Failed to install Python packages!${RESET}"
    pip2 install bs4 requests || echo -e "${RED}Failed to install pip2 packages!${RESET}"
    
    echo -e "${CYAN}${BOLD}        INSTALLATION COMPLETED [✓]${RESET}" | pv -qL 12
    echo -e "${YELLOW}${BOLD}]────────────────────────────────────────────[${RESET}"
}

# Prompt user to confirm running the installation
clear
echo -e "${CYAN}${BOLD}   Initializing Script... Please Wait...${RESET}"
termux-setup-storage

# Run the installation function
install_packages

# Script completed
echo -e "${CYAN}${BOLD}Installation and setup are complete!${RESET}"
display_in_box "${BOLD}This script is developed by James${RESET}"
