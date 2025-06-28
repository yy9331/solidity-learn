// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Callee {
    address public owner;
    mapping (address => uint256 ) balances;

    constructor() {
        owner = msg.sender;
    }

    // 设置owner, 并返回新owner
    function setOwner(address _newOwner) public returns(address) {
        owner = _newOwner;
        return _newOwner;
    }

    // 既可以设置 owner, 也可以接收 eth
    function setOwnerAndSendEth(address _newOwner) public payable returns (address, uint256){
        owner = _newOwner;
        balances [msg.sender] += msg.value;
        return (_newOwner, msg.value);
    }
}

contract Caller {
    function setOwner(Callee _callee, address _newOwner) public returns (address) {
        // 调用Callee 方法1: 通过合约实例调用 Callee 的 setOwner 函数
        return _callee.setOwner(_newOwner);
    }

    function setOwnerFromAddress(address _addr, address _newOwner) public returns (address) {
        // 调用Callee 方法2: 通过地址转为合约示例调用 setOwnerAndSendEth 函数
        Callee callee = Callee(_addr);
        return callee.setOwner(_newOwner);
    }

    // 函数: 调用 Callee 的 payable 方法发送 eth
    function setOwnerAndSendEth(Callee _callee, address _newOwner) public payable returns (address, uint256){
        (address newOwner, uint256 value) = _callee.setOwnerAndSendEth{value: msg.value}(_newOwner);
        return (newOwner, value);
    }
}