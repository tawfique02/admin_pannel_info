get_ip_address() {
    echo "Finding IP address..."

    # Find external (public) IP using a public API (for external network)
    # This script is for educational purposes only. Don't use it for unethical purposes.
    external_ip=$(curl -s ifconfig.me)
    if [ -z "$external_ip" ]; then
        external_ip="Unable to retrieve external IP."
    fi

    # Find internal (private) IP address (local network)
    internal_ip=$(hostname -I | awk '{print $1}')
    if [ -z "$internal_ip" ]; then
        internal_ip="Unable to retrieve internal IP."
    fi

    # Display the IP addresses
    echo -e "\033[1;32mInternal IP Address: \033[1;34m$internal_ip\033[0m"
    echo -e "\033[1;32mExternal IP Address: \033[1;34m$external_ip\033[0m"
}

get_ip_address
