// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts@5.3.0/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts@5.3.0/token/ERC20/extensions/ERC20Permit.sol";
import {Ownable} from "@openzeppelin/contracts@5.3.0/access/Ownable.sol";

contract YYToken is ERC20, Ownable, ERC20Permit {
    constructor(address initialOwner)
        ERC20("YYToken", "YY")
        Ownable(initialOwner)
        ERC20Permit("YYToken")
    {}
    // 18 18个0  1,0000,0000,0000,0000,00

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}