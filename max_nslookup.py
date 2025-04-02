import dns.resolver
import argparse
from colorama import Fore, Back, Style, init
from rich.console import Console
from rich.panel import Panel
from rich.text import Text
from rich.prompt import Prompt

# Initialize colorama
init(autoreset=True)

# Function to perform DNS lookup
def nslookup(hostname, server='8.8.8.8'):
    console = Console()
    console.print(f"\n{Fore.MAGENTA}{Back.CYAN}{Style.BRIGHT}🔍 Welcome to the Cool DNS Lookup Tool! 🌐{Style.RESET_ALL}")
    console.print(f"{Fore.CYAN}🌐 {Style.BRIGHT}Server: {Fore.YELLOW}{server}{Style.RESET_ALL}")
    console.print(f"{Fore.CYAN}🖧 {Style.BRIGHT}Address: {Fore.YELLOW}{server}#53{Style.RESET_ALL}")

    try:
        # Fetching IPv4 addresses (A record)
        console.print(f"\n{Fore.GREEN}{Style.BRIGHT}✅ Non-authoritative answer:{Style.RESET_ALL}")
        console.print(f"{Fore.LIGHTBLUE_EX}{Style.BRIGHT}🔎 Name: {Fore.YELLOW}{hostname}{Style.RESET_ALL}")

        # CNAME (Canonical Name) record
        try:
            cname = dns.resolver.resolve(hostname, 'CNAME', source=server)
            console.print(f"{Fore.YELLOW}{Style.BRIGHT}🔄 CNAME: {Fore.GREEN}{cname[0].target}{Style.RESET_ALL}")
        except (dns.resolver.NoAnswer, dns.resolver.NXDOMAIN):
            console.print(f"{Fore.YELLOW}{Style.BRIGHT}🔄 CNAME: {Fore.RED}None{Style.RESET_ALL}")

        # IPv4 (A record)
        try:
            ipv4 = dns.resolver.resolve(hostname, 'A', source=server)
            console.print(f"{Fore.LIGHTCYAN_EX}{Style.BRIGHT}🌍 IPv4 Address(es):{Style.RESET_ALL}")
            for ip in ipv4:
                console.print(f"\t{Fore.CYAN}🖥️ {Style.BRIGHT}{ip.to_text()}{Style.RESET_ALL}")
        except (dns.resolver.NoAnswer, dns.resolver.NXDOMAIN):
            console.print(f"{Fore.RED}{Style.BRIGHT}🔴 No IPv4 addresses found.{Style.RESET_ALL}")

        # IPv6 (AAAA record)
        try:
            ipv6 = dns.resolver.resolve(hostname, 'AAAA', source=server)
            console.print(f"{Fore.LIGHTCYAN_EX}{Style.BRIGHT}🌐 IPv6 Address(es):{Style.RESET_ALL}")
            for ip in ipv6:
                console.print(f"\t{Fore.CYAN}🌍 {Style.BRIGHT}{ip.to_text()}{Style.RESET_ALL}")
        except (dns.resolver.NoAnswer, dns.resolver.NXDOMAIN):
            console.print(f"{Fore.RED}{Style.BRIGHT}🔴 No IPv6 addresses found.{Style.RESET_ALL}")

    except dns.resolver.NXDOMAIN:
        console.print(f"{Fore.RED}{Style.BRIGHT}** 🔴 Server can't find {hostname}: NXDOMAIN 🔴{Style.RESET_ALL}")
    except Exception as e:
        console.print(f"{Fore.RED}{Style.BRIGHT}** 🔴 Error occurred: {str(e)} 🔴{Style.RESET_ALL}")

# Function to display a user-friendly heading with clear instructions
def cool_heading():
    console = Console()
    console.print(f"\n{Fore.GREEN}{Back.MAGENTA}{Style.BRIGHT}=========================== DNS LOOKUP TOOL ==========================={Style.RESET_ALL}")
    console.print(f"{Fore.YELLOW}{Style.BRIGHT}🚀 Welcome to the Cool DNS Lookup Tool 🕶️{Style.RESET_ALL}")
    console.print(f"{Fore.CYAN}{Style.BRIGHT}🌐 This tool allows you to look up DNS information of any domain.{Style.RESET_ALL}")
    console.print(f"{Fore.CYAN}{Style.BRIGHT}🔍 Simply provide the domain name, and we will get its IP addresses (IPv4 and IPv6), CNAME, and more!{Style.RESET_ALL}")
    console.print(f"{Fore.MAGENTA}{Style.BRIGHT}=========================== Let's Start! ==========================={Style.RESET_ALL}\n")

# Function to validate if the domain name entered is correct
def validate_hostname(hostname):
    if not hostname:
        print(f"{Fore.RED}{Style.BRIGHT}** 🔴 Error: Hostname cannot be empty! 🔴{Style.RESET_ALL}")
        return False
    if not isinstance(hostname, str):
        print(f"{Fore.RED}{Style.BRIGHT}** 🔴 Error: Invalid hostname format! 🔴{Style.RESET_ALL}")
        return False
    return True

# Function to prompt the user to choose options using "button-like" interface
def show_buttons():
    console = Console()
    button1 = Text("[bold cyan]Press '1' for DNS Lookup[/bold cyan]", style="bold yellow")
    button2 = Text("[bold cyan]Press '2' to exit[/bold cyan]", style="bold yellow")
    console.print(button1)
    console.print(button2)

    choice = Prompt.ask(f"{Fore.YELLOW}{Style.BRIGHT}Choose an option (1/2):{Style.RESET_ALL}")
    return choice

# Main function to parse arguments and execute the lookup
def main():
    cool_heading()

    # Show user-friendly buttons for interaction
    while True:
        choice = show_buttons()

        if choice == "1":
            hostname = Prompt.ask(f"{Fore.CYAN}{Style.BRIGHT}🌐 Please enter the hostname (e.g. example.com):{Style.RESET_ALL}")
            if not validate_hostname(hostname):
                continue  # Exit if the hostname is invalid

            # Optionally ask for a custom DNS server
            server = Prompt.ask(f"{Fore.CYAN}{Style.BRIGHT}🌍 Optionally, enter the DNS server (default is 8.8.8.8):{Style.RESET_ALL}", default="8.8.8.8")

            print(f"\n{Fore.YELLOW}{Style.BRIGHT}🚀 Performing DNS lookup for {hostname} using server {server}...{Style.RESET_ALL}")
            
            # Perform the DNS lookup
            nslookup(hostname, server)

        elif choice == "2":
            print(f"{Fore.GREEN}{Style.BRIGHT}Thank you for using the Cool DNS Lookup Tool! See you soon!{Style.RESET_ALL}")
            break
        else:
            print(f"{Fore.RED}{Style.BRIGHT}** 🔴 Invalid choice! Please select a valid option. 🔴{Style.RESET_ALL}")

    # Developer credit message in a stylish box
    console = Console()
    developer_info = Text(f"{Fore.MAGENTA}{Style.BRIGHT}This script is developed by Tawfique Elahey{Style.RESET_ALL}", style="bold cyan")
    panel = Panel(developer_info, title="Developer Information", subtitle="Created by Tawfique Elahey", style="bold yellow", box="round")
    console.print(panel)

if __name__ == "__main__":
    main()
