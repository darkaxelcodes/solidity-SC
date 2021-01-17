// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.0;
contract myContract{
    string value;
    constructor(){
        value = "myValue";
    }
    function get() public view returns(string memory){
        return value;
    }
    function set(string memory _value) public {
        value = _value;
    }
}