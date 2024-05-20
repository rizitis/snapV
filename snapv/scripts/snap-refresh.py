import os
import requests
import sys

def main():
    if len(sys.argv) != 2:
        print("Usage: python script_name.py <package_name>")
        sys.exit(1)

    package_name = sys.argv[1]
    local_version_file = f"/home/{os.environ['USER']}/.local/bin/snapv/version/{package_name}.txt"

    url = f"https://api.snapcraft.io/api/v1/snaps/details/{package_name}"
    headers = {"X-Ubuntu-Series": "16"}

    try:
        if os.path.isfile(local_version_file):
            with open(local_version_file, 'r') as f:
                local_version = f.readline().strip()
                local_revision = f.readline().strip()
                
            response = requests.get(url, headers=headers)
            if response.status_code == 200:
                snap_details = response.json()
                upstream_version = snap_details.get('version', '')
                upstream_revision = snap_details.get('revision', '')
                
                print("Upstream version:", upstream_version)
                print("Upstream revision:", upstream_revision)
                print("Local version:", local_version)
                print("Local revision:", local_revision)
                
                if local_version == upstream_version and str(local_revision) == str(upstream_revision):
                    print("Local file is up to date.")
                else:
                   print(f"Local file is not up to date. New version exists. To upgrade Command: snap install {package_name} ")
            else:
                print(f"Error: Unable to fetch package details from upstream. Status code: {response.status_code}")
        else:
            print(f"Error: Local version file for {package_name} not found.")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()

