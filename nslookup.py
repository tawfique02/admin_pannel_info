import dns.resolver
import argparse
from colorama import Fore, Back, Style, init

# Initialize colorama
init(autoreset=True)

# Function to perform DNS lookup
def nslookup(hostname, server='8.8.8.8'):
    print(f"\n{Fore.MAGENTA}{Back.CYAN}{Style.BRIGHT}🔍 Welcome to the Cool DNS Lookup Tool! 🌐{Style.RESET_ALL}")
    print(f"{Fore.CYAN}🌐 {Style.BRIGHT}Server:{Fore.YELLOW} {server}{Style.RESET_ALL}")
    print(f"{Fore.CYAN}🖧 {Style.BRIGHT}Address:{Fore.YELLOW} {server}#53{Style.RESET_ALL}")

    try:
        # Fetching IPv4 addresses (A record)
        print(f"\n{Fore.GREEN}{Style.BRIGHT}✅ Non-authoritative answer:{Style.RESET_ALL}")
        print(f"{Fore.LIGHTBLUE_EX}{Style.BRIGHT}🔎 Name:{Fore.YELLOW} {hostname}{Style.RESET_ALL}")

        # CNAME (Canonical Name) record
        try:
            cname = dns.resolver.resolve(hostname, 'CNAME', source=server)
            print(f"{Fore.YELLOW}{Style.BRIGHT}🔄 CNAME:{Fore.GREEN} {cname[0].target}{Style.RESET_ALL}")
        except (dns.resolver.NoAnswer, dns.resolver.NXDOMAIN):
            print(f"{Fore.YELLOW}{Style.BRIGHT}🔄 CNAME:{Fore.RED} None{Style.RESET_ALL}")

        # IPv4 (A record)
        try:
            ipv4 = dns.resolver.resolve(hostname, 'A', source=server)
            print(f"{Fore.LIGHTCYAN_EX}{Style.BRIGHT}🌍 IPv4 Address(es):{Style.RESET_ALL}")
            for ip in ipv4:
                print(f"\t{Fore.CYAN}🖥️ {Style.BRIGHT}{ip.to_text()}{Style.RESET_ALL}")
        except (dns.resolver.NoAnswer, dns.resolver.NXDOMAIN):
            print(f"{Fore.RED}{Style.BRIGHT}🔴 No IPv4 addresses found.{Style.RESET_ALL}")

        # IPv6 (AAAA record)
        try:
            ipv6 = dns.resolver.resolve(hostname, 'AAAA', source=server)
            print(f"{Fore.LIGHTCYAN_EX}{Style.BRIGHT}🌐 IPv6 Address(es):{Style.RESET_ALL}")
            for ip in ipv6:
                print(f"\t{Fore.CYAN}🌍 {Style.BRIGHT}{ip.to_text()}{Style.RESET_ALL}")
        except (dns.resolver.NoAnswer, dns.resolver.NXDOMAIN):
            print(f"{Fore.RED}{Style.BRIGHT}🔴 No IPv6 addresses found.{Style.RESET_ALL}")

    except dns.resolver.NXDOMAIN:
        print(f"{Fore.RED}{Style.BRIGHT}** 🔴 Server can't find {hostname}: NXDOMAIN 🔴{Style.RESET_ALL}")
    except Exception as e:
        print(f"{Fore.RED}{Style.BRIGHT}** 🔴 Error occurred: {str(e)} 🔴{Style.RESET_ALL}")

# Function to display a cool heading
def cool_heading():
    print(f"\n{Fore.GREEN}{Back.MAGENTA}{Style.BRIGHT}=========================== DNS LOOKUP TOOL ==========================={Style.RESET_ALL}")
    print(f"{Fore.YELLOW}{Style.BRIGHT}🚀 Get your DNS info with style! 🕶️{Style.RESET_ALL}")
    print(f"{Fore.CYAN}{Style.BRIGHT}=========================== Let's Start! ==========================={Style.RESET_ALL}\n")

# Main function to parse arguments and execute the lookup
def main():
    cool_heading()

    parser = argparse.ArgumentParser(description="Python DNS Lookup Tool")
    parser.add_argument("hostname", help="Hostname to look up (e.g. example.com)")
    parser.add_argument("server", nargs='?', default="8.8.8.8", help="DNS server to use (default: 8.8.8.8)")
    args = parser.parse_args()

    # Perform the lookup
    nslookup(args.hostname, args.server)

    print(f"\n{Fore.MAGENTA}{Style.BRIGHT}🔥 Thank you for using the Cool DNS Lookup Tool! 🔥{Style.RESET_ALL}")
    print(f"{Fore.CYAN}{Style.BRIGHT}=========================== Have a great day! ==========================={Style.RESET_ALL}\n")

if __name__ == "__main__":
    main()
