import os
import sys
import requests
import shutil
import subprocess

def write_to_file(file_path, content):
    with open(file_path, 'w') as f:
        f.write(content)

def download_snap(snap_url, package_name):
    # Create temporary directory
    temp_dir = f"/home/{os.environ['USER']}/.local/tmp/snap/{package_name}"
    if os.path.exists(temp_dir):
        shutil.rmtree(temp_dir)  # Remove existing directory
    os.makedirs(temp_dir, exist_ok=True)
    
    # Download snap file to temporary directory
    snap_file_path = os.path.join(temp_dir, f"{package_name}.snap")
    with open(snap_file_path, 'wb') as f:
        response = requests.get(snap_url)
        f.write(response.content)
    
    # Unsquash snap file
    unsquash_output_dir = os.path.join(temp_dir, "unsquashed")
    os.makedirs(unsquash_output_dir, exist_ok=True)
    subprocess.run(["unsquashfs", "-d", unsquash_output_dir, snap_file_path], check=True)
    
    return unsquash_output_dir

def main():
    # Check if package name is provided as an argument
    if len(sys.argv) != 2:
        print("Usage: python snap-find.py <package>")
        sys.exit(1)

    package = sys.argv[1]

    url = f"https://api.snapcraft.io/api/v1/snaps/details/{package}"

    headers = {
        "X-Ubuntu-Series": "16"  
    }

    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        snap_details = response.json()
        
        # Define directories for writing files
        base_dir = f"/home/{os.environ['USER']}/.local/bin/snapv"
        version_dir = os.path.join(base_dir, "version")
        desc_dir = os.path.join(base_dir, "desc")
        license_dir = os.path.join(base_dir, "license")
        snaps_dir = os.path.join(base_dir, "snaps")
        
        # Ensure directories exist
        for directory in [version_dir, desc_dir, license_dir, snaps_dir]:
            os.makedirs(directory, exist_ok=True)

        # Write version and revision to file
        version_file_path = os.path.join(version_dir, f"{package}.txt")
        write_to_file(version_file_path, f"{snap_details['version']}\n{snap_details['revision']}\n")
        
        # Write description to file
        desc_file_path = os.path.join(desc_dir, f"{package}.txt")
        write_to_file(desc_file_path, snap_details['description'])
        
        # Write package license to file
        license_file_path = os.path.join(license_dir, f"{package}.txt")
        write_to_file(license_file_path, snap_details['license'])
        
        # Download snap file and extract package binary directory
        download_url = snap_details['download_url']
        package_dir = download_snap(download_url, package)
        
        # Move the downloaded package to the specified directory
        destination_dir = os.path.join(snaps_dir, package)
        if os.path.exists(destination_dir):
            shutil.rmtree(destination_dir)  # Remove existing directory
        shutil.move(package_dir, destination_dir)
        
        # Print success message
        print(f"Snap {package} installed successfully!")
        
        # Remove the temporary folder for the package
        shutil.rmtree(f"/home/{os.environ['USER']}/.local/tmp/snap/{package}")

if __name__ == "__main__":
    main()

