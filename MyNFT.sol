// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TestERC721 is ERC721Enumerable, Ownable {
    string private _tokenURI;

    constructor() ERC721("YYNFT", "YY") Ownable(msg.sender) {}

    function mint(address to, uint256 tokenId) external onlyOwner {
        _mint(to, tokenId);
    }

    mapping(uint256 tokenID => string uri) uris;

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return uris[tokenId];
    }

    function setTokenURI(string memory newTokenURI, uint256 id) external onlyOwner {
        // _tokenURI = newTokenURI;
        uris[id] = newTokenURI;
    }
}