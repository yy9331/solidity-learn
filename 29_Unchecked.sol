// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Uncheked {
    function sum1(uint8 x, uint8 y) public pure returns (uint8) {
        unchecked {
            return x + y;
        }
    }
    function sum2(uint8 x, uint8 y) public pure returns (uint8) {
        return x + y;
    }
    
    function sub1(uint8 x, uint8 y) public pure returns (uint8) {
        unchecked {
            return x - y;
        }
    }
    function sub2(uint8 x, uint8 y) public pure returns (uint8) {
        return x - y;
    }

}