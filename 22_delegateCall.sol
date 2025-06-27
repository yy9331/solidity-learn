// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract LogicContract {
    uint256 public value; // 逻辑合约中, 存储槽位的初始值是0
    function AddValue() public {
        value += 1;
    }
}

// 这里的逻辑合约升级为 v2, 改了 AaddValue 逻辑
contract LogicContractV2 {
    uint256 public value;
    function AddValue() public {
        value += 5;
    }
}

contract ProxyContract {
    uint256 public value; // 代理合约中, 存储槽位的初始值也是0
    address public logicContract;

    constructor(address _logicContract ) {
        logicContract = _logicContract;
    }

    function SetLogicContract(address _logicContract) public {
        // 设置逻辑合约
        logicContract = _logicContract;
    }
    receive() external payable { }
    fallback() external payable {
        // 代理合约的主要作用: 在fallback 函数里直接执行.delegatecall
        (bool success,) = logicContract.delegatecall(msg.data);
        require(success, "Delegatecall failed");
    }
}

contract Client {
    address public proxy;
    constructor(address _proxy) {
        proxy = _proxy;
    }
    
    function AddValue() public {
        // 客户端合约的主要逻辑, 直接用.call 调用, 里面传入 abi 编码 AddValue() 函数
        // 该函数 AddValue() 存在于 逻辑合约 LogicContract 中
        (bool success, ) = proxy.call(abi.encodeWithSignature("AddValue()"));
        require(success, "Delegate call failed");
    }
}