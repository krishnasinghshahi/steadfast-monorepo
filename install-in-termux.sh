#!/bin/bash

set -e

# Function to handle errors
function error {
    echo "An error occurred. Please check the output above for details."
    exit 1
}

# install necessary packages
echo "Updating package lists..."
pkg update || error

echo "Installing required packages..."
pkg install python python-pip python-pandas nodejs wget || error

# Function to clone a repository if it doesn't exist
function clone_repo {
    local repo_url=$1
    local repo_dir=$2

    echo "Checking $repo_dir repository..."
    if [ ! -d "$repo_dir/.git" ]; then
        echo "Cloning $repo_dir..."
        rm -rf $repo_dir  # Remove existing directory if it exists
        git clone $repo_url $repo_dir || error
    else
        echo "$repo_dir repository already exists, skipping clone..."
    fi
}

# Clone the app repository and install dependencies
clone_repo "https://github.com/krishnasinghshahi/steadfast-app.git" "steadfast-app"
cd steadfast-app
echo "Installing app dependencies..."
npm install || error
cd ..

# Clone the API repository and install dependencies
clone_repo "https://github.com/krishnasinghshahi/steadfast-api.git" "steadfast-api"
cd steadfast-api
echo "Installing API dependencies..."
npm install || error
cd ..

# Clone the WebSocket repository and install dependencies
clone_repo "https://github.com/krishnasinghshahi/steadfast-websocket.git" "steadfast-websocket"
cd steadfast-websocket

# Install NorenRestApi without dependencies
echo "Installing NorenRestApi..."
pip install --no-deps NorenRestApi || error

echo "Installing WebSocket dependencies..."
echo "Installing Flattrade dependencies..."
cd flattrade
pip install -r requirements.txt || error
cd ..

echo "Installing Shoonya dependencies..."
cd shoonya
pip install -r requirements.txt || error
cd ..

echo "Installing Dhanhq dependencies..."
cd dhanhq
pip install -r requirements.txt || error
cd ../.. 
echo "Repositories cloned and dependencies installed successfully."

# End of script