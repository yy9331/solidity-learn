// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract UDVTAandStruct {
    // UDVT: 定义美元类型
    type USD is uint256;

    // Struct: 用户信息结构体
    struct User {
        address wallet;
        USD balance;
        uint256 lastActive;
    }

    // 用户地址信息的映射
    mapping (address => User) public users;

    // 显式转换函数
    function toUSD(uint256 amount) public pure returns (USD) {
        return USD.wrap(amount);
    }

    // 添加用户(演示 Struct 初始化)
    function addUser(address wallet, uint256 initialBalance) external {
        users[wallet] = User({
            wallet: wallet,
            balance: toUSD(initialBalance),
            lastActive: block.timestamp
        });
    }

    // 更新余额 ( 演示UDVT 安全操作)
    function addBalance(address user, USD amount) external {
        User storage u = users[user];
        u.balance = USD.wrap(USD.unwrap(u.balance) + USD.unwrap(amount));
    }
}