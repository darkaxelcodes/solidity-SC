// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.0;
// Inheritance of contracts.

contract myTokenSuper{
    string public name;
    constructor(string memory _name){
        name = _name;
    }
    mapping(address => uint) public tokenBalance;
    function mintToken() virtual public {
        // msg.sender is calling the one who sends the contract not who is originating it
        //tokenBalance[msg.sender] += 10;
        tokenBalance[tx.origin] += 10;
    }
}

contract myTokenChild is myTokenSuper{
    string public symbol;
    address[] public owners;
    uint256 public ownerCount;
    constructor(string memory _name, string memory _symbol) myTokenSuper(_name){
        symbol = _symbol;
    }
    function mintToken() override public{
        super.mintToken();
        ownerCount++;
        owners.push(msg.sender);
    }
}