// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Keccak256 {
    function notClilision(string memory _txt, string memory _otherTxt) public pure returns (bytes32) {
        // encodePacked(AAA, BBB) => AAABBB
        // encodePacked(AA, ABBB) => AAABBB
        return keccak256(abi.encode(_txt, _otherTxt));
    }

    function collision(string memory _txt, string memory _otherTxt) public pure returns (bytes32) {
        // encodePacked(AAA, BBB) => AAABBB
        // encodePacked(AA, ABBB) => AAABBB
        return keccak256(abi.encodePacked(_txt, _otherTxt));
    }

    function usePacked(uint256 _num, address _addr) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_num, _addr));
    }
}