// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.0;
contract myContract{
    mapping(address => uint) public tokenBalance;
    address payable walletAddress;
    constructor(address payable _walletAddress) {
        walletAddress = _walletAddress;
    }
    // Now we want to automate the buyToken function. 
    // If we deposit the ether, the token is automatically transferred.
    // This is known as a fallback function.
    fallback() external payable {
        buyToken();
    }
    function buyToken() public payable{
        tokenBalance[msg.sender] += 10;
        walletAddress.transfer(msg.value);
    }
}