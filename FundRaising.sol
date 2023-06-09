pragma solidity ^0.8.17;

contract FundRaising{

struct donationEvent{
    uint balance;
    uint  donorsCount;
    bool  goalAchieved;
    bool isClosed;
}

address internal managerAddress;
uint internal donationPurpose;

constructor(uint _donationPurpose)  {
    managerAddress = msg.sender;
    donationPurpose = _donationPurpose;
}

donationEvent internal actualDonation = donationEvent(0,0,false,false);



function donate() public payable {
        require(!actualDonation.isClosed, "The fundraising is already closed");
        require(msg.value > 0, "Amount should be greater than zero.");

          actualDonation.balance += msg.value;
          actualDonation.donorsCount++;
    }

function withdraw() public {
        require(msg.sender == managerAddress, "Only the manager can withdraw");
        require(actualDonation.balance > 0, "Nothing to withdraw");

        payable(msg.sender).transfer(actualDonation.balance);
        actualDonation.balance = 0;
    }

function closeFundraising() public {
        require(msg.sender == managerAddress, "Only the manager can close");
        require(!actualDonation.isClosed, "The fundraising is already closed");
        
        if(actualDonation.balance >= donationPurpose) {
            actualDonation.goalAchieved = true;
         }
        actualDonation.isClosed = true;
    }

function checkBalance() public view returns (bool) {
        require(msg.sender == managerAddress, "Only the manager can check");   
        
        return actualDonation.balance >= donationPurpose;
    }
}