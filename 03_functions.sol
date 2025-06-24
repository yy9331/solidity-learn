// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StateModifier {
    uint public count = 0;

    // 默认: 可修改
    function setCount(uint newValue) external {
        count = newValue;
    }

    // view: 只读取
    function getCount() public view returns (uint) {
        return count;
    }

    // pure: 不读取, 不修改
    function add(uint a, uint b) public pure returns (uint) {
        return a + b;
    }

    // payable: 可接收以太币
    function deposit() public payable {

    }
}