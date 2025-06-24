// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Demo {
    uint constant public PECISION = 18;
    string public constant SYMBOL = "YY";

    address public immutable owner;
    uint public immutable tiemstamp;

    constructor(address _owner) {
        // immutable 一般在构造函数里初始化:
        owner=_owner;
        tiemstamp = block.timestamp;
    }

    function getConfig() public view returns (uint, string memory, address, uint){
        return (PECISION,  SYMBOL, owner, tiemstamp);
    }
}