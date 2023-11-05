// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//import {IERC20} from "./IERC20.sol";

contract ERC20 {
    uint internal totalSupply;

    mapping(address => uint) internal balance;

    string internal tokenName;
    string internal symbol;
    

    constructor(
        string memory _name,
        string memory _symbol,
        uint _initialSupply
    ){
        tokenName = _name;
        symbol = _symbol;
        totalSupply = _initialSupply;
    }
    
    function balanceOf(address addr) internal view returns (uint){
        return balance[addr];
    }

    function getTokenInfo() internal view returns (string memory,string memory,uint ){
        return (tokenName, symbol, totalSupply);
    }


    function transfer(address sender,address recipient, uint amount) internal {
        balance[sender] -= amount;
        balance[recipient] += amount;
       // emit Transfer(msg.sender, recipient, amount);
    }

    function _mint(address addr,uint amount) internal {
        balance[addr] += amount;
        totalSupply += amount;

       // emit Transfer(address(0), msg.sender, amount);
    }

    function _burn(address addr,uint amount) internal {
        require(balance[addr] >= amount,"Not Enough Fund");
        balance[addr] -= amount;
        totalSupply -= amount;
       // emit Transfer(msg.sender, address(0), amount);
    }
}