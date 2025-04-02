import requests
import argparse
from rich.console import Console
from rich.table import Table
from rich.panel import Panel
from rich import box

def get_ip_info(ip):
    url = f"http://ip-api.com/json/{ip}"
    try:
        response = requests.get(url)
        response.raise_for_status()  # Raises an error if the response code is not 200
        return response.json()
    except requests.RequestException as e:
        print(f"Error fetching IP data: {e}")
        return None

def display_info(data):
    if not data:
        return
    console = Console()
    console.print(Panel.fit("[bold cyan]WHITE IP TRACER[/bold cyan]", title="[bold yellow]IP Tracking Tool[/bold yellow]", style="bold red"))
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
    console.print(Panel.fit("[green]Developed by: White-Eagle[/green]", title="[bold yellow]Credits[/bold yellow]", style="bold blue"))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Simple IP Tracer")
    parser.add_argument("ip", help="IP address to trace", nargs='?', default=None)
    args = parser.parse_args()
    
    # If no IP is provided via argument, prompt the user for input
    if not args.ip:
        args.ip = input("\e[1;36m[?] Enter IP Address: \e[0m")

    data = get_ip_info(args.ip)
    display_info(data)
