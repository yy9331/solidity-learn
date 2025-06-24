// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// contract Mapping {
//     mapping (address => uint256) public balance;
//     function setBalance(uint amount) public {
//         balance[msg.sender] = amount;
//     }

//     function getBalance(address user) public view returns (uint){
//         return balance[user];
//     }
// }

// mapping 嵌套
contract MultiMapping {
    mapping (address => mapping (string => uint256)) public userBalance;

    function setUserBalance(address addr,string memory currency, uint amount) public {
        userBalance[addr][currency] = amount;
    }
    function getUserBalance(address user, string memory currency) public view returns (uint256) {
        return userBalance[user][currency];
    }

    function deleteUserBalance(address addr, string memory currency) public {
        delete userBalance[addr][currency];
    }
}