import requests
import argparse
from rich.console import Console
from rich.table import Table
from rich.panel import Panel
from rich import box
import re

def get_ip_info(ip):
    """
    Fetches information about an IP address using the ip-api service.
    
    Args:
    ip (str): The IP address to trace.
    
    Returns:
    dict: The JSON response containing IP information, or None if an error occurs.
    """
    url = f"http://ip-api.com/json/{ip}"
    try:
        response = requests.get(url)
        response.raise_for_status()  # Raises an error if the response code is not 200
        data = response.json()
        
        # Check if the response contains valid data
        if data.get("status") == "fail":
            print(f"[bold red]Error: Unable to retrieve data for IP: {ip}[/bold red]")
            return None
        
        return data
    except requests.RequestException as e:
        print(f"[bold red]Error fetching IP data: {e}[/bold red]")
        return None

def display_info(data):
    """
    Displays the IP information in a formatted table.
    
    Args:
    data (dict): The IP information data.
    """
    if not data:
        return
    console = Console()
    console.print(Panel.fit("[bold cyan]SYSTEM IP TRACER[/bold cyan]", title="[bold yellow]IP Tracking Tool[/bold yellow]", style="bold red"))
    
    table = Table(title="IP Information", box=box.DOUBLE)
    table.add_column("Field", style="bold cyan", no_wrap=True)
    table.add_column("Value", style="bold magenta")
    
    fields = {
        "IP": data.get("query", "N/A"),
        "ISP": data.get("isp", "N/A"),
        "Organization": data.get("org", "N/A"),
        "City": data.get("city", "N/A"),
        "Region": data.get("regionName", "N/A"),
        "Country": data.get("country", "N/A"),
        "Latitude": str(data.get("lat", "N/A")),
        "Longitude": str(data.get("lon", "N/A")),
        "Timezone": data.get("timezone", "N/A"),
        "Zip Code": data.get("zip", "N/A"),
    }
    
    for key, value in fields.items():
        table.add_row(f"[bold cyan]{key}[/bold cyan]", f"[bold magenta]{value}[/bold magenta]")
    
    console.print(table)
    console.print(Panel.fit("[green]Developed by: Tawfique Elahey[/green]", title="[bold yellow]Credits[/bold yellow]", style="bold blue"))

def validate_ip(ip):
    """
    Validates the IP address format.
    
    Args:
    ip (str): The IP address to validate.
    
    Returns:
    bool: True if the IP address is valid, False otherwise.
    """
    # Regular expression to match valid IPv4 address format
    regex = r"^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$"
    return re.match(regex, ip) is not None

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="System IP Tracer")
    parser.add_argument("ip", help="IP address to trace", nargs='?', default=None)
    args = parser.parse_args()
    
    # If no IP is provided via argument, prompt the user for input
    if not args.ip:
        args.ip = input("\033[1;36m[?] Enter IP Address: \033[0m")
    
    # Validate the IP address format
    if not validate_ip(args.ip):
        print(f"[bold red]Error: '{args.ip}' is not a valid IP address.[/bold red]")
    else:
        data = get_ip_info(args.ip)
        display_info(data)
