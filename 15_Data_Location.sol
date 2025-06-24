// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract DataLocation {
    uint256[] public arr; // storage
    event ValUpdate(uint256[] newVal);

    struct MyStruct {
        uint256 foo;
    }

    MyStruct public myStruct;
    // calldata 是只读的, 不能被修改:
    function f(uint[] calldata _arr, MyStruct calldata _myStruct) public {
        arr = _arr;
        // 实例化 strct 里的参数
        MyStruct memory temp = _myStruct;
        temp.foo += 1;
        myStruct = temp;
    }

    function g(uint[] memory _arr, MyStruct memory _myStruct) public {
        _arr[0] = 1;
        _myStruct.foo = 100;

        arr = _arr;
        myStruct = _myStruct;

        arr[0] = 333;
        emit ValUpdate(_arr);
    }
}