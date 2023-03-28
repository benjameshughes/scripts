#!/bin/bash

# Set Blender version or get the latest
if [ -z "$1" ]
  then
    # Get latest Blender version
    version=$(curl -s https://www.blender.org/download/ | grep -Po 'Stable release \K([0-9]\.[0-9]{2}\.[0-9])' | head -n 1)
  else
    # Use specified Blender version
    version="$1"
fi

# Update package index
sudo apt update

# Install dependencies
sudo apt install -y wget curl libgl1-mesa-dev libxi6 libgconf-2-4

# Download Blender
wget https://download.blender.org/release/Blender$version/blender-$version-linux-x64.tar.xz

# Extract Blender archive
tar -xvf blender-$version-linux-x64.tar.xz

# Move Blender to /opt directory
sudo mv blender-$version-linux-x64 /opt/blender

# Create symbolic link to Blender executable
sudo ln -s /opt/blender/blender /usr/local/bin/blender

# Clean up downloaded files
rm blender-$version-linux-x64.tar.xz
