#!/bin/bash

function menu {
    echo
    echo -----------------------------------------------------------
    echo "Choose an option:"
    echo     " 1.  Update everything (Recommended per trading day)."
    echo     " 2.  Start all services and terminal."
    echo
    echo    " 31.  Run Flattrade websocket, API, app, and terminal."
    echo    " 42.  Run Shoonya websocket, API, app, and terminal."
    echo    " 53.  Run Dhan websocket, API, app, and terminal."
    echo
    echo    " 310.  Run Flattrade websocket, API, and app"
    echo    " 420.  Run Shoonya websocket, API, and app"
    echo    " 530.  Run Dhan websocket, API, and app"
    echo
    echo     " 0.  Exit"
    echo -----------------------------------------------------------
    read -p "Enter your choice : " choice
    echo -----------------------------------------------------------    
    echo
    case $choice in
    1) update ;;
    2) start_all ;;
    31) run_flattrade_open_link ;;
    42) run_shoonya_open_link ;;
    53) run_dhan_open_link ;;
    310) run_flattrade ;;
    420) run_shoonya ;;
    530) run_dhan ;;    
    6) exit 0 ;;
    *)
        echo "Invalid choice. Please try again."
        menu
        ;;
    esac
}

function update {
    # Update the entire monorepo
    echo "Updating steadfast-monorepo..."
    git stash
    git pull https://github.com/krishnasinghshahi/steadfast-monorepo || {
        echo "Error updating steadfast-monorepo."
        error
    }
    echo
    # Update steadfast-app
    echo "Updating steadfast-app..."
    cd steadfast-app || { echo "Directory steadfast-app not found."; error; }
    git stash
    git pull https://github.com/krishnasinghshahi/steadfast-app || {
        echo "Error updating steadfast-app."
        error
    }
    cd ..
    echo
    # Update steadfast-api
    echo "Updating steadfast-api..."
    cd steadfast-api || { echo "Directory steadfast-api not found."; error; }
    git stash
    git pull https://github.com/krishnasinghshahi/steadfast-api || {
        echo "Error updating steadfast-api."
        error
    }
    for FILE in "NFO_symbols.txt" "BFO_symbols.txt"; do
        if [ -f "$FILE" ]; then
            rm "$FILE"
        fi
    done
    URLS=(
        "https://images.dhan.co/api-data/api-scrip-master.csv"
        "https://flattrade.s3.ap-south-1.amazonaws.com/scripmaster/Bfo_Index_Derivatives.csv"
        "https://flattrade.s3.ap-south-1.amazonaws.com/scripmaster/Nfo_Index_Derivatives.csv"
        "https://api.shoonya.com/NFO_symbols.txt.zip"
        "https://api.shoonya.com/BFO_symbols.txt.zip"
    )
    
    for URL in "${URLS[@]}"; do
        FILE=$(basename "$URL")
        [ -f "$FILE" ] && rm "$FILE"
        echo
        echo "Downloading: $FILE"
        wget -q -O "$FILE" "$URL"
        echo "Saved: $FILE"
    done       
    cd ..
    echo
    # Update steadfast-websocket
    echo "Updating steadfast-websocket..."
    cd steadfast-websocket || { echo "Directory steadfast-websocket not found."; error; }
    git stash
    git pull https://github.com/krishnasinghshahi/steadfast-websocket || {
        echo "Error updating steadfast-websocket."
        error
    }
    cd ..
    echo
    echo "Update completed."
    menu
}

function run {
    # Start the API in a new terminal window
    echo "Starting API..."
    gnome-terminal -- bash -c "cd steadfast-api && sleep 2 && node server.js; exec bash" || { echo "Failed to start API."; error; }

    # Start the Flattrade websocket in a new terminal window
    echo "Starting Flattrade websocket..."
    gnome-terminal -- bash -c "cd steadfast-websocket/flattrade && python3 flattrade-websocket.py; exec bash" || { echo "Failed to start Flattrade websocket."; error; }

    # Start the Shoonya websocket in a new terminal window
    echo "Starting Shoonya websocket..."
    gnome-terminal -- bash -c "cd steadfast-websocket/shoonya && python3 shoonya-websocket.py; exec bash" || { echo "Failed to start Shoonya websocket."; error; }
    
    # Start the Dhan websocket in a new terminal window
    echo "Starting Dhan websocket..."
    gnome-terminal -- bash -c "cd steadfast-websocket/dhanhq && python3 dhan-websocket.py; exec bash" || { echo "Failed to start Dhan websocket."; error; }

    # Start the app in a new terminal window
    echo "Starting app..."
    gnome-terminal -- bash -c "cd steadfast-app && sleep 2 && npm run dev; exec bash" || { echo "Failed to start app."; error; }

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

    # Kill all python processes
    pkill -f python

    echo "All services stopped."
    menu
}

function error {
    echo "An error occurred. Returning to menu."
    menu
}

menu