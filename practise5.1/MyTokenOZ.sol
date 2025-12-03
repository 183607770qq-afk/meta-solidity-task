// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract MyTokenOZ is ERC20, Ownable, ERC20Burnable {
    constructor(uint256 initialSupply) ERC20("My Token", "MTK")Ownable(msg.sender) {
        _mint(msg.sender, initialSupply * 10**decimals());
    }
    
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}