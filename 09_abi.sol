// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract ABI {
    // 1. 编码
    function encodeData(string memory text, uint256 number) public pure returns (bytes memory, bytes memory) {
        return (
            abi.encode(text, number),
            abi.encodePacked(text, number)
        );
    }

    // 2. 解码
    function decodeData(bytes memory encodedData) public pure returns (string memory text, uint256 number) {
        return abi.decode(encodedData, (string, uint256));
    }

    // 3. 获取当前函数签名
    function getSelector() public pure returns(bytes4) {
        return msg.sig; 
    }

    function computeSelector(string memory func) public pure returns (bytes4) {
        return bytes4(keccak256(bytes(func)));
    }

    function transfer(address addr, uint amount) public pure returns (bytes memory) {
        return msg.data;
    }

    function encodeFunctionCall() public pure returns (bytes memory) {
        return abi.encodeWithSignature("transfer(address,uinit)", 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 100);
    }
}