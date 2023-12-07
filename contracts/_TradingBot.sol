// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.17;

// pragma experimental ABIEncoderV2;

contract TradingBot {
    address payable public manager;
    struct Bot {
        uint256 id;
        string displayName;
        string binanceCredentialID;
        string image;
        string description;
        string dockerImageID;
        string dockerContainerID;
        address payable OwnerAddress;
        address payable CreatorAddress;
        uint256 price;
        uint256 timeStamp;
        bool isSaleBot;
    }

    mapping(uint256 => Bot) public Bots;

    event CreateTradingBot(
        uint256 id,
        string displayName,
        string binanceCredentialID,
        string image,
        string description,
        string dockerImageID,
        string dockerContainerID,
        address payable OwnerAddress,
        address payable CreatorAddress,
        uint256 price,
        uint256 timeStamp,
        bool isSaleBot
    );
    event UpdateTradingBot(
        uint256 id,
        string displayName,
        string new_image,
        string new_description,
        string new_containerID,
        string new_binanceCredentialID
    );
    event BuyTradingBot(uint256 id);

    constructor() {
        manager = payable(msg.sender);
    }

    modifier onlyManager() {
        require(msg.sender == manager, "Not Manager");
        _;
    }

    modifier onlyOwner(uint256 id) {
        require(
            Bots[id].OwnerAddress == msg.sender,
            "Only owner can use this function"
        );
        _;
    }
    uint256 public nextTradingBotId = 1;
    uint256 public botCount = 0;

    function getBotById(uint256 id) public view returns (Bot memory) {
        return Bots[id];
    }

    //create new Bot and add to Bots mapping and add checkIfcreater() modifier
    function createBot(
        string memory _displayName,
        string memory _binanceCredentialID,
        string memory _image,
        string memory _description,
        string memory _dockerImageID,
        string memory _dockerContainerID
    ) public {
        Bot storage bot = Bots[botCount];
        bot.id = nextTradingBotId;
        bot.displayName = _displayName;
        bot.binanceCredentialID = _binanceCredentialID;
        bot.image = _image;
        bot.description = _description;
        bot.dockerImageID = _dockerImageID;
        bot.dockerContainerID = _dockerContainerID;
        bot.CreatorAddress = payable(msg.sender);
        bot.OwnerAddress = payable(msg.sender);
        bot.price = 0;
        bot.timeStamp = block.timestamp;
        bot.isSaleBot = false;

        emit CreateTradingBot(
            botCount,
            _displayName,
            _binanceCredentialID,
            _image,
            _description,
            _dockerImageID,
            _dockerContainerID,
            payable(msg.sender),
            payable(msg.sender),
            0,
            block.timestamp,
            false
        );
        nextTradingBotId++;
        botCount++;
    }

    function updateBot(
        uint256 _id,
        string memory new_displayName,
        string memory new_image,
        string memory new_description,
        string memory new_containerID,
        string memory new_binanceCredentialID
    ) public onlyOwner(_id) {
        Bot storage upDateBot = Bots[_id];
        upDateBot.displayName = new_displayName;
        upDateBot.image = new_image;
        upDateBot.description = new_description;
        upDateBot.dockerContainerID = new_containerID;
        upDateBot.binanceCredentialID = new_binanceCredentialID;

        emit UpdateTradingBot(
            _id,
            new_displayName,
            new_image,
            new_description,
            new_containerID,
            new_binanceCredentialID
        );
    }

    function buyTradingBotById(
        uint256 id,
        string memory new_dockerContainerID,
        string memory new_binanceCredentialID
    ) public payable {
        require(Bots[id].isSaleBot == true, "This Bot is not for sale.");
        require(
            msg.sender != Bots[id].OwnerAddress,
            "You already owned this Trading Bot"
        );
        uint256 price = Bots[id].price;
        address payable buyer = payable(msg.sender);
        address payable seller = Bots[id].OwnerAddress;
        address payable creator = Bots[id].CreatorAddress;
        uint256 senderBalance = buyer.balance;
        uint256 receiverBalance = buyer.balance;

        require(senderBalance >= price, "Insufficient Balance");
        require(
            receiverBalance + price >= receiverBalance,
            "Payment is not successfull"
        );
        require(
            msg.value == price,
            "Invalid Payment. Payment must be same price"
        );
        uint256 totalPrice = msg.value;
        uint256 managerCost = (totalPrice * 3) / 100;
        uint256 creatorCost = (totalPrice * 1) / 100;
        uint256 sellerCost = totalPrice - (managerCost + creatorCost);

        // seller.transfer(msg.value);
        manager.transfer(managerCost);
        creator.transfer(creatorCost);
        seller.transfer(sellerCost);
        Bots[id].OwnerAddress = buyer;
        Bots[id].isSaleBot = false;
        Bots[id].price = 0;
        Bots[id].dockerContainerID = new_dockerContainerID;
        Bots[id].binanceCredentialID = new_binanceCredentialID;

        emit BuyTradingBot(id);
    }

    function checkBalance(address account) public view returns (uint256) {
        return (account.balance);
    }

    function sellBot(uint256 Id, uint256 _price) public onlyOwner(Id) {
        Bot storage botTosell = Bots[Id];
        botTosell.isSaleBot = true;
        botTosell.price = _price;
    }

    //return all bots from saleBot mapping
    function getAllSales() public view returns (uint256[] memory) {
        uint256[] memory saleBots = new uint256[](botCount);
        uint256 i = 0;
        for (uint256 id = 0; id < botCount; id++) {
            if (Bots[id].isSaleBot == true) {
                saleBots[i] = id;
                i++;
            }
        }
        return saleBots;
    }

    //return all bots from Bots mapping which has the owner of specific address
    function getAllBotsByOwner(
        address _owner
    ) public view returns (uint256[] memory) {
        uint256[] memory botsByOwner = new uint256[](botCount);
        uint256 i = 0;
        for (uint256 id = 0; id < botCount; id++) {
            if (Bots[id].OwnerAddress == _owner) {
                botsByOwner[i] = id;
                i++;
            }
        }
        return botsByOwner;
    }

    //return all sale bot
    function getAllSaleBots() public view returns (uint256[] memory) {
        uint256[] memory saleBots = new uint256[](botCount);
        uint256 i = 0;
        for (uint256 id = 0; id < botCount; id++) {
            if (Bots[id].isSaleBot == true) {
                saleBots[i] = id;
                i++;
            }
        }
        return saleBots;
    }

    //get all sale bot by address
    function getAllSaleBotsByOwner(
        address _owner
    ) public view returns (uint256[] memory) {
        uint256[] memory saleBotsByOwner = new uint256[](botCount);
        uint256 i = 0;
        for (uint256 id = 0; id < botCount; id++) {
            if (Bots[id].isSaleBot == true && Bots[id].OwnerAddress == _owner) {
                saleBotsByOwner[i] = id;
                i++;
            }
        }
        return saleBotsByOwner;
    }

    //get all bot by creator address
    function getAllBotsByCreator(
        address _creator
    ) public view returns (uint256[] memory) {
        uint256[] memory botsByCreator = new uint256[](botCount);
        uint256 i = 0;
        for (uint256 id = 0; id < botCount; id++) {
            if (Bots[id].CreatorAddress == _creator) {
                botsByCreator[i] = id;
                i++;
            }
        }
        return botsByCreator;
    }
}