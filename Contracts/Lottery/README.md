# Lottery Solidity Contract
This contract allows an owner to deploy a lottery and collect 20% of the total amount once the lottery ends. Other users can purchase lottery tickets for a specified amount set by the owner, and once the maximum number of tickets has been purchased, no more tickets can be sold. The owner can end the lottery when a specified time limit has been reached, and a random winner will automatically be selected to receive the total amount.

## Getting Started

Solidity compiler is required to deploy the contract. You can use something like [Remix](https://remix.ethereum.org/)

- Open the `CrowdFunding.sol` file in your Solidity development environment
- Compile and deploy the contract.
- Interact with the contract using a web3 provider like Metamask or dummy Remix wallets.

## Contract Overview

### Purchasing Lottery Tickets
Once the contract is deployed, users can purchase lottery tickets by sending the specified amount of Ether to the contract's address. The owner can set the price of each ticket, and this amount will be deducted from the user's Ethereum wallet when they purchase a ticket. Once the maximum number of tickets has been sold, no more tickets can be purchased.

### Ending the Lottery
The owner can end the lottery once a specified time limit has been reached. Once the lottery is ended, a random winner will be selected and the total amount of Ether collected will be transferred to their Ethereum wallet automatically.

### Collecting the Owner's Fee
Once the lottery has ended and the winner has been selected, the owner will receive 20% of the total amount collected as their fee. This fee will be automatically transferred to the owner's Ethereum wallet.

### Conclusion
This Solidity contract provides a simple and secure way for owners to set up lotteries and for users to purchase tickets, with a random winner selection and automatic payment processing. It can be customized to fit the specific needs of different lotteries.