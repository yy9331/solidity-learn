// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract dataType {
    // 动态字节
    bytes public enptyBytes; // 0x
    bytes public dynamicData = "Hello"; // 0x48656c6c6f
    function appendToBytes(bytes memory _data) external  {
        // 在 Remix 里键入 "0xcd", 可以将 cd 添加到dynamicData最后
        dynamicData = bytes.concat(dynamicData, _data); // 0x48656c6c6fcd
    }
}