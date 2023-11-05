// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Community} from "./Community.sol";
import {ERC20} from "./ERC20.sol";

contract Platform is ERC20 {
    address platformOwner;

    Community[] public community;

    struct CommunityStruct {
        string name;
        string tokenName;
        string symbol;
        uint supply;
    }

    mapping(uint => CommunityStruct) communities;

    constructor() ERC20("ArtBlock","ABX",0) {
        platformOwner = msg.sender;
    }

    uint comId;

    function createCommunity() public {
        _burn(msg.sender,100);
        Community com = new Community("S");
        community.push(com);

        (string memory name,string memory tokenName,string memory symbol,uint supply) = community[comId].getCommunityInfo();

        communities[comId] = CommunityStruct(name,tokenName,symbol,supply);

        comId++;
    }

    function mint(uint256 _amount) public {
        require(msg.sender == platformOwner,"Only Owner is Allowrd");
        _mint(msg.sender,_amount);
    }

    function exchangeABXtoComNative(uint _comId,uint _amount) public 
    {
        _burn(msg.sender,_amount);
        community[_comId].mint(msg.sender,_amount);
    }

    function exchangeComNativetoABX(uint _comId,uint _amount) public 
    {
        _mint(msg.sender,_amount);
        community[_comId].burn(msg.sender,_amount);
    }

    function buyABX() payable public {
        _mint(msg.sender,msg.value);
    }

    function getBalance() public view returns(uint256) {
        return balanceOf(msg.sender);
    }

    function getCommunities() public view returns (CommunityStruct[] memory)
    {
        CommunityStruct[] memory com = new CommunityStruct[](comId);
        for(uint i = 0; i < comId;i++)
        {
            com[i] = communities[i];
        }
        return  com;
    }

    function getCommunity(uint _comId) public view returns (CommunityStruct memory) {
        return communities[_comId];
    }

    function getCommunityUserBalance(uint _comId) public view returns(uint256) {
        return community[_comId].getBalance(msg.sender);
    }

    function createArt(uint _comId,string memory _uri) public
    {   
        community[_comId].createArt(_uri,msg.sender);
    }

    function getCommunityArt(uint _comId,uint _artId) public view returns (Community.Art memory)
    {   
        return community[_comId].getArt(_artId);
    }

    function getCommunityArts(uint _comId) public view returns (Community.Art[] memory)
    {   
        return community[_comId].getArts();
    }

    function upVote(uint _comId,uint _artId) public {
        community[_comId].upVote(msg.sender,_artId);
    }
    
    function downVote(uint _comId,uint _artId) public {
        community[_comId].downVote(msg.sender,_artId);
    }

     function voteFinished(uint _comId,uint256 _artId) public {
        community[_comId].voteFinished(_artId);
     }

    function getCommunityUserArts(uint _comId) public view returns (Community.Art[] memory)
    {
        return  community[_comId].getUserArts(msg.sender);
    }

    receive() external payable { }
}