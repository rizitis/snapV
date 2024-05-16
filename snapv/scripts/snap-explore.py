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
        print(f"Response content: {response.content.decode('utf-8')}")

    return all_snap_packages

def write_snap_packages_to_file(snap_packages, filename="/home/$USER/.local/bin/snapv/snap-repo.txt"):
    with open(filename, "w") as file:
        for snap in snap_packages:
            file.write(f"{snap['title']}\n")

    return filename

if __name__ == "__main__":
    snap_packages = get_all_snap_packages()
    if snap_packages:
        repo_file = write_snap_packages_to_file(snap_packages)
        print(f"Snap packages written to '{repo_file}'.")
        # Open the file with less
        subprocess.run(["nl", repo_file])
    else:
        print("No snaps found or error occurred.")

