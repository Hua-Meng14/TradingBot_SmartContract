# TradingBot_SmartContract

This Solidity smart contract, named `TradingBot`, is designed to facilitate the creation, management, and trading of algorithmic trading bots on the Ethereum blockchain. The contract provides functionality for creating, updating, buying, and selling trading bots, allowing users to engage in the decentralized trading bot marketplace.

## Features

### Bot Struct
The contract defines a `Bot` struct, which encapsulates the essential attributes of a trading bot, including display name, Binance credentials, image, description, Docker information, ownership details, pricing, timestamp, and sale status.

### Bot Management
- **Bot Creation**: Users can create new trading bots by providing necessary details such as display name, Binance credentials, image, description, Docker information, etc.
- **Bot Update**: Owners of bots can update their bot details, including display name, image, description, Docker information, and Binance credentials.

### Trading Operations
- **Buy Trading Bot**: Users can purchase trading bots from the marketplace, with the contract handling the transfer of ownership and financial transactions. A percentage of the transaction goes to the contract manager and the bot creator.
- **Sell Bot**: Owners can put their bots up for sale by specifying a sale price. The bot becomes available for purchase by other users.
- **Check Balance**: Users can check the balance of their account.

### Marketplace Information
- **Get All Sales**: Retrieve a list of all bots available for sale.
- **Get All Bots by Owner**: Get a list of all bots owned by a specific address.
- **Get All Sale Bots**: Retrieve a list of all bots currently available for sale.
- **Get All Sale Bots by Owner**: Get a list of all bots for sale owned by a specific address.
- **Get All Bots by Creator**: Retrieve a list of all bots created by a specific address.

## Usage

1. **Deployment**: Deploy the smart contract to the Ethereum blockchain.
2. **Bot Creation**: Users can create their trading bots by calling the `createBot` function.
3. **Bot Update**: Owners can update their bot details using the `updateBot` function.
4. **Buying Bots**: Users can purchase available bots using the `buyTradingBotById` function.
5. **Selling Bots**: Owners can put their bots up for sale with the `sellBot` function.
6. **Marketplace Information**: Retrieve information about available bots and ownership using various `getAll*` functions.

## Security

- The contract includes modifiers such as `onlyManager` and `onlyOwner` to ensure that certain functions can only be executed by authorized addresses.
- Financial transactions are handled carefully to prevent errors and ensure secure fund transfers.
