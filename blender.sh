#!/bin/bash

# Function to clear the screen
function clear_screen {
    clear
}

# Function to display the header
function display_header {
    echo ""
    echo "-------------------------------------"
    echo "|          Blender Installer        |"
    echo "-------------------------------------"
    echo ""
}

# Function to prompt the user to select a version of Blender
function select_version {
    display_header
    echo "Please select a version of Blender to install:"
    echo ""
    echo "1) Latest version"
    echo "2) 3.0"
    echo "3) 2.93"
    echo "4) 2.92"
    echo "5) 2.91"
    echo "6) 2.90"
    echo "7) 2.83 LTS"
    echo "8) Custom version"
    echo ""
    read -p "Enter your choice [1-8]: " choice
    case $choice in
        1) version=$(curl -s https://www.blender.org/download/ | grep -oP 'href="https://download.blender.org/release/Blender[0-9\.]+/blender-[0-9\.]+-linux-x64.tar.xz"' | grep -oP '[0-9\.]+' | head -n 1);;
        2) version="3.0";;
        3) version="2.93";;
        4) version="2.92";;
        5) version="2.91";;
        6) version="2.90";;
        7) version="2.83.16";;
        8) read -p "Enter the version number (e.g., 2.93.4): " version;;
        *) echo "Invalid choice. Please try again." && select_version;;
    esac
}

# Function to install Blender
function install_blender {
    clear_screen
    display_header
    echo "Checking for dependencies..."
    echo ""
    # Check if dependencies are installed
    if ! dpkg -s wget curl libgl1-mesa-dev libxi6 libgconf-2-4 > /dev/null 2>&1; then
        echo "Some dependencies are missing."
        read -p "Do you want to install them? (y/n) " choice
        case $choice in
            y|Y)
                # Install missing dependencies
                sudo apt-get update
                sudo apt-get install -y wget curl libgl1-mesa-dev libxi6 libgconf-2-4
                ;;
            n|N)
                echo "Exiting Blender installation. Please install the missing dependencies and run this script again."
                exit 1
                ;;
            *)
                echo "Invalid choice. Please run this script again to install Blender."
                exit 1
                ;;
        esac
    fi
    clear_screen
    display_header
    echo "Installing Blender version $version ..."
    echo ""
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
    echo ""
    echo "Blender version $version has been installed successfully!"
}
