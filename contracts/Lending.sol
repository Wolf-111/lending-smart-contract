//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

/*
    1. Contract initiated
    2. Borrower makes a request to borrow X amount at a certain interest rate with a specified term
    3. Borrower may cancel request at any time unless it already got accepted
    4. Once accepted, funds are automatically taken from lenders account and sent to borrower
    5. Interest is paid out by borrower every month OR at the end of the term if it's less than 1 month
    6. At any given time during the term, the borrower can request to renew the loan once the term ends
*/

contract Lending {
    struct LoanRequest {
        uint amount;
        uint interestRate;
        uint termLength;
    }

    mapping(address => LoanRequest) public loanRequests;
    mapping(address => bool) public isAwaitingLoan;

    function requestLoan(uint _amount, uint _interestRate, uint _termLength) public {
        loanRequests[msg.sender] = LoanRequest(_amount, _interestRate, _termLength);
        isAwaitingLoan[msg.sender] = true;
    }

    function cancelRequestLoan() public {
        require(isAwaitingLoan[msg.sender] = true, "Error: You have not requested a loan");
        delete loanRequests[msg.sender];
        isAwaitingLoan[msg.sender] = false;
    }

    function acceptLoanRequest(address _addressToLoanTo) public view {
        // Make sure the lender has enough to actually lend
        require(address(msg.sender).balance >= loanRequests[_addressToLoanTo].amount, "Error: You do not have sufficient funds to lend");
        msg.sender.transfer(loanRequests[_addressToLoanTo].amount);
    }
}