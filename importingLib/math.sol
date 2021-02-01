// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.0;
library math{
    function divide(uint256 _value1, uint256 _value2) internal pure returns(uint256){
        require(_value2>0);
        uint256 result = _value1 / _value2;
        return result;
    }
}