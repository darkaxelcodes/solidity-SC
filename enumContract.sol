// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.0;
contract myContract{
    // enum --> user defined data type. Enums restrict a variable to have one of only a few predefined values. 
    // The values in this enumerated list are called enums.
    // NO ; AFTER enum
    enum state {Waiting, Ready, Active}
    state public currentState = state.Waiting;
    
    function activate() public {
        currentState = state.Active;
    }
    function isActive() public view returns(bool) {
        return currentState == state.Active;
    }
}