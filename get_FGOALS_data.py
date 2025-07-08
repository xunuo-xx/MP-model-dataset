import requests 
import datetime 
from bs4 import BeautifulSoup  
import sys
import os

# Fixed parameters (no command-line arguments needed)
exp_name = "amip"         # Experiment name
table_ID = "Amon"         # Table ID
var_name = "pr"           # Variable name
start_time = "1979-01-01" # Start date
end_time = "2021-12-31"   # End date
download_dir = "./FGOALS_data"  # Download directory (modifiable)
base_url = "https://labesm-data.iap.ac.cn/FGOALS-f3-L/"  # Data repository URL

def generate_month_range(start_date_str, end_date_str):
    """Generate a list of months in YYYYMM format between two dates"""
    start_date = datetime.datetime.strptime(start_date_str, '%Y-%m-%d')
    end_date = datetime.datetime.strptime(end_date_str, '%Y-%m-%d')
    total_months = (end_date.year - start_date.year) * 12 + end_date.month - start_date.month
    month_list = []
    
    for offset in range(0, total_months + 1):
        current_month = (start_date.month - 1 + offset)
        date_str = f"{start_date.year + current_month // 12}{(current_month % 12 + 1):02d}"
        month_list.append(date_str)
    
    return month_list

# Create download directory if it doesn't exist
if not os.path.exists(download_dir):
    os.makedirs(download_dir)
    print(f"Created download directory: {download_dir}")

try:
    # Fetch directory listing from data repository
    response = requests.get(base_url)  
    soup = BeautifulSoup(response.text, "html.parser")  

    # Extract all href links from the page
    all_links = [a["href"] for a in soup.find_all("a")]  
    print(f"Found {len(all_links)} files in repository, starting filtering...")

    # Filter matching files based on criteria
    matching_files = []
    for link in all_links:  
        # Required patterns: experiment name, table ID, variable name
        required_patterns = [
            f'/{exp_name}/',
            f'/{table_ID}/',
            f'/{var_name}/'
        ]
        
        time_periods = generate_month_range(start_time, end_time)
        
        # Check if link matches all required patterns and time period
        if all(pattern in link for pattern in required_patterns) and any(period in link for period in time_periods): 
            matching_files.append(link[1:])  # Remove leading '/'
    
    print(f"Identified {len(matching_files)} files matching criteria")

    # Download files to target directory
    for file_path in matching_files:
        file_url = base_url + file_path
        file_name = os.path.basename(file_path)
        download_cmd = f'wget -N -P "{download_dir}" {file_url}'
        print(f"Downloading: {file_name}")
        os.system(download_cmd)

    # Final status report
    print("=" * 50)
    print(f"Download complete! Data saved to: {os.path.abspath(download_dir)}")
    print(f"Successfully downloaded {len(matching_files)} out of {len(all_links)} files")

except requests.exceptions.RequestException as e:
    print(f"Network error occurred: {e}")
    sys.exit(1)
except Exception as e:
    print(f"An unexpected error occurred: {e}")
    sys.exit(1)