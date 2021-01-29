// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.0;
// Now we want to trigger events in solidity
// so that anyone can see the ouputs if they are subscribed to it.
contract myContract{
    mapping(address => uint) public tokenBalance;
    address payable walletAddress;
    constructor(address payable _walletAddress) {
        walletAddress = _walletAddress;
    }
    // we define an event like this and add the parameters we want to display, as arguments.
    // event can be seen in the log in remix ide
    // indexed means teh event will be indexed based on that variable
    event purchase(address indexed _buyer, uint256 _amount);
    fallback() external payable {
        buyToken();
    }
    function buyToken() public payable{
        tokenBalance[msg.sender] += 10;
        walletAddress.transfer(msg.value);
        // triggering an event
        emit purchase(msg.sender, 10);
    }
    
}