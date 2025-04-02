
get_server_details() {
    # Prompt the user for the domain or IP address
    read -p "Enter the domain or IP address to fetch details: " server

    echo -e "\n\033[1;34mFetching details for: \033[1;32m$server\033[0m\n"
    echo -e "==============================================="
    
    # 1. Fetch the IP address of the domain or server
    echo -e "\033[1;33m[1] Fetching IP address...\033[0m"
    ip_address=$(dig +short $server)
    if [ -z "$ip_address" ]; then
        echo -e "\033[1;31mError: Unable to resolve the IP address for $server\033[0m"
    else
        echo -e "\033[1;32mIP Address: \033[1;34m$ip_address\033[0m"
    fi
    echo "-----------------------------------------------"

    # 2. Checking open ports (standard range from 1 to 1024)
    echo -e "\033[1;33m[2] Checking open ports...\033[0m"
    open_ports=""
    closed_ports=""
    for port in {1..1024}; do
        (echo > /dev/tcp/$server/$port) &>/dev/null && open_ports="$open_ports$port, "
        if ! (echo > /dev/tcp/$server/$port) &>/dev/null; then
            closed_ports="$closed_ports$port, "
        fi
    done

    # 3. Display open and closed ports
    if [ -n "$open_ports" ]; then
        echo -e "\033[1;32mOpen Ports: \033[1;34m${open_ports%, }\033[0m"
    else
        echo -e "\033[1;31mNo open ports found.\033[0m"
    fi

    if [ -n "$closed_ports" ]; then
        echo -e "\033[1;31mClosed Ports: \033[1;34m${closed_ports%, }\033[0m"
    else
        echo -e "\033[1;32mAll ports are open in the specified range.\033[0m"
    fi
    echo "-----------------------------------------------"

    # 4. Fetching domain WHOIS info
    echo -e "\033[1;33m[3] Fetching domain WHOIS information...\033[0m"
    whois $server | grep -E 'Domain|Registrar|Creation|Expiration|Name Server' -A 5
    echo -e "==============================================="
    echo -e "\033[1;32mDetails fetch completed.\033[0m"
}

# Call the function
get_server_details
