// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Gas {
    address public owner;
    uint public gasPrice;

    constructor() {
        owner = msg.sender;
    }

    function simpleTransfer(address payable _to) external payable {
        require(msg.sender == owner, "Only owner can transfer");
        _to.transfer(msg.value);
        gasPrice = tx.gasprice;
    }

    function getBalance(address account) external view returns (uint256) {
        return account.balance;
    }
}