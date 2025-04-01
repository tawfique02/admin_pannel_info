admin_panel_finder() { if [ -z "$1" ]; then echo "Usage: admin_panel_finder <website>" return 1 fi

website="$1"
wordlist=(
    "admin" "administrator" "login" "adminpanel" "admincp" "cpanel" "dashboard"
    "user" "backend" "manage" "controlpanel" "moderator" "webadmin" "system"
)

echo "Scanning for admin panels on: $website"
for path in "${wordlist[@]}"; do
    url="http://$website/$path"
    response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    if [[ "$response" == "200" || "$response" == "301" || "$response" == "302" ]]; then
        echo "[+] Found: $url (HTTP $response)"
    else
        echo "[-] Not found: $url"
    fi
done

# Get IP info of the user
echo "\n[+] Fetching your IP information..."
curl -s http://ipinfo.io/json | jq .

# Get IP info of the target website
echo "\n[+] Fetching IP information of $website..."
website_ip=$(dig +short "$website" | head -n 1)
if [ -n "$website_ip" ]; then
    curl -s "http://ipinfo.io/$website_ip/json" | jq .
else
    echo "[-] Could not retrieve IP for $website"
fi

# Check open and closed ports using Nmap (requires installation)
echo "\n[+] Scanning open and closed ports on $website..."
nmap -F "$website"

# Basic website vulnerability scanning using Nikto (requires installation)
echo "\n[+] Running basic vulnerability scan on $website..."
nikto -h "$website"

}

Usage:

admin_panel_finder example.com 
