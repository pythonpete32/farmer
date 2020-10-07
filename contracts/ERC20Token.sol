pragma solidity ^0.6.0;

import './token/ERC20/ERC20.sol';

contract ERC20Token is ERC20{
  constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
        _mint(msg.sender, 1e18*100);
    }
}
