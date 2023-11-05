// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20} from "./ERC20.sol";

contract Community is ERC20 {
    address owner;
    string name;

    uint256 votingDuration = 2;

    uint256 artId;

    struct Art {
        uint256 id;
        string uri;
        address creator;
        address currentOwner;
        int256 voteCount;
        uint256 status; // 0 for pending, 1 for approved, 2 for disapproved
        uint256 finishTime;
        bool sellAble;
        uint256 price;
    }

    Art[] arts;
    //mapping(uint => uint) platformXcomArtId;
    mapping(uint256 => mapping(address => bool)) voteCheck;
    mapping(address => uint256) userArtCount;
    uint256 pendingArtCount;
    uint256 approvedArtCount;

    constructor(string memory _symbol) ERC20("Com", _symbol, 15000) {
        owner = msg.sender;
        name = "Test";
    }

    function mint(address addr, uint256 _amount) public {
        //require(msg.sender == owner,"Only Owner is Allowrd");
        _mint(addr, _amount);
    }

    function burn(address addr, uint256 _amount) public {
        //require(msg.sender == owner,"Only Owner is Allowrd");
        _burn(addr, _amount);
    }

    function getCommunityInfo()
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            uint256
        )
    {
        (
            string memory tokenName,
            string memory symbol,
            uint256 totalSupply
        ) = getTokenInfo();
        return (name, tokenName, symbol, totalSupply);
    }

    function getBalance(address addr) public view returns (uint256) {
        return balanceOf(addr);
    }

    function createArt(string memory _uri, address _owner) public {
        burn(_owner, 100);
        Art memory art = Art(
            artId,
            _uri,
            _owner,
            _owner,
            0,
            0,
            block.timestamp + votingDuration * 1 minutes,
            false,
            450
        );
        arts.push(art);

        _burn(_owner,100);

        //platformXcomArtId[_platformArtId] = artId;
        pendingArtCount++;
        artId++;
    }

    function getArt(uint256 _artId) public view returns (Art memory) {
        return arts[_artId];
    }

    function getArts() public view returns (Art[] memory) {
        return arts;
    }

    function upVote(address addr, uint256 _artId) public {
        require(
            arts[_artId].finishTime > block.timestamp,
            "Voting time finished"
        );
        require(voteCheck[_artId][addr] == false, "Already voted");

        voteCheck[_artId][addr] = true;
        arts[_artId].voteCount += int256(balanceOf(addr));
    }

    function downVote(address addr, uint256 _artId) public {
        require(
            arts[_artId].finishTime > block.timestamp,
            "Voting time finished"
        );
        require(voteCheck[_artId][addr] == false, "Already voted");

        voteCheck[_artId][addr] = true;
        arts[_artId].voteCount -= int256(balanceOf(addr));
    }

    function voteFinished(uint256 _artId) public {
        require(
            arts[_artId].finishTime < block.timestamp,
            "Voting not finished"
        );
        if (arts[_artId].voteCount > 0) {
            arts[_artId].status = 1;
            approvedArtCount++;
            userArtCount[arts[_artId].creator]++;
        } else {
            arts[_artId].status = 2;
        }
        pendingArtCount--;
    }

    function markArtSellable(address addr, uint256 _artId) public {
        require(arts[_artId].currentOwner == addr, "Only Owner Allowed");
        arts[_artId].sellAble = true;
    }

    function transferArt(uint256 _artId, address _buyer) public {
        require(arts[_artId].sellAble == true, "Art not sell able");

        // Transfer Native Token
        transfer(arts[_artId].currentOwner, _buyer, arts[_artId].price);

        userArtCount[_buyer]++;
        userArtCount[arts[_artId].currentOwner]--;
        arts[_artId].currentOwner = _buyer;
    }

    function getUserArts(address addr) public view returns (Art[] memory) {
        Art[] memory userArts = new Art[](userArtCount[addr]);
        for (uint256 i = 0; i < artId; i++) {
            if (arts[i].currentOwner == addr && arts[i].status == 1) {
                userArts[i] = arts[i];
            }
        }
        return userArts;
    }
}
