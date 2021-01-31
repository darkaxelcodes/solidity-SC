// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.0;
// Multiple contracts.
// 1. We deploy the myToken contract.

contract myToken{
    string public name = "myToken";
    mapping(address => uint) private tokenBalance;
    function mintToken() internal {
        // msg.sender is calling the one who sends the contract not who is originating it
        //tokenBalance[msg.sender] += 10;
        tokenBalance[tx.origin] += 10;
    }
}

// 2. Then we pass the contract address of the myToken to deploy the myContract.
contract myContract{
    // We need an address where we deposit the ethers recieved.
    address payable walletAddress;
    // To call the myToken contract, we need its address.
    address public myTokenContractAddress;
    constructor(address payable _walletAddress, address _token) {
        walletAddress = _walletAddress;
        myTokenContractAddress = _token;
    }
    
    event purchase(address indexed _buyer, uint256 _amount);
    
    fallback() external payable {
        buyToken();
    }
    
    function buyToken() public payable{
        myToken(address(myTokenContractAddress)).mintToken();
        walletAddress.transfer(msg.value);
        emit purchase(msg.sender, 10);
    }
}