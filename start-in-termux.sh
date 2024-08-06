#!/bin/bash

# Global variable to track the tmux session
SESSION_NAME="services"

function menu {
    echo
    echo -----------------------------------------------------------
    echo "Choose an option:"
    echo     " 1.  Update"
    echo     " 2.  Start all services and terminal"
    echo
    echo    " 31.  Run Flattrade websocket, API, app, and terminal."
    echo    " 42.  Run Shoonya websocket, API, app, and terminal."
    echo    " 53.  Run Dhan websocket, API, app, and terminal."
    echo
    echo    " 310.  Run Flattrade websocket, API, and app"
    echo    " 420.  Run Shoonya websocket, API, and app"
    echo    " 530.  Run Dhan websocket, API, and app"
    echo
    echo     " 6.  Exit"
    echo -----------------------------------------------------------
    echo

    read -p "Enter your choice : " choice
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
    echo "Updating steadfast-monorepo..."
    git stash
    git pull https://github.com/krishnasinghshahi/steadfast-monorepo || {
        echo "Error updating steadfast-monorepo."
        error
    }

    echo "Updating steadfast-app..."
    cd steadfast-app || { echo "Directory steadfast-app not found."; error; }
    git stash
    git pull https://github.com/krishnasinghshahi/steadfast-app || {
        echo "Error updating steadfast-app."
        error
    }
    cd ..

    echo "Updating steadfast-api..."
    cd steadfast-api || { echo "Directory steadfast-api not found."; error; }
    git stash
    git pull https://github.com/krishnasinghshahi/steadfast-api || {
        echo "Error updating steadfast-api."
        error
    }
    cd ..

    echo "Updating steadfast-websocket..."
    cd steadfast-websocket || { echo "Directory steadfast-websocket not found."; error; }
    git stash
    git pull https://github.com/krishnasinghshahi/steadfast-websocket || {
        echo "Error updating steadfast-websocket."
        error
    }
    cd ..

    echo "Update complete."
    menu
}

function start_tmux_session {
    tmux new-session -d -s "$SESSION_NAME"
}

function start_api {
    tmux new-window -t "$SESSION_NAME" -n "API" "cd steadfast-api && sleep 2 && node server.js"
}

function start_app {
    tmux new-window -t "$SESSION_NAME" -n "App" "cd steadfast-app && sleep 2 && npm run dev"
}

function start_websockets {
    tmux new-window -t "$SESSION_NAME" -n "Websocket" "cd steadfast-websocket/flattrade && python3 flattrade-websocket.py"
    tmux split-window -t "$SESSION_NAME:Websocket" "cd steadfast-websocket/shoonya && python3 shoonya-websocket.py"
    tmux split-window -t "$SESSION_NAME:Websocket" "cd steadfast-websocket/dhanhq && python3 dhan-websocket.py"
}

function start_all {
    echo "Starting all services..."
    start_tmux_session
    start_websockets
    start_api
    start_app

    echo "Waiting for services to start..."
    sleep 5

    echo "Opening browser to app's URL..."
    xdg-open http://localhost:5173

    echo "All services started and browsers opened."
    echo "Press Ctrl+C in this terminal or any other terminal to stop all services."

    # Handle Ctrl+C to clean up and return to menu
    trap 'stop_services; exit 0' INT

    # Attach to the tmux session
    tmux attach-session -t "$SESSION_NAME"
}

function run_flattrade_open_link {
    echo "Starting Flattrade websocket..."
    start_tmux_session
    tmux new-window -t "$SESSION_NAME" -n "Flattrade" "cd steadfast-websocket/flattrade && python3 flattrade-websocket.py"
    
    start_api
    start_app

    echo "Flattrade, API, and app started."
    echo "Waiting for services to start..."
    sleep 5

    echo "Opening browser to app's URL..."
    xdg-open http://localhost:5173

    echo "Services started and browsers opened."
    echo "Press Ctrl+C in this terminal or any other terminal to stop all services."

    # Handle Ctrl+C to clean up and return to menu
    trap 'stop_services; exit 0' INT

    # Attach to the tmux session
    tmux attach-session -t "$SESSION_NAME"
}

function run_flattrade {
    echo "Starting Flattrade websocket..."
    start_tmux_session
    tmux new-window -t "$SESSION_NAME" -n "Flattrade" "cd steadfast-websocket/flattrade && python3 flattrade-websocket.py"
    
    start_api
    start_app

    echo "Flattrade, API, and app started."
    echo "Waiting for services to start..."
    sleep 5

    echo "Services started."
    echo "Press Ctrl+C in this terminal or any other terminal to stop all services."

    # Handle Ctrl+C to clean up and return to menu
    trap 'stop_services; exit 0' INT

    # Attach to the tmux session
    tmux attach-session -t "$SESSION_NAME"
}

function run_shoonya_open_link {
    echo "Starting Shoonya websocket..."
    start_tmux_session
    tmux new-window -t "$SESSION_NAME" -n "Shoonya" "cd steadfast-websocket/shoonya && python3 shoonya-websocket.py"
    
    start_api
    start_app

    echo "Shoonya, API, and app started."
    echo "Waiting for services to start..."
    sleep 5

    echo "Opening browser to app's URL..."
    xdg-open http://localhost:5173

    echo "Services started and browsers opened."
    echo "Press Ctrl+C in this terminal or any other terminal to stop all services."

    # Handle Ctrl+C to clean up and return to menu
    trap 'stop_services; exit 0' INT

    # Attach to the tmux session
    tmux attach-session -t "$SESSION_NAME"
}

function run_shoonya {
    echo "Starting Shoonya websocket..."
    start_tmux_session
    tmux new-window -t "$SESSION_NAME" -n "Shoonya" "cd steadfast-websocket/shoonya && python3 shoonya-websocket.py"
    
    start_api
    start_app

    echo "Shoonya, API, and app started."
    echo "Waiting for services to start..."
    sleep 5

    echo "Services started."
    echo "Press Ctrl+C in this terminal or any other terminal to stop all services."

    # Handle Ctrl+C to clean up and return to menu
    trap 'stop_services; exit 0' INT

    # Attach to the tmux session
    tmux attach-session -t "$SESSION_NAME"
}

function run_dhan_open_link {
    echo "Starting Dhan websocket..."
    start_tmux_session
    tmux new-window -t "$SESSION_NAME" -n "Dhan" "cd steadfast-websocket/dhanhq && python3 dhan-websocket.py"
    
    start_api
    start_app

    echo "Dhan, API, and app started."
    echo "Waiting for services to start..."
    sleep 5

    echo "Opening browser to app's URL..."
    xdg-open http://localhost:5173

    echo "Services started and browsers opened."
    echo "Press Ctrl+C in this terminal or any other terminal to stop all services."

    # Handle Ctrl+C to clean up and return to menu
    trap 'stop_services; exit 0' INT

    # Attach to the tmux session
    tmux attach-session -t "$SESSION_NAME"
}

function run_dhan {
    echo "Starting Dhan websocket..."
    start_tmux_session
    tmux new-window -t "$SESSION_NAME" -n "Dhan" "cd steadfast-websocket/dhanhq && python3 dhan-websocket.py"
    
    start_api
    start_app

    echo "Dhan, API, and app started."
    echo "Waiting for services to start..."
    sleep 5

    echo "Services started."
    echo "Press Ctrl+C in this terminal or any other terminal to stop all services."

    # Handle Ctrl+C to clean up and return to menu
    trap 'stop_services; exit 0' INT

    # Attach to the tmux session
    tmux attach-session -t "$SESSION_NAME"
}

function stop_services {
    echo "Stopping all services..."
    tmux kill-session -t "$SESSION_NAME" 2>/dev/null
    echo "All services stopped."
    clear
    menu
}

function error {
    echo "An error occurred. Returning to menu."
    menu
}

menu
