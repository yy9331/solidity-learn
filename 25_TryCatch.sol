// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

// External contract
contract Foo {
    address public owner;
    constructor(address _owner) {
        require(_owner != address(0), "invalid addr");
        assert(_owner != 0x0000000000000000000000000000000000000001);
        owner = _owner;
    }

    function myFunc(uint256 x) public pure returns (string memory) {
        require(x !=0, "require failed");
        return "myFunc was called";
    }
}

contract Bar {
    event Log(string message);
    event LogBytes(bytes data);

    Foo public foo;
    constructor() {
        foo = new Foo(msg.sender);
    }

    // Example of try/catch with external call
    // tryCatchMyFuncExternalCall(0) => Log("external call failed")
    // tryCatchMyFuncExternalCall(1) => Log("my func was called")
    function tryCatchMyFuncExternalCall(uint256 _i) public {
        // 捕获 上面 Foo 合约的 myFunc函数异常:
        try foo.myFunc(_i) returns (string memory result) {
            emit Log(result);
        } catch {
            // 捕获Foo 合约myFunc 的 require 异常
            emit Log("External call failed");
        }
    }

    // Example of try/catch with external creation
    // tryCatchConstructor(0x0000000000000000000000000000000000000000) => Log("invalid addr")
    // tryCatchConstructor(0x0000000000000000000000000000000000000001) => Log("")
    // tryCatchConstructor(0x0000000000000000000000000000000000000002) => Log("Foo created")
    function tryCatchConstructor(address _owner) public {
        // 捕获Foo 的构造函数异常:
        try new Foo (_owner) returns (Foo) {
            emit Log("Foo created");
        }catch Error(string memory err_message) {
            // Foo 构造函数里的 require 异常
            emit Log(err_message);
        }catch (bytes memory reason) {
            // Foo 的构造函数里 assert 异常
            emit LogBytes(reason);
        }
    }
}