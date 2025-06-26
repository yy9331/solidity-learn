// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MsgDataDemo {
    event Data(bytes data);

    // 普通函数，查看msg.data内容
    function foo(uint256 x, string memory y) public {
        emit Data(msg.data);
    }

    // fallback函数，查看msg.data内容
    fallback() external payable {
        emit Data(msg.data);
    }
}