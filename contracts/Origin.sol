// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

// Import ERC20
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenContract is ERC20 {
    event TokensMinted(uint256 amount, address receiver);
    event ContractDeployed(address deployer, uint256 initialSupply);

    /**
     * Constructor to create the ERC20 token contract.
     * _name The name of the token.
     * _symbol The symbol of the token.
     * _initialSupply The initial supply of the token.
     */
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply
    ) ERC20(_name, _symbol) {
        // mint all tokens and send them to the deployer's wallet
        _mint(msg.sender, _initialSupply * (10**uint256(18)));
        emit TokensMinted(_initialSupply, msg.sender);
        emit ContractDeployed(msg.sender, _initialSupply);
    }
}
