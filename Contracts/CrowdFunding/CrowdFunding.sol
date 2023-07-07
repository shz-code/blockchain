// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract CrowdFunding
{
    uint public total_donation; // To keep track of total donation amount
    uint public target; // Target donation amount of crowd funding
    address private owner; // To keep track of the owner of the contract
    bool private locked;
    mapping(address => uint) private contributions; // To keep track of all the contributors address and donation amount
    mapping(address => int[]) private donation_history; // To keep track of all donations from a individual wallet

    constructor(uint _target) {
        owner = msg.sender;
        target = _target*1e18;
    }

    // Make a transfer to the contract
    function donate() public payable {
        // Check if target is fulfilled or not
        if(total_donation + msg.value <= target)
        {
            total_donation += msg.value;
            contributions[msg.sender] += msg.value;
            donation_history[msg.sender].push(int(msg.value));

            // If target is met lock the contract
            if(total_donation == target)
            {
                locked = true;
            }
        }
        else {
            payable(msg.sender).transfer(msg.value);
        }
    }

    // Withdraw all amount to owner waller
    function withdraw() public {
        if(msg.sender == owner)
        {
            payable(owner).transfer(address(this).balance);
        }
    }

    // Withdraw all amount transferred from request wallet
    function refund() public{
        // Check if request wallet has any amount contributed and the contract is locked or not
        if(contributions[msg.sender] > 0 && !locked)
        {
            payable(msg.sender).transfer(contributions[msg.sender]);
            donation_history[msg.sender].push(-int(contributions[msg.sender]));
            total_donation -= contributions[msg.sender];
            contributions[msg.sender] = 0;
        }
    }

    // View donated amount from request wallet
    function viewDonationAmount() public view returns (uint) {
        return contributions[msg.sender];
    }

    // View donation history from request wallet
    function donationHistory() public view returns (int[] memory) {
        return donation_history[msg.sender];
    }
}