// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

library Math {
    function add(uint x, uint y) public pure returns (uint) {
        return x + y;
    }
}

contract Test {
    // 方法1: 引入并调用: 
    using Math for uint;
    function add(uint x, uint y) public pure returns(uint z) {
        return x.add(y);
    }

    // 方法2: 直接库.方法名()调用
    function plus(uint x, uint y) public pure returns (uint) {
        return Math.add(x, y);
    }
}