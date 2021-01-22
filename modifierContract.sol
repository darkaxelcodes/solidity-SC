// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.0;
contract myContract{
    struct animal{
        uint _id ;
        string _name;
        string _petName;
    }
    // now we want to implement a restriction. 
    // A restriction such that only an owner can call the function addAnimal else it throws an error.
    // so we create an address type variable and assign it to the msg.sender
    // msg is the global variable that holds the metadata for the tx.
    address owner = msg.sender;
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    // now we add another restriction based on time.
    // if a certain amount of time has passed, only then the function can be called.
	// block is the global variable that holds info of the block.
    uint openingTime = 1610966030;// epoch time in seconds.
    modifier onlyWhenOpen(){
        require(block.timestamp == openingTime);
        _;
    }

    uint public animalCount = 0;
    mapping(uint => animal) public zoo;
    // corelating, it means, we have a dict named zoo, key int type and value animal(struct) type.
	// now add onlyOwner, onlyWhenOpen to the addAnimal function
    function addAnimal(string memory _name, string memory _petName) public onlyOwner onlyWhenOpen{
        incrementAnimalCount();
        zoo[animalCount] = animal(animalCount, _name, _petName);
    }
    function incrementAnimalCount() internal {
        animalCount += 1;
    }
}