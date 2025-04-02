#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Function to check if a URL is reachable
check_url() {
    local url="$1"
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    if [[ "$response" == "200" || "$response" == "301" || "$response" == "302" ]]; then
        echo -e "\033[32m[+] Found: $url (HTTP $response)\033[0m"  # Green for success
    else
        echo -e "\033[31m[-] Not found: $url (HTTP $response)\033[0m"  # Red for failure
    fi
}

# Function to find admin pages on a given website
find_admin_page() {
    # Check if website argument is provided
    if [ -z "$1" ]; then
        echo "[-] Usage: find_admin_page <website>"
        echo "Example: find_admin_page example.com"
        return 1
    fi

    website="$1"
    wordlist=(
        "admin" "administrator" "login" "adminpanel" "admincp" "cpanel" "dashboard"
        "user" "backend" "manage" "controlpanel" "moderator" "webadmin" "system"
        "wp-admin" "wp-login" "login.php" "admin.php" "panel" "siteadmin"
    )

    # Start scanning for admin panels
    echo -e "\n\033[34m[+] Scanning for admin pages on: $website\033[0m"  # Blue for info
    for path in "${wordlist[@]}"; do
        url="http://$website/$path"
        check_url "$url"
    done
}

# Function to fetch IP information of the website and user
fetch_ip_info() {
    echo -e "\n[+] Fetching IP information..."

    # Get IP info of the user
    if command_exists jq; then
        echo -e "\033[33m[+] User's IP information:\033[0m"
        curl -s http://ipinfo.io/json | jq .
    else
        echo "[-] jq is not installed. Skipping IP info retrieval."
    fi

    # Get IP info of the target website
    website_ip=$(dig +short "$website" | head -n 1)
    if [ -n "$website_ip" ]; then
        if command_exists jq; then
            echo -e "\033[33m[+] IP information of $website:\033[0m"
            curl -s "http://ipinfo.io/$website_ip/json" | jq .
        else
            echo "[-] jq is not installed. Skipping IP info retrieval for $website."
        fi
    else
        echo "[-] Could not retrieve IP for $website"
    fi
}

# Function to scan open and closed ports using nmap
scan_ports() {
    echo -e "\n[+] Scanning open and closed ports on $website..."

    # Check open and closed ports using Nmap (requires installation)
    if command_exists nmap; then
        nmap -F "$website"
    else
        echo "[-] Nmap is not installed. Skipping port scan."
    fi
}

# Function to run basic vulnerability scan using nikto
run_vulnerability_scan() {
    echo -e "\n[+] Running basic vulnerability scan on $website..."

    # Basic website vulnerability scanning using Nikto (requires installation)
    if command_exists nikto; then
        nikto -h "$website"
    else
        echo "[-] Nikto is not installed. Skipping vulnerability scan."
    fi
}

# Function to choose scanning mode (Basic, Advanced)
choose_mode() {
    echo -e "\n[+] Please choose a scan mode:"
    echo "1. Basic Scan - Check admin pages only"
    echo "2. Advanced Scan - Check admin pages, IP info, ports, and vulnerability scan"
    read -p "Enter your choice (1/2): " mode_choice

    case "$mode_choice" in
        1)
            echo -e "\n[+] Running Basic Mode Scan..."
            find_admin_page "$website"
            ;;
        2)
            echo -e "\n[+] Running Advanced Mode Scan..."
            find_admin_page "$website"
            fetch_ip_info
            scan_ports
            run_vulnerability_scan
            ;;
        *)
            echo "[-] Invalid choice. Please choose 1 or 2."
            exit 1
            ;;
    esac
}

# Function to prompt the user to enter the website URL
get_website_url() {
    while true; do
        read -p "Please enter the website URL (without http:// or https://): " website
        # Validate URL format (simple check)
        if [[ "$website" =~ ^[a-zA-Z0-9.-]+$ ]]; then
            echo -e "\n[+] Website URL is valid: $website"
            break
        else
            echo -e "\033[31m[-] Invalid URL. Please enter a valid domain (e.g., example.com).\033[0m"
        fi
    done
}

# Main program execution
echo -e "\n\033[35m[+] Welcome to the Admin Page Finder Script! \033[0m"
echo -e "\033[36mThis script will help you find admin pages, scan ports, and run basic vulnerability scans on websites.\033[0m"

# Prompt the user to enter the website URL
get_website_url

# Ensure user knows what to expect
echo -e "\n[+] Starting the scan on: \033[32m$website\033[0m"

# Choose scanning mode
choose_mode

# End of script
