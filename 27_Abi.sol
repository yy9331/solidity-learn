// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Abi {
    function getEncode(address _addr, uint256 _val) pure public returns(bytes memory) {
        return abi.encode(_addr, _val);
    }

    function getEncodePacked(address _addr, uint256 _val) pure public returns(bytes memory) {
        return abi.encodePacked(_addr, _val);
    }

    function getEncodeWithSelector(address _addr, uint256 _val) pure public returns (bytes memory) {
        bytes4 selector = bytes4(keccak256(bytes("transfer(address,uint)")));
        bytes memory data = abi.encodeWithSelector(selector, _addr, _val);
        return data;
    }

    // getEncodeWithSignature 是上面 getEncodeWithSelector 的快捷方式, 他们编码出来的东西相同
    function getEncodeWithSignature(address _addr, uint256 _val) pure public returns (bytes memory) {
        bytes memory data = abi.encodeWithSignature("transfer(address, uint)", _addr, _val);
        return data;
    }

    function decodeData(bytes memory data) pure public returns (address, uint256){
        (address addr, uint256 val) = abi.decode(data, (address, uint256));
        return (addr, val);
    }
}