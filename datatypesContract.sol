// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.0;
contract myContract{
    // instead of using a getter function, if we make the state variable public,
    // we can view the value later.
    // instead of the constructor, we could initialise a value here.
    string public stringValue = "myValue";
    function set(string memory _value) public {
        stringValue = _value;
    }
    // constant keyword makes it a contant
    string public constant stringValueConstant = "myValue";
    
    bool public boolValue = true;
    int public intValue = -1000;
    uint public uintValue = 1000; //defaults to uint256
}
