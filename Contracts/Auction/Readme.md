# Auction Solidity Contract

An auction smart contract written in Solidity that allows users to upload new digital Art (Hash of uploaded Art) to the contract and user can let the Art available for auction. Other users can `bid for ongoing Art auction`. With every bid the contract keeps record of current highest bidder and current highest bid amount. The user who is willing to patriciate in the auction needs to send fund before hand to replace the previous highest bidder. If any new user comes with higher bid amount the previous bidder gets back his fund. This process will continue until the auction time is finished.

Once the auction is finished the `owner of the Art` can end bidding and the Art will instantly be delivered to the new owner and current owner will get the fund.
## Getting Started

Solidity compiler is required to deploy the contract. You can use something like [Remix](https://remix.ethereum.org/)

1. Open the `Auction.sol` file in your Solidity development environment
2. Compile and deploy the contract.
3. Interact with the contract using a web3 provider like Metamask or dummy Remix wallets.

## Contract Overview

The Auction contract consists of four main functions:

1. `newArt`: Upload new Art.

2. `startNewBid`: Owner of the Art can start bid/auction for his Art with specific time duration.

3. `makeBid`: Other users can bid for any ongoing auction. Bid amount needs to be at least 2 ETH more than previous highest bidder.

4. `endBid`: Owner of the Art can end auction of the ongoing Art after the auction duration is finished. The Art ownership will be transferred to the new owner and current owner will receive the bided amount.
