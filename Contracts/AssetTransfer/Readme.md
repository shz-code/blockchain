# Asset Transfer Contract

A simple asset transfer smart contract written in Solidity that allows users sell digital assets that he owns. The contracts allows users to `transfer ownership`, `receive asset fee`, `see current owner of the contract` and `buy the contract` if the current owner wants to sell the asset.

## Getting Started

Solidity compiler is required to deploy the contract. You can use something like [Remix](https://remix.ethereum.org/)

1. Open the `AssetTransfer.sol` file in your Solidity development environment
2. Compile and deploy the contract.
3. Interact with the contract using a web3 provider like Metamask or dummy Remix wallets.

## Contract Overview

The crowd funding contract consists of four main functions:

1. When the contract is created the owner, asset name and fee is set.

2. `owner`: Allows a user to donate to view current owner of the contract.

3. `fee`: Allows a user to donate to view current fee of the contract

4. `prepareFundTransfer`: Allows the owner to prepare the contract to be transferable by setting the **fund sender** address.

5. `sendFund`: Allows the buyer to send required fund to buy the asset. Only the user that was set by the owner can send fund and instantly the ownership is transferred to the buyer.

6. `transferOwnership`: The ownership gets transferred immediately after sending the fund. All the states again set to default.