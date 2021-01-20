// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.0;
contract myContract {
    // structs --> user defined data type.
    struct person{
        string _firstName;
        string _lastName;
    }
    person[] public people; // people is public so we don't need a getter function
    // but it dosen't return the whole array, it expects a uint input which means the index.
    // So we have a personCount and retreive the size of the array to get an idea.
    uint public personCount;
    function addPeople(string memory _firstName, string memory _lastName) public{
        people.push(person(_firstName, _lastName));
        personCount += 1;
    }
    // instead of creating an array of the type person (which is a struct), we can use the mapping.
    // a mapping is a key value pair, like a dict in python
    struct animal{
        uint _id ;
        string _name;
        string _petName;
    }
    uint public animalCount = 0;
    mapping(uint => animal) public zoo;
    // corelating, it means, we have a dict named zoo, key int type and value animal(struct) type.
    function addAnimal(string memory _name, string memory _petName) public{
        animalCount += 1;
        zoo[animalCount] = animal(animalCount, _name, _petName);
    }
}