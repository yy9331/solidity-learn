// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface ICounter {
    function count() external view returns(int256);
    function increment() external ;
}

contract Counter is ICounter {
    int public  count;
    function increment() external {
        count += 1;
    }
}

contract MyContract {
    function incrementCounter(address _counter) external {
        ICounter(_counter).increment(); // ICounter 调用 interface 接口, 无须 Counter 的合约代码
    }

    function getCount(address _counter) external view returns (int256) {
        return ICounter(_counter).count(); // ICounter 调用 interface 接口, 无须 Counter 的合约代码
    }
}