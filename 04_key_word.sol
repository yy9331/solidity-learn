// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KeyWord {
    uint[] public numbers;

    // 修改sotrage
    function addNumber(uint num) public {
        numbers.push(num);
    }

    // 使用 memory
    function getNumbersMemory() public view returns (uint[] memory) {
        uint[] memory temp = numbers; // temp 是 memory 类型，复制了 numbers 的内容
        return temp;
    }

    // 使用 calldata
    function sumCalldata(uint[] calldata arr) external pure returns (uint sum) {
        // arr 是 calldata 类型，只读，不能修改
        for (uint i = 0; i < arr.length; i++) {
            sum += arr[i];
        }
    }

    // storage 引用类型
    function updateFirstNumber(uint newVal) public {
        uint[] storage ref = numbers;
        if (ref.length > 0) {
            ref[0] = newVal;
        }
    }
}