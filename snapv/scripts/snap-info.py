import sys
import requests

def main():
    # Check if package name is provided as an argument
    if len(sys.argv) != 2:
        print("Usage: python3 snap-find.py <package>")
        sys.exit(1)

    package = sys.argv[1]
    
    url = f"https://api.snapcraft.io/api/v1/snaps/details/{package}"
    
    headers = {
        "X-Ubuntu-Series": "16"  
    }

    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        snap_details = response.json()
        # Convert JSON to a more human-readable format
        for key, value in snap_details.items():
            if isinstance(value, list):
                value = ', '.join(value)
            elif value is None:
                value = "None"
            elif isinstance(value, bool):
                value = "True" if value else "False"
            print(f"{key}: {value}")
    else:
        print(f"Error: {response.status_code}")

if __name__ == "__main__":
    main()

