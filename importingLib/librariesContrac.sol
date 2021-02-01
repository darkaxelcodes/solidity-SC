// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.0;
import "./math.sol";
contract myContract{
    uint256 public value;
    function calculate(uint256 value1, uint256 value2) public{
        value = math.divide(value1, value2);
    }
}