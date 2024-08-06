@echo off
setlocal enabledelayedexpansion

:menu
echo -----------------------------------------------------------
echo Choose an option:
echo 1. Update everything (Recommended per trading day).
echo 2. Run all services and open terminal.
echo 31. Run Flattrade websocket, API, APP, and open terminal.
echo 42. Run Shoonya websocket, API, APP, and open terminal.
echo 53. Run Dhan websocket, API, APP, and open terminal.
echo 310. Run Flattrade websocket, API, and app.
echo 420. Run Shoonya websocket, API, and app.
echo 530. Run Dhan websocket, API, and app.
echo 0. Exit
echo -----------------------------------------------------------
set /p choice="Enter your choice: "
echo -----------------------------------------------------------
if "%choice%"=="1" goto update
if "%choice%"=="2" goto run_all
if "%choice%"=="31" goto run_flattrade_open_link
if "%choice%"=="42" goto run_shoonya_open_link
if "%choice%"=="53" goto run_dhan_open_link
if "%choice%"=="310" goto run_flattrade
if "%choice%"=="420" goto run_shoonya
if "%choice%"=="530" goto run_dhan
if "%choice%"=="0" goto end
echo Invalid choice. Please try again.
goto menu

:update
echo Updating steadfast-monorepo...
git stash
git pull https://github.com/krishnasinghshahi/steadfast-monorepo 
if !errorlevel! neq 0 (
    echo Error updating steadfast-monorepo.
    goto :error
)

echo Updating steadfast-app...
cd steadfast-app
git stash
git pull https://github.com/krishnasinghshahi/steadfast-app 
if !errorlevel! neq 0 (
    echo Error updating steadfast-app.
    goto :error
)
cd ..

echo Updating steadfast-api...
cd steadfast-api
git stash
git pull https://github.com/krishnasinghshahi/steadfast-api 
if !errorlevel! neq 0 (
    echo Error updating steadfast-api.
    goto :error
)
cd ..
echo.

echo Removing old files...
del /q NFO_symbols.txt BFO_symbols.txt

echo Downloading files...
set URLS[0]=https://images.dhan.co/api-data/api-scrip-master.csv
set URLS[1]=https://flattrade.s3.ap-south-1.amazonaws.com/scripmaster/Bfo_Index_Derivatives.csv
set URLS[2]=https://flattrade.s3.ap-south-1.amazonaws.com/scripmaster/Nfo_Index_Derivatives.csv
set URLS[3]=https://api.shoonya.com/NFO_symbols.txt.zip
set URLS[4]=https://api.shoonya.com/BFO_symbols.txt.zip

for /L %%i in (0,1,4) do (
    set URL=!URLS[%%i]!
    set FILE=%%~nxi
    if exist "!FILE!" del "!FILE!"
    echo Downloading: !FILE!
    wget -q -O "!FILE!" "!URL!"
    echo Saved: !FILE!
)
cd ..
cd ..
echo.

echo Updating steadfast-websocket...
cd steadfast-websocket
git stash
git pull https://github.com/krishnasinghshahi/steadfast-websocket 
if !errorlevel! neq 0 (
    echo Error updating steadfast-websocket.
    goto :error
)
cd ..

echo Update completedd.
goto menu

:run_all
echo Starting API...
start /min cmd /c "cd steadfast-api && node server.js"

echo Starting app...
start /min cmd /c "cd steadfast-app && npm run dev"

echo Starting Flattrade websocket...
start /min cmd /c "cd steadfast-websocket\flattrade && python flattrade-websocket.py"

echo Starting Shoonya websocket...
start /min cmd /c "cd steadfast-websocket\shoonya && python shoonya-websocket.py"

echo Starting Dhan websocket...
start /min cmd /c "cd steadfast-websocket\dhanhq && python dhan-websocket.py"

timeout /t 5

echo Opening browser to app's URL...
start http://localhost:5173

echo Services started and browsers opened. Close this window to stop all services.
echo Press any key to stop all services...
pause > nul

echo Stopping services...
taskkill /F /IM node.exe > nul 2>&1
taskkill /F /IM python.exe > nul 2>&1

echo All services stopped.
goto menu

:run_flattrade_open_link
echo Starting API...
start /min cmd /c "cd steadfast-api && node server.js"

echo Starting app...
start /min cmd /c "cd steadfast-app && npm run dev"

echo Starting Flattrade websocket...
start /min cmd /c "cd steadfast-websocket\flattrade && python flattrade-websocket.py"

timeout /t 5

echo Opening browser to app's URL...
start http://localhost:5173

echo Services started and browser opened. Close this window to stop all services.
echo Press any key to stop all services...
pause > nul

echo Stopping services...
taskkill /F /IM node.exe > nul 2>&1
taskkill /F /IM python.exe > nul 2>&1

echo All services stopped.
goto menu

:run_shoonya_open_link
echo Starting API...
start /min cmd /c "cd steadfast-api && node server.js"

echo Starting app...
start /min cmd /c "cd steadfast-app && npm run dev"

echo Starting Shoonya websocket...
start /min cmd /c "cd steadfast-websocket\shoonya && python shoonya-websocket.py"

timeout /t 5

echo Opening browser to app's URL...
start http://localhost:5173

echo Services started and browser opened. Close this window to stop all services.
echo Press any key to stop all services...
pause > nul

echo Stopping services...
taskkill /F /IM node.exe > nul 2>&1
taskkill /F /IM python.exe > nul 2>&1

echo All services stopped.
goto menu

:run_flattrade
echo Starting API...
start /min cmd /c "cd steadfast-api && node server.js"

echo Starting app...
start /min cmd /c "cd steadfast-app && npm run dev"

echo Starting Flattrade websocket...
start /min cmd /c "cd steadfast-websocket\flattrade && python flattrade-websocket.py"

timeout /t 5

echo Services started. Close this window to stop all services.
echo Press any key to stop all services...
pause > nul

echo Stopping services...
taskkill /F /IM node.exe > nul 2>&1
taskkill /F /IM python.exe > nul 2>&1

echo All services stopped.
goto menu

:run_shoonya
echo Starting API...
start /min cmd /c "cd steadfast-api && node server.js"

echo Starting app...
start /min cmd /c "cd steadfast-app && npm run dev"

echo Starting Shoonya websocket...
start /min cmd /c "cd steadfast-websocket\shoonya && python shoonya-websocket.py"

timeout /t 5

echo Services started. Close this window to stop all services.
echo Press any key to stop all services...
pause > nul

echo Stopping services...
taskkill /F /IM node.exe > nul 2>&1
taskkill /F /IM python.exe > nul 2>&1

echo All services stopped.
goto menu

:run_dhan_open_link
echo Starting API...
start /min cmd /c "cd steadfast-api && node server.js"

echo Starting app...
start /min cmd /c "cd steadfast-app && npm run dev"

echo Starting Dhan websocket...
start /min cmd /c "cd steadfast-websocket\dhanhq && python dhan-websocket.py"

timeout /t 5

echo Opening browser to app's URL...
start http://localhost:5173

echo Services started and browser opened. Close this window to stop all services.
echo Press any key to stop all services...
pause > nul

echo Stopping services...
taskkill /F /IM node.exe > nul 2>&1
taskkill /F /IM python.exe > nul 2>&1

echo All services stopped.
goto menu

:run_dhan
echo Starting API...
start /min cmd /c "cd steadfast-api && node server.js"

echo Starting app...
start /min cmd /c "cd steadfast-app && npm run dev"

echo Starting Dhan websocket...
start /min cmd /c "cd steadfast-websocket\dhanhq && python dhan-websocket.py"

timeout /t 5

echo Services started. Close this window to stop all services.
echo Press any key to stop all services...
pause > nul

echo Stopping services...
taskkill /F /IM node.exe > nul 2>&1
taskkill /F /IM python.exe > nul 2>&1

echo All services stopped.
goto menu

:end
endlocal
