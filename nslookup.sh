nslookup() {
    if [ -z "$1" ]; then
        echo -e "\033[1;31m🔴 Usage: nslookup <hostname> [server] 🔴\033[0m"
        return 1
    fi

    local hostname="$1"
    local server="${2:-8.8.8.8}"  # Default to Google's DNS if none provided

    echo -e "\n\033[1;36m🌐 Server:\033[0m \033[1;35m$server\033[0m"
    echo -e "\033[1;36m🖧 Address:\033[0m $server#53"

    # Fetch IPv4 and IPv6 addresses
    local ipv4 ipv6 cname
    ipv4=$(dig @$server +short A "$hostname")
    ipv6=$(dig @$server +short AAAA "$hostname")
    cname=$(dig @$server +short CNAME "$hostname")

    if [ -z "$ipv4" ] && [ -z "$ipv6" ]; then
        echo -e "\033[1;31m** 🔴 server can't find $hostname: NXDOMAIN 🔴\033[0m"
    else
        echo -e "\n\033[1;32m✅ Non-authoritative answer:\033[0m"
        echo -e "\033[1;34m🔎 Name:\033[0m\t$hostname"

        # Display CNAME if exists
        if [ ! -z "$cname" ]; then
            echo -e "\033[1;33m🔄 CNAME:\033[0m\t$cname"
        fi

        # Print IPv4 addresses
        if [ ! -z "$ipv4" ]; then
            echo -e "\033[1;34m🌍 IPv4 Address(es):\033[0m"
            echo "$ipv4" | awk '{print "\t🖥️ " $1}'
        fi

        # Print IPv6 addresses
        if [ ! -z "$ipv6" ]; then
            echo -e "\033[1;34m🌐 IPv6 Address(es):\033[0m"
            echo "$ipv6" | awk '{print "\t🌍 " $1}'
        fi
    fi
}
