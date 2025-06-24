// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Counter {
    uint public counter;

    function increment() public {
        counter += 1;
    }

    function decrement() public {
        counter -=1;
    }

    // view 表示仅读取, 不会修改 counter 状态
    function get() public view returns (uint) {
        return counter;
    }
}