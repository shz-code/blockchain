/**
 *   @author Shahidul Alam
 *   @title Artx Auction
 *   @description Contract for Digital Art Auction
 *   @tags solidity, ethereum, asset transfer, digital asset buy/sell, bidding, auction
 *   @version v1.0.0
 */

// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Auction {
    /**
     * -------------------------------------------------------------------------------
     *   Contract Structs [Art,Bid]
     * -------------------------------------------------------------------------------
     */
    struct Art {
        uint256 id;
        address creator;
        address currentOwner;
        string uri;
        uint256 basePrice; // In ETH
        bool locked; // Represents purchaseable Art or not [True -> not purchaseable]
    }
    struct Bid {
        uint256 artId;
        address currentHighestBidder;
        uint256 currentHighestBid;
        uint256 finishTime;
    }
     /**
     * -------------------------------------------------------------------------------
     *   Contract Variables:
     *       artsId -> Latest uploaded art id
     *   Mappings:
     *       arts -> All Arts
     *       bids -> All Bids [Each Bid represent bidding status of one Art]
     * -------------------------------------------------------------------------------
     */

    uint256 internal artsId;

    mapping(uint256 => Art) internal arts;
    mapping(uint256 => Bid) internal bids;
    /**
     * -------------------------------------------------------------------------------
     *   Contract Functions:
     *       Art:
     *          newArt -> Register new Art
     *          getAllArts -> Get All Arts
     *          getArt -> Get Specific Art
     *          unlockArt -> Unlocks the Art for transferable
     *          lockArt -> Locks the Art so that is is not transferable
     *       User:
     *          newUser -> Register new User
     *          getAllUsers -> Get all Users
     *          getUserArts -> Get User Arts
     *          getUser -> Get specific user
     *          updateUserName -> Update user name
     *       Transaction:
     *          getAllTransactions -> Get all transactions
     *          getUserTransactions-> Get all user transactions
     *          getTransaction -> Get desired transaction
     *          transferArt -> Transfer Art from one user to another
     * -------------------------------------------------------------------------------
     */

     /**
     *   @dev Function/newArt -> Upload new Art.
     *   @param _uri hash of art uploaded to pinata(IPFS), @param _basePrice Base Price of Art in ETH
     */
    function newArt(string memory _uri, uint256 _basePrice) public {
        Art memory art = Art(artsId, _msgSender(),  _msgSender(), _uri, _basePrice * 1e18, true );
        arts[artsId] = art;

        artsId++;
    }

    /**
     *   @dev Function/startNewBid -> Start a new bid [Mark a Art as biddable and ready it's bids map]
     *   @notice Only Art Owner can call the function and only if no other bid is on going for same Art
     *   @param _artId Art of which bid will be issued, @param _durationInMinutes Duration of bid in minute
     */
    function startNewBid(uint256 _artId,uint256 _durationInMinutes) public onlyValidArt(_artId) onlyArtOwner(_artId,_msgSender()) {
        require(arts[_artId].locked == true,"Already bid ongoing for Art");

        Bid memory bid = Bid(_artId,arts[_artId].currentOwner,arts[_artId].basePrice,block.timestamp + _durationInMinutes * 1 minutes);
        
        // Related Bid Map Art
        bids[_artId] = bid;

        // Mark the Art as open for bid
        arts[_artId].locked = false;
    }

    /**
     *   @dev Function/getBidInfo -> Get Bid Info
     *   @notice Only running Bid Art info will be returned
     *   @param _artId Art of which bid info will be returned
     *   @return Art
     */
    function getBidInfo(uint _artId) public view onlyBiddable(_artId) returns (Bid memory)  {
        return bids[_artId];
    }

    /**
     *   @dev Function/makeBid -> Make a bid
     *   @notice Only biddable Art can be bided. Bid must be running in order to bid. Bid amount needs to be at least 2 ETH more than previous highest bid
     *   @param _artId Art for which user will bid
     */
    function makeBid(uint _artId) public payable onlyValidArt(_artId) onlyBiddable(_artId)  {
        require(bids[_artId].finishTime > block.timestamp, "Bid Finished" );
        require(_msgValue() >= bids[_artId].currentHighestBid + (2 * 1e18),"Not enough bid amount"); // Bid amount needs to be at least 2 ETH more than previous highest bid

        if(bids[_artId].currentHighestBidder != arts[_artId].currentOwner) // Transfer bid amount of previous bidder only if he is not the owner
        {
            payable(bids[_artId].currentHighestBidder).transfer(bids[_artId].currentHighestBid);
        }
        // Update bid status
        bids[_artId].currentHighestBidder = _msgSender();
        bids[_artId].currentHighestBid = _msgValue();
    }

    /**
     *   @dev Function/endBid -> End the bid
     *   @notice Only Art owner can all. Bid time needs to be finished to end the bid
     *   @param _artId Art for which user wants to end bid
     */
    function endBid(uint256 _artId) public onlyValidArt(_artId) onlyArtOwner(_artId,_msgSender()) onlyBiddable(_artId) {
        require(bids[_artId].finishTime < block.timestamp, "Bid Not Finished Yet" ); // Bid time needs to be finished to end the bid

        // Transfer fund to Art owner
        payable(arts[_artId].currentOwner).transfer(bids[_artId].currentHighestBid);

        // Update Art Ownership
        arts[_artId].currentOwner = bids[_artId].currentHighestBidder;
        arts[_artId].basePrice = bids[_artId].currentHighestBid;
        arts[_artId].locked = true;
    }

    /**
     * -------------------------------------------------------------------------------
     *   Contract Modifiers:
     *       onlyBiddable -> Only the Art that is marked biddable
     *       onlyValidArt -> Check if Art exists
     *       onlyArtOwner -> Only Art owner accessible
     * -------------------------------------------------------------------------------
     */

    /**
     *   @dev Modifier/onlyBiddable -> Only the Art that is marked biddable
     */
    modifier onlyBiddable(uint256 _artId) {
        require(arts[_artId].locked == false, "Art is not biddable");
        _;
    }

    /**
     *   @dev Modifier/onlyValidArt -> Check if Art exists
     */
    modifier onlyValidArt(uint256 _artId) {
        require(arts[_artId].creator != address(0), "Art doesn't exists");
        _;
    }

    /**
     *   @dev Modifier/onlyArtOwner -> Only valid Art owner can access
     */
    modifier onlyArtOwner(uint256 _artId, address _addr) {
        require(
            arts[_artId].currentOwner == _addr,
            "User not the current owner of Art"
        );
        _;
    }

    /**
     * -------------------------------------------------------------------------------
     *   Contract Utilities:
     *       _msgSender -> Returns msg sender address
     *       _msgValue -> Return transferred fund amount
     *       getUsersLength -> Returns wallet balance of provided address
     * -------------------------------------------------------------------------------
     */

    /**
     *   @dev Utilities/_msgSender
     *   @return address of msg sender.
     */
    function _msgSender() internal view returns (address) {
        return msg.sender;
    }

    /**
     *   @dev Utilities/_msgValue
     *   @return amount of transferred fund
     */
    function _msgValue() internal view returns (uint256) {
        return msg.value;
    }

    /**
     *   @dev Utilities/getBalance
     *   @return balance of Returns wallet balance of provided address
     */
    function getBalance(address _addr) internal view returns (uint256) {
        return (_addr).balance;
    }
}
