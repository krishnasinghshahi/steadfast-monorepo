# Project Overview

This repository is a monorepo containing three main projects:

1. [**steadfast-app**](https://github.com/krishnasinghshahi/steadfast-app): The frontend application.
2. [**steadfast-api**](https://github.com/krishnasinghshahi/steadfast-api): The backend API server.
3. [**steadfast-websocket**](https://github.com/krishnasinghshahi/steadfast-websocket): The WebSocket service.

### Quick Status (Updated: 26-07-2024)

Legend:
🟢 Available/Implemented
🟡 In Progress
🔵 Planned
⚡ Requested by our users
🔴 Not Currently Considered

| Feature                                      | Flattrade | Shoonya (Finvasia) | Dhan |
| -------------------------------------------- | --------- | ------------------ | ---- |
| **Trading Operations**                       |
| Buy/Sell at market price                     | 🟢        | 🟢                 | 🟢   |
| Place limit orders (dropdown menu)           | 🟢        | 🟢                 | 🟢   |
| Cancel orders                                | 🟢        | 🟢                 | 🟢   |
| Close all positions                          | 🟢        | 🟢                 | 🟢   |
| One-click trading buttons                    | 🟢        | 🟢                 | 🟢   |
| Live MTM / PNL                               | 🟢        | 🟢                 | 🟡   |
| Target price                                 | 🟢        | 🟢                 | 🟡   |
| Stoploss price                               | 🟢        | 🟢                 | 🟡   |
| Trailing Stoploss                            | 🔵        | 🔵                 | 🟡   |
| Underlying & Futures based Target & Stoploss | ⚡        | ⚡                 | ⚡   |
| **Order Management**                         |
| Kill switch (client-side)                    | 🟢        | 🟢                 | 🟢   |
| Select strikes                               | 🟢        | 🟢                 | 🟢   |
| Automatic ATM strike selection               | 🟢        | 🟢                 | 🟡   |
| **Real-Time Market Data**                    |
| LTP for underlying                           | 🟢        | 🟢                 | 🟡   |
| LTP for selected call/put strikes            | 🟢        | 🟢                 | 🟡   |

#### Note:

- kill switch works on client side only, you will still be able to trade from your broker terminal.
- All these symbols can be traded: NIFTY, BANKNIFTY, FINIFTY, MIDCPNIFTY NIFTYNXT50, SENSEX, BANKEX and SENSEX50.

# App Screenshots

## Manage Brokers

![Preview in Manage Brokers](preview_managebroker_light.png)

## Dark Mode

![Preview in Dark Mode](preview_dark.png)

## Add Broker

![Preview in Add Broker](preview_addbroker_light.png)

## Light Mode

![Preview in Light Mode](preview_light.png)

# Join Our Telegram Channel

Stay updated by joining our [Telegram Channel](https://t.me/steadfastapp).

## Steps to run the app

### `Step 0`: Prerequisites

Operating System: `Windows 11`

1. Ensure [Git](https://git-scm.com/download/win) is installed and accessible from the command line.

```
git --version
```

2. Ensure [Node.js v21.7.3 and npm v10.5.0](https://nodejs.org/en/download/prebuilt-installer) are installed and accessible from the command line.

```
node -v && npm -v
```

3. Ensure [Python](https://www.python.org/downloads/) is installed and accessible from the command line.

```
python -V
```

### `Step 1`: Clone the Steadfast Monorepo

1. Download & Install [GitHub Desktop](https://desktop.github.com/)
2. On top right of this repo click "Code" > "Open with GitHub Desktop"
3. Choose a local path and click "Clone"
4. Open the monorepo folder in file explorer.

### `Step 2`: Install

Double-click the `install-all.bat` file or run it from the command prompt.

#### What it does:

1. Clones the steadfast-app repository
2. Installs app dependencies
3. Clones the steadfast-api repository
4. Installs API dependencies
5. Clones the steadfast-websocket repository
6. Installs WebSocket dependencies

### `Step 3`: Start

Double-click the `start-all.bat` file or run it from the command prompt.

#### What it does:

1. Starts the steadfast-app at `localhost: 5173`
2. Starts the steadfast-api server at `localhost: 3000`
3. Starts the flattrade-websocket server at `localhost: 8765`
4. Starts the shoonya-websocket server at `localhost: 8766`

### `Step 4`: Stop

- To `Stop` simply close the opened command prompt windows.
- Or Press any key to stop the app, api and websocket.
