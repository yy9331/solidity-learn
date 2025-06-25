// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Parent {
    int private privateValue = 1;
    int public publicValue = 3;
    int internal internalValue = 4;

    function privateFunc() private view returns (int) {
        publicFunc(); // 直接调用
        internalFunc(); // 直接调用
        this.externalFunc(); // externalFunc 需要通过 this 调用
        return privateValue + publicValue + internalValue;
    }
    function publicFunc() public view returns (int) {
        return publicValue + publicValue + internalValue;
    }
    function internalFunc() internal view returns(int) {
        return internalValue + internalValue + privateValue;
    }
    function externalFunc() external view returns(int) {
        return internalValue + internalValue + privateValue;
    }
}

contract Child is Parent {
    function accessParent () public view returns (string memory) {
        publicFunc();
        internalFunc();
        this.externalFunc();
        // privateFunc(); ❌ 错误, 子合约不能调用父合约的 private 函数
        return "Childe Access Parent";
    }
}