// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Var {
    // state variable
    uint256 public timestamp;
    address public owner;

    constructor() {
        // global variable
        owner = msg.sender;
        timestamp = block.timestamp;
    }

    function sum(uint256 a, uint256 b) public pure returns (uint256) {
        // local variable
        uint c = a + b; // 仅在函数执行期间使用
        return c;
    }
}