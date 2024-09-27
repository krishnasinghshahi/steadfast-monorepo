@echo off
setlocal enabledelayedexpansion

REM Check for required programs
where git >nul 2>&1 || (echo Git is not installed. && exit /b)
where npm >nul 2>&1 || (echo NPM is not installed. && exit /b)
where node >nul 2>&1 || (echo Node.js is not installed. && exit /b)
where python >nul 2>&1 || (echo Python is not installed. && exit /b)

:menu
echo Choose an option:
echo 1. Install/Update (Recommended once in a while)
echo 2. Run existing version
echo 3. Exit
set /p choice="Enter your choice (1, 2, or 3): "

if "%choice%"=="1" goto install
if "%choice%"=="2" goto run
if "%choice%"=="3" goto end
echo Invalid choice. Please try again.
goto menu

:install
REM Update the entire monorepo
echo Updating steadfast-monorepo...
git pull || (echo Failed to update steadfast-monorepo. && exit /b)

REM Clone the app repository and install dependencies
echo Checking app repository...
if not exist "steadfast-app\.git" (
    echo Cloning app...
    git clone https://github.com/krishnasinghshahi/steadfast-app.git
) 
cd steadfast-app || (echo Failed to change directory to steadfast-app. && exit /b)
echo Updating steadfast-app...
git pull || (echo Failed to update steadfast-app. && exit /b)
echo Installing app dependencies...
call npm install && call npm audit fix || (echo Failed to install app dependencies. && exit /b)
cd ..

REM Clone the API repository and install dependencies
echo Checking API repository...
if not exist "steadfast-api\.git" (
    echo Cloning API...
    git clone https://github.com/krishnasinghshahi/steadfast-api.git
) 
cd steadfast-api || (echo Failed to change directory to steadfast-api. && exit /b)
echo Updating steadfast-api...
git pull || (echo Failed to update steadfast-api. && exit /b)
echo Installing API dependencies...
call npm install && call npm audit fix || (echo Failed to install API dependencies. && exit /b)
cd ..

REM Clone the WebSocket repository and install dependencies
echo Checking WebSocket repository...
if not exist "steadfast-websocket\.git" (
    echo Cloning WebSocket...
    git clone https://github.com/krishnasinghshahi/steadfast-websocket.git
)
cd steadfast-websocket || (echo Failed to change directory to steadfast-websocket. && exit /b)
echo Updating steadfast-webSocket...
git pull || (echo Failed to update steadfast-websocket. && exit /b)

echo Installing WebSocket...

REM Install NorenRestApi without dependencies for Flattrade and Shoonya
echo Installing NorenRestApi for Flattrade and Shoonya...
pip install --no-deps NorenRestApi  || (echo Failed to install NorenRestApi. && exit /b)

echo Installing Flattrade dependencies...
cd flattrade || (echo Failed to change directory to flattrade. && exit /b)
pip install -r requirements.txt || (echo Failed to install Flattrade dependencies. && exit /b)
cd ..

echo Installing Shoonya dependencies...
cd shoonya || (echo Failed to change directory to shoonya. && exit /b)
pip install -r requirements.txt || (echo Failed to install Shoonya dependencies. && exit /b)
cd ..\..

echo Repositories and dependencies installed/updated successfully.
goto menu

:run
REM Start the API in a new command prompt window
echo Starting API...
start /min cmd /c "cd steadfast-api && node server.js"

REM Start the app in a new command prompt window
echo Starting app...
start /min cmd /c "cd steadfast-app && npm run dev"

REM Start the Flattrade websocket in a new command prompt window
echo Starting Flattrade websocket...
start /min cmd /c "cd steadfast-websocket\flattrade && python flattrade-websocket.py"

REM Start the Shoonya websocket in a new command prompt window
echo Starting Shoonya websocket...
start /min cmd /c "cd steadfast-websocket\shoonya && python shoonya-websocket.py"

REM Wait for a few seconds to allow the app to start
timeout /t 5

REM Open the default browser to the API's URL
echo Opening browser to API's URL...
start http://localhost:3000

REM Open the default browser to the app's URL
echo Opening browser to app's URL...
start http://localhost:5173

echo Services started and browsers opened. Close this window to stop all services.
echo Press any key to stop all services...
pause > nul

REM Kill all node processes
taskkill /F /IM node.exe > nul 2>&1

REM Kill all python processes
taskkill /F /IM python.exe > nul 2>&1

echo All services stopped.
goto menu

:end
echo Exiting the script. Goodbye!
endlocal
exit /b
