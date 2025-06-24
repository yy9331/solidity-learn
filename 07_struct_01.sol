// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserManager {
    struct User {
        string name;
        uint256 age;
        address wallet;
    }
    mapping (address => User) public users;
    function setUser(string memory name, uint age) public {
        users[msg.sender] = User(name, age, msg.sender);
    }
    function getUser(address userAddress) public view returns(string memory, uint, address) {
        User memory user = users[userAddress];
        return (user.name, user.age, user.wallet);
    }
}

contract UserList {
    struct User {
        string  name;
        uint age;
    }
    User[] public users;
    function addUser(string memory name, uint age) public {
        users.push(User(name, age));
    }
}

contract UserRegistry {
    struct User {
        string name;
        uint256 age;
        bool isRegistered;
    }
    mapping (address => User) public users;
    function registerUser(string memory name, uint age) public {
        require(!users[msg.sender].isRegistered, "User already registered!");
        users[msg.sender] = User(name, age, true);
    }
    function getUser(address user) public view returns(string memory, uint, bool) {
        require(users[user].isRegistered, "User not registered!");
        return (users[user].name, users[user].age, users[user].isRegistered);
    }
}