# Crowdfunding Solidity Contract

A simple crowdfunding smart contract written in Solidity that allows users to create and contribute to crowdfunding events. The contracts allows users to `donate to the campaign`, `see all of their previous donations`, `see their current donation amount` and `withdraw their donation amount` if they wish. As a owner of the contact the `owner can withdraw total donation any time` but that does not change the target or total donation.

## Getting Started

Solidity compiler is required to deploy the contract. You can use something like [Remix]()

1. Open the `CrowdFunding.sol` file in your Solidity development environment
2. Compile and deploy the contract.
3. Interact with the contract using a web3 provider like Metamask or dummy Remix wallets.

## Contract Overview

The crowd funding contract consists of four main functions:

1. When the contract is created the owner and target of the campaign is set.

2. `donate`: Allows a user to donate to the contract by sending ETH tokens to the contract. The function checks if the target is already fulfilled or not. If no than it receives the fund and update related data otherwise it refunds the amount to the user. Once the target is fulfilled the contract is locked.

3. `ownerWithdraw`: Allows the owner to withdraw the funds anytime but that does not change the target or total donation.

4. `refund`: Allows contributors to withdraw their contributions if the funding goal is not reached at that time. The function checks that the campaign is locked and that the contribution is greater than zero.

5. `viewDonationAmount`: Allows contributors to view total fund they have donated.

5. `donationHistory`: Allows contributors to view all the donation history over the time. It keeps records of new donations and refunds.