
[+] Welcome to the Admin Page Finder Script!
[+] Select a mode:
1. Basic Scan - Check admin pages only
2. Advanced Scan - Check admin pages, IP info, ports, and vulnerability scan
Enter your choice (1/2): 2

[+] Running Advanced Mode Scan...

[+] Scanning for admin pages on: example.com
[+] Found: http://example.com/admin (HTTP 200)
[+] Found: http://example.com/login (HTTP 301)
[-] Not found: http://example.com/administrator

[+] Fetching IP information...
{
  "ip": "123.45.67.89",
  "hostname": "example.com",
  ...
}

[+] Fetching IP information of example.com...
{
  "ip": "93.184.216.34",
  "hostname": "example.com",
  ...
}

[+] Scanning open and closed ports on example.com...
Starting Nmap 7.91 ( https://nmap.org ) at 2021-06-01 12:34 UTC
Nmap scan report for example.com (93.184.216.34)
Host is up (0.0078s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE
80/tcp open  http
443/tcp open  https

[+] Running basic vulnerability scan on example.com...
- Nikto scan output goes here -

[+] Scan complete.
