// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract SendEthereum {
    address payable public owner;
    event Log(string message);

    constructor () payable {
        owner = payable(msg.sender);
        owner.transfer(address(this).balance); 
    }

    function deposit() payable public {

    }

    function withdraw() public {
        // 这里需要做参数检查, 先略过
        uint256 amount =  address(this).balance;
        (bool success, ) = owner.call{value:amount}("");
        require(success, "transfer failed");
    }

    function transfer(address payable _to, uint256 amount) public {
        (bool success, ) = _to.call{value:amount}("");
        require(success, "transfer failed");
    }

    receive() external payable {
        emit Log("receive called+++++++++++++++++++");
    }
    fallback() external payable {
        emit Log("fallback called~~~~~~~~~~~~~~~~~");
    }
}

contract SenderEth {
    // 使用call转账
    function sendVicCall(address payable _to) public payable {
        (bool sent, bytes memory data)= _to.call{ value: msg.value }(abi.encodeWithSignature("notExistenFunc()"));
        require(sent, "transfer failed");
    }

    // 使用send转账
    function sendViaSend(address payable _to) public payable {
        bool sent = _to.send(msg.value);
        require(sent, "transfer failed");
    }

    // 使用transfer 转账
    function sendViaTranfer(address payable _to) public payable {
        _to.transfer(msg.value);
    }
}