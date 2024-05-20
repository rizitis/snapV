import os
import requests
import subprocess

def get_all_snap_packages():
    url = "https://api.snapcraft.io/api/v1/snaps/search"
    headers = {
        "Accept": "application/json"
    }

    all_snap_packages = []

    try:
        page = 1
        while True:
            params = {
                "page": page,
                "confinement": "strict"
            }

            response = requests.get(url, params=params, headers=headers)
            response.raise_for_status()
            snap_list = response.json()
            snaps = snap_list.get('_embedded', {}).get('clickindex:package', [])
            all_snap_packages.extend(snaps)

            if 'next' not in snap_list['_links']:
                break

            page += 1

    except requests.RequestException as e:
        print(f"Request error: {e}")
        if response is not None:
            print(f"Response content: {response.content.decode('utf-8')}")
        else:
            print("No response received.")

    return all_snap_packages

def write_snap_packages_to_file(snap_packages, filename="~/.local/bin/snapv/snap-repo.txt"):
    # Expand the user directory
    filename = os.path.expanduser(filename)
    # Create directory if it doesn't exist
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    
    try:
        with open(filename, "w") as file:
            for snap in snap_packages:
                file.write(f"{snap['title']}\n")
        return filename
    except IOError as e:
        print(f"File error: {e}")
        return None

if __name__ == "__main__":
    snap_packages = get_all_snap_packages()
    if snap_packages:
        repo_file = write_snap_packages_to_file(snap_packages)
        if repo_file:
            print(f"Snap packages written to '{repo_file}'.")
            # Display the file with line numbers using nl command
            subprocess.run(["nl", repo_file])
        else:
            print("Failed to write snap packages to file.")
    else:
        print("No snaps found or error occurred.")

