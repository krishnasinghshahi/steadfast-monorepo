#!/bin/bash

# Function to detect available terminal emulator
function detect_terminal {
    if command -v gnome-terminal &> /dev/null; then
        echo "gnome-terminal"
    elif command -v xterm &> /dev/null; then
        echo "xterm"
    elif command -v konsole &> /dev/null; then
        echo "konsole"
    elif command -v xfce4-terminal &> /dev/null; then
        echo "xfce4-terminal"
    elif command -v lxterminal &> /dev/null; then
        echo "lxterminal"
    else
        echo ""
    fi
}

# Function to open a new terminal and execute the command
function open_terminal {
    local terminal=$(detect_terminal)
    
    if [ -z "$terminal" ]; then
        echo "No supported terminal emulator found."
        return 1
    fi

    # Start command execution based on detected terminal
    case "$terminal" in
        gnome-terminal)
            gnome-terminal -- bash -c "$1; exec bash"
            ;;
        xterm)
            xterm -hold -e "$1"
            ;;
        konsole)
            konsole --hold -e "$1"
            ;;
        xfce4-terminal)
            xfce4-terminal --hold --command="$1"
            ;;
        lxterminal)
            lxterminal -e "$1"
            ;;
        *)
            echo "Could not open a terminal."
            return 1
            ;;
    esac
}

# Ensure npm and pip/pip3 are installed
function check_prerequisites {
    if ! command -v npm &> /dev/null; then
        echo "npm is not installed. Please install npm first."
        exit 1
    fi
    
    if ! command -v pip &> /dev/null && ! command -v pip3 &> /dev/null; then
        echo "Neither pip nor pip3 is installed. Please install pip or pip3."
        exit 1
    fi
}

function menu {
    echo "Choose an option:"
    echo "1. Install/Update (Recommended once in a while)"
    echo "2. Run existing version"
    echo "3. Exit"
    read -p "Enter your choice (1, 2, or 3): " choice

    case "$choice" in
    1) install ;;
    2) run ;;
    3) exit 0 ;;
    *)
        echo "Invalid choice. Please try again."
        menu
        ;;
    esac
}

function install {
    check_prerequisites

    echo "Updating steadfast-monorepo..."
    git -C ./ pull || {
        echo "Error updating steadfast-monorepo."
        menu
    }

    # Clone and install app dependencies
    echo "Checking app repository..."
    if [ ! -d "steadfast-app/.git" ]; then
        git clone https://github.com/krishnasinghshahi/steadfast-app.git
    fi
    cd steadfast-app || { echo "Failed to enter steadfast-app directory."; menu; }
    git pull && npm install && npm audit fix || { echo "Error occurred with steadfast-app."; cd ..; menu; }
    cd ..

    # Clone and install API dependencies
    echo "Checking API repository..."
    if [ ! -d "steadfast-api/.git" ]; then
        git clone https://github.com/krishnasinghshahi/steadfast-api.git
    fi
    cd steadfast-api || { echo "Failed to enter steadfast-api directory."; menu; }
    git pull && npm install && npm audit fix || { echo "Error occurred with steadfast-api."; cd ..; menu; }
    cd ..

    # Clone and install WebSocket dependencies
    echo "Checking WebSocket repository..."
    if [ ! -d "steadfast-websocket/.git" ]; then
        git clone https://github.com/krishnasinghshahi/steadfast-websocket.git
    fi
    cd steadfast-websocket || { echo "Failed to enter steadfast-websocket directory."; menu; }
    git pull || { echo "Error updating steadfast-websocket."; cd ..; menu; }

    # Install NorenRestApi without dependencies for Flattrade and Shoonya
    echo "Installing NorenRestApi for Flattrade and Shoonya..."
    pip install --no-deps NorenRestApi || pip install --break-system-packages --no-deps NorenRestApi || pip3 install --no-deps NorenRestApi || pip3 install --break-system-packages --no-deps NorenRestApi || {
        echo "Error occurred while installing NorenRestApi."
        cd ..
        menu
    }

    # Install Flattrade dependencies
    cd flattrade || { echo "Failed to enter flattrade directory."; cd ..; menu; }
    pip install -r requirements.txt || pip install --break-system-packages -r requirements.txt || pip3 install -r requirements.txt || pip3 install --break-system-packages -r requirements.txt || {
        echo "Error occurred while installing dependencies for Flattrade."
        cd ../..
        menu
    }
    cd ..

    # Install Shoonya dependencies
    cd shoonya || { echo "Failed to enter shoonya directory."; cd ..; menu; }
    pip install -r requirements.txt || pip install --break-system-packages -r requirements.txt || pip3 install -r requirements.txt || pip3 install --break-system-packages -r requirements.txt || {
        echo "Error occurred while installing dependencies for Shoonya."
        cd ../..
        menu
    }
    cd ../..

    echo "Repositories and dependencies installed/updated successfully."
    menu
}

function run {
    # Start the API in a new terminal window and store its PID
    echo "Starting API..."
    open_terminal "cd steadfast-api && node server.js"
    
    # Start the app in a new terminal window and store its PID
    echo "Starting app..."
    open_terminal "cd steadfast-app && npm run dev" 

    # Start the Flattrade websocket in a new terminal window and store its PID
    echo "Starting Flattrade websocket..."
    open_terminal "cd steadfast-websocket/flattrade && python flattrade-websocket.py || python3 flattrade-websocket.py"

    # Start the Shoonya websocket in a new terminal window and store its PID
    echo "Starting Shoonya websocket..."
    open_terminal "cd steadfast-websocket/shoonya && python shoonya-websocket.py || python3 shoonya-websocket.py" 
    
    # Wait for a few seconds to allow the app to start
    sleep 5
    
    # Open the default browser to the API's URL
    echo "Opening browser to API's URL..."
    xdg-open http://localhost:3000
    
    # Open the default browser to the app's URL
    echo "Opening browser to app's URL..."
    xdg-open http://localhost:5173
    
    echo "Services started and browsers opened. Close this window to stop all services."
    read -n 1 -s -r -p "Press any key to stop all services..."
    
    # Kill all node processes
    pkill -f node

    # Kill all node processes
    pkill -f npm

    # Kill all python processes
    pkill -f python

    echo "All services stopped."
    menu
}

menu
