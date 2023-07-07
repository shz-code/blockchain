// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract AssetTransfer {
    address public owner; // To keep record of owner
    string public assetName; // Naem of asset
    uint public fee; // Asset value
    
    uint private fund; // Buyer send amount
    address private fundSender; // Buyer wallet address
    bool private locked; // Ready to purchase state

    // Initialize contract with owner, asset name and asset fee
    constructor(string memory _assetName,uint _fee) {
        owner = msg.sender;
        assetName = _assetName;
        fee = _fee*1e18;
    }

    // Update asset function. Only accessable by contract owner
    function assetUpdate(uint _fee) public {
        require(msg.sender == owner, "Only owner modify asset");
        require(fund == 0 && !locked, "Cannot modify new now");
        fee = _fee*1e18;
    }

    // Owner prepares the contract to be able to receive fund from the buyer
    function prepareFundTransfer(address _fundSenderAddress) public {
        require(msg.sender == owner, "Only owner can allow fund tranfer");
        fundSender = _fundSenderAddress;
        locked = true;
    }

    // Transfers ownership of the contract once the fund transfer is finished by the buyer and the fund is send to the former owner
    function transferOwnership() private {
        payable(owner).transfer(address(this).balance);
        owner = fundSender;
        fund = 0;
        fundSender = address(0);
        locked = false;
    }

    // Buyer sends fund to the contract and gets the owner ship instantly
    function sendFund() public payable {
        require(msg.sender == fundSender, "You are not allowed to send fund");
        require(msg.value == fee, "Does not match with asset fee");

        fund = msg.value;
        transferOwnership();
    }
}