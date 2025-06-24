// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StructDemo {
    struct Person {
        uint age;
        string name;
        Hobbie[] hobbies;
    }

    struct Hobbie {
        string label;
        string value;
    }

    Person[] public persons;

    mapping(address => Person) public personMap;

    function addPerson(Person calldata p) public {
        persons.push(p);
    }
    function setPersonMap(Person calldata p, address addr) public {
        personMap[addr] = p;
    }
}