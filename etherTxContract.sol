// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.0;
// Now we want to write a function that accepts ether.
contract myContract{
    // mapping to track the token balance of an address.
    mapping(address => uint) public tokenBalance;
    // Adress of the wallet that will accept ether.
    // The contract is deployed on the walletAddress.
    // If we buy the token from another address, the ether will be deducted from that address and deposited
    // to the account that made the buyToken request.
    address payable walletAddress;
    constructor(address payable _walletAddress){
        walletAddress = _walletAddress;
    }
    // buyToken() is going to simulate a coin (tocken) on top of eth,
    // kind of like an ICO.
    // buy a token using ether
    // send that ether to wallet and give them the token in exchange for it.
    function buyToken() public payable{
        tokenBalance[msg.sender] += 10;
        walletAddress.transfer(msg.value);
    }
}