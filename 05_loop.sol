// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract loop {
    function forLoop() public pure returns(uint) {
        uint sum = 0;
        for (uint i = 1; i< 6; i++) sum +=i;
        return sum; // 15
    }

    // solidity 的 for 循环除了传统写法, 还可以把括号里的每个部分单独抽出来写:
    function forLoop1() public pure returns(uint) {
        uint sum = 0;
        uint i = 1;
        for ( ; ; ) {
            if (i > 5) break;
            sum +=i;
            i++;
        }
        return sum; // 15
    }
}