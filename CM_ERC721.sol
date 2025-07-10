// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CM is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    // 最大供应量
    uint256 public maxSupply = 1000;
    
    // 铸造价格
    uint256 public mintPrice = 0 ether; // 免费铸造用于测试
    
    // 基础 URI
    string private _baseTokenURI;
    
    // 合约 URI
    string private _contractURI;
    
    // 事件
    event TokenMinted(address indexed to, uint256 indexed tokenId);
    event MetadataUpdated(uint256 indexed tokenId);
    
    constructor() ERC721("CM", "CM") Ownable(msg.sender) {
        _baseTokenURI = "";
        _contractURI = "";
    }
    
    // 铸造函数
    function mint() public payable {
        require(_tokenIds.current() < maxSupply, "Max supply reached");
        require(msg.value >= mintPrice, "Insufficient payment");
        
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        
        _safeMint(msg.sender, newTokenId);
        
        emit TokenMinted(msg.sender, newTokenId);
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
    
    // 设置基础 URI
    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }
    
    // 设置合约 URI
    function setContractURI(string memory _contractURIParam) public onlyOwner {
        _contractURI = _contractURIParam;
    }
    
    // 获取合约 URI
    function contractURI() public view returns (string memory) {
        return _contractURI;
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
    
    // 重写 _baseURI 函数
    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
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