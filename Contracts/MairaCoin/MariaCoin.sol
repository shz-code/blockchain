/**
 * @title MariaCoin - Ethereum Token implementation based on ERC20 standard
 * 
 */

// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;


import {ERC20} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

/**
 * @dev other functions:
 *      approve -> Approve another user to spend token on behalf of callers wallet.
 *      transfer -> Send token to other user
 *      transferFrom -> Transfer fund from allowed wallet to other's wallet. Allowance is reduced from caller.
 *      allowance ->  Amount of token left for the spender to spend from allowed user's wallet
 *      balanceOf -> Returns amount of tokens owned by provided wallet address
 *      name -> Name of token (MariaCoin)
 *      symbol -> Symbol of token (MRC)
 *      totalSupply -> Total available tokens in Contract (Initial + Minted)
 */     
contract MariaCoin is ERC20 {
    address internal owner;
    /**
     * 
     * @param initialSupply Initial Supply of tokens
     */
    constructor(uint256 initialSupply) ERC20("MariaCoin", "MRC") {
        _mint(msg.sender, initialSupply*1e18);
        owner = msg.sender;
    }

    /**
     * 
     * @param to for whom token should be minted.
     * @notice only owner allowed to access
     * @param amount Amount of token to mint
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount*1e18);
    }

    /**
     * Only Owner allowed to interact 
     */
    modifier onlyOwner() {
        require(msg.sender == owner,"Only Owner Allowed");
        _;
    }

}
