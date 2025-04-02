import dns.resolver
import argparse
from colorama import Fore, Style

# Function to perform DNS lookup
def nslookup(hostname, server='8.8.8.8'):
    print(f"\n{Fore.CYAN}🌐 Server: {Fore.MAGENTA}{server}{Style.RESET_ALL}")
    print(f"{Fore.CYAN}🖧 Address: {Fore.MAGENTA}{server}#53{Style.RESET_ALL}")

    try:
        # Fetching IPv4 addresses (A record)
        print(f"\n{Fore.GREEN}✅ Non-authoritative answer:{Style.RESET_ALL}")
        print(f"{Fore.BLUE}🔎 Name:{Style.RESET_ALL} {hostname}")

        # CNAME (Canonical Name) record
        try:
            cname = dns.resolver.resolve(hostname, 'CNAME', source=server)
            print(f"{Fore.YELLOW}🔄 CNAME:{Style.RESET_ALL} {cname[0].target}")
        except (dns.resolver.NoAnswer, dns.resolver.NXDOMAIN):
            print(f"{Fore.YELLOW}🔄 CNAME:{Style.RESET_ALL} None")

        # IPv4 (A record)
        try:
            ipv4 = dns.resolver.resolve(hostname, 'A', source=server)
            print(f"{Fore.BLUE}🌍 IPv4 Address(es):{Style.RESET_ALL}")
            for ip in ipv4:
                print(f"\t🖥️ {ip.to_text()}")
        except (dns.resolver.NoAnswer, dns.resolver.NXDOMAIN):
            print(f"{Fore.RED}🔴 No IPv4 addresses found.{Style.RESET_ALL}")

        # IPv6 (AAAA record)
        try:
            ipv6 = dns.resolver.resolve(hostname, 'AAAA', source=server)
            print(f"{Fore.BLUE}🌐 IPv6 Address(es):{Style.RESET_ALL}")
            for ip in ipv6:
                print(f"\t🌍 {ip.to_text()}")
        except (dns.resolver.NoAnswer, dns.resolver.NXDOMAIN):
            print(f"{Fore.RED}🔴 No IPv6 addresses found.{Style.RESET_ALL}")

    except dns.resolver.NXDOMAIN:
        print(f"{Fore.RED}** 🔴 server can't find {hostname}: NXDOMAIN 🔴{Style.RESET_ALL}")
    except Exception as e:
        print(f"{Fore.RED}** 🔴 Error occurred: {str(e)} 🔴{Style.RESET_ALL}")

# Main function to parse arguments and execute the lookup
def main():
    parser = argparse.ArgumentParser(description="Python DNS Lookup Tool")
    parser.add_argument("hostname", help="Hostname to look up (e.g. example.com)")
    parser.add_argument("server", nargs='?', default="8.8.8.8", help="DNS server to use (default: 8.8.8.8)")
    args = parser.parse_args()

    # Perform the lookup
    nslookup(args.hostname, args.server)

if __name__ == "__main__":
    main()
