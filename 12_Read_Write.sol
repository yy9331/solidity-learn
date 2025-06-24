// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract ReadAndWrite {
    uint public num;

    constructor(uint _num) {
        num = _num;
    }

    function set(uint _num) public {
        num = _num;
    }

    function get() public view returns (uint) {
        return num;
    }
}