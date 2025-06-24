// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Caller {
    function msgSender() public view returns(address) {
        return msg.sender; // address: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    }
    function txOrigin() public view returns(address) {
        return tx.origin; // address: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    }
}

contract Callee {
    Caller caller;
    constructor() {
        caller = new Caller();
    }
    function msgSender() public view returns (address) {
        // 这里的.msgSender() 虽然在内部初始化了 Caller, 但是实际是上这个 Callee的地址:
        // 所以, 不能用 tx.origin 检查发送者地址有漏洞, 必须要调用 msg.sender
        return caller.msgSender(); // address: 0xB302F922B24420f3A3048ddDC4E2761CE37Ea098
    }
    function txOrigin() public view returns (address) {
        return caller.txOrigin(); // address: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    }
}