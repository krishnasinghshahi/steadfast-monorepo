@echo off
setlocal enabledelayedexpansion

:menu
echo Choose an option:
echo 1. Update the everything (monorepo, app, api, websocket) (Recommended once a day)
echo 2. Run existing version
echo 3. Exit
set /p choice="Enter your choice (1, 2, or 3): "

if "%choice%"=="1" goto update
if "%choice%"=="2" goto run
if "%choice%"=="3" goto end
echo Invalid choice. Please try again.
goto menu

:update
REM Update the entire monorepo
echo Updating steadfast-monorepo...
git pull https://github.com/krishnasinghshahi/steadfast-monorepo main
if !errorlevel! neq 0 (
    echo Error updating steadfast-monorepo.
    goto :error
)

REM Update steadfast-app
echo Updating steadfast-app...
cd steadfast-app
git pull https://github.com/krishnasinghshahi/steadfast-app main
if !errorlevel! neq 0 (
    echo Error updating steadfast-app.
    goto :error
)
cd ..

REM Update steadfast-api
echo Updating steadfast-api...
cd steadfast-api
git pull https://github.com/krishnasinghshahi/steadfast-api main
if !errorlevel! neq 0 (
    echo Error updating steadfast-api.
    goto :error
)
cd ..

REM Update steadfast-websocket
echo Updating steadfast-websocket...
cd steadfast-websocket
git pull https://github.com/krishnasinghshahi/steadfast-websocket main
if !errorlevel! neq 0 (
    echo Error updating steadfast-websocket.
    goto :error
)
cd ..

echo Update complete.
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

REM Start the Dhan websocket in a new command prompt window
echo Starting Dhan websocket...
start /min cmd /c "cd steadfast-websocket\dhanhq && python dhan-websocket.py"

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
endlocal
