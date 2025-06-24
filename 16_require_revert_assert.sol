// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract RequireRevertAssert {
    address public owner;
    mapping(address => uint256) private balances;

    // 自定义错误类型 (solidity 0.8.4+)
    error NotEnough(uint256 now, uint256 need);

    constructor() {
        owner = msg.sender;
    }

    // 1. require - 输入验证的前置条件检查
    function deposit() external payable {
        require(msg.value > 0, "deposit: value must > 0");
        balances[msg.sender] += msg.value;
    }

    // 2. revert - 输出验证的复杂条件检查(带自定义错误)
    function withdraw(uint256 amount) external {
        if (amount == 0 || amount >  balances[msg.sender]) {
            revert NotEnough({
                now: balances[msg.sender],
                need: amount
            });
        }

        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    // 3. assert - 内部一致性检查(永远不被触发的条件)
    function ownerWithdraw(uint256 amount) external {
        require(msg.sender == owner, "owner: only owner can withdraw");
        require(amount <= address(this).balance, "Insufficient contract balance");

        // 转账前的余额记录
        uint256 contractBalanceBefore = address(this).balance;
        // 执行转账操作
        payable(owner).transfer(amount);
        // 转账后检查: 余额应正好减少转账金额
        assert(address(this).balance == contractBalanceBefore - amount);
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}