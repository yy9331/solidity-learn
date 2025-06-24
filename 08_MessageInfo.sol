// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract MessageInfo {
    // address public owner;
    // constructor() payable {
    //     owner = msg.sender;
        
    //     // 将合约收到的 ETH 转给部署者
    //     payable(msg.sender).transfer(address(this).balance);
    // }
    
    function getMessageDetails() public payable returns (address, uint) {
        return (msg.sender, msg.value);
    }

    function getContractAddress() public view returns (address) {
        return address(this);
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }
}