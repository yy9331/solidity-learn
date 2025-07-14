// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract SignatureNFT is ERC721, Ownable {
using Counters for Counters.Counter;
Counters.Counter private _tokenIds;

uint256 public maxSupply = 1000;
uint256 public mintPrice = 0 ether;

mapping(address => bool) public hasMinted;

event TokenMinted(address indexed to, uint256 indexed tokenId);

constructor() ERC721("SignatureNFT", "SNFT") Ownable(msg.sender) {}

// 铸造函数 - 带签名验证
function mint(address account, uint256 tokenId, bytes calldata signature) public payable {
    require(_tokenIds.current() < maxSupply, "Max supply reached");
    require(msg.value >= mintPrice, "Insufficient payment");
    require(!hasMinted[account], "Already minted");
    require(tokenId == 0, "Only tokenId 0 is allowed");
    require(account == msg.sender, "Can only mint to self");
    
    // 验证签名
    bytes32 messageHash = keccak256(abi.encodePacked(account, tokenId));
    bytes32 ethSignedMessageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash));
    
    (uint8 v, bytes32 r, bytes32 s) = splitSignature(signature);
    address signer = ecrecover(ethSignedMessageHash, v, r, s);
    
    require(signer == owner(), "Invalid signature");
    
    hasMinted[account] = true;
    _tokenIds.increment();
    uint256 newTokenId = _tokenIds.current();
    
    _safeMint(msg.sender, newTokenId);
    emit TokenMinted(msg.sender, newTokenId);
}

// 分割签名
function splitSignature(bytes memory sig) internal pure returns (uint8 v, bytes32 r, bytes32 s) {
    require(sig.length == 65, "Invalid signature length");
    
    assembly {
        r := mload(add(sig, 32))
        s := mload(add(sig, 64))
        v := byte(0, mload(add(sig, 96)))
    }
}

// 批量铸造（仅所有者）
function mintBatch(address to, uint256 quantity) public onlyOwner {
    require(_tokenIds.current() + quantity <= maxSupply, "Exceeds max supply");
    
    for (uint256 i = 0; i < quantity; i++) {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _safeMint(to, newTokenId);
        emit TokenMinted(to, newTokenId);
    }
}

// 设置铸造价格
function setMintPrice(uint256 _price) public onlyOwner {
    mintPrice = _price;
}

// 设置最大供应量
function setMaxSupply(uint256 _maxSupply) public onlyOwner {
    require(_maxSupply >= _tokenIds.current(), "Cannot reduce below current supply");
    maxSupply = _maxSupply;
}

// 提取合约余额
function withdraw() public onlyOwner {
    uint256 balance = address(this).balance;
    payable(owner()).transfer(balance);
}

// 获取当前铸造的 token 数量
function totalSupply() public view returns (uint256) {
    return _tokenIds.current();
}

// 获取剩余可铸造数量
function remainingSupply() public view returns (uint256) {
    return maxSupply - _tokenIds.current();
}
}