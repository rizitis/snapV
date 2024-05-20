import sys
import requests

def main():
    # Check if search query is provided as an argument
    if len(sys.argv) != 2:
        print("Usage: python3 snap-search.py <package>")
        sys.exit(1)

    package = sys.argv[1]
    
    url = f"https://api.snapcraft.io/api/v1/snaps/search?q={package}"
    
    headers = {
        "X-Ubuntu-Series": "16"  
    }

    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        search_results = response.json()
        # Display search results
        for snap in search_results["_embedded"]["clickindex:package"]:
            print(snap["title"])
    else:
        print(f"Error: {response.status_code}")

if __name__ == "__main__":
    main()
