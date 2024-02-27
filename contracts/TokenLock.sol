// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract EVM_side {
    event TokensLocked(address indexed sender, address indexed targetChain, address indexed receiver, uint256 amount);

    /*
     * Locks ERC20 tokens in this contract to be transferred to another chain.
     * amount The amount of tokens to lock.
     * targetChain The address of the target chain where the tokens will be moved.
     * tokenAddress The address of the ERC20 token contract.
     * receiver The address on the target chain to receive the tokens.
     */
    function lockERC20(address tokenAddress, uint256 amount, address targetChain, address receiver) external {
        require(tokenAddress != address(0), "Invalid token address");
        require(amount > 0, "Invalid amount");
        require(targetChain != address(0), "Invalid target chain address");
        require(receiver != address(0), "Invalid receiver address");

        IERC20 token = IERC20(tokenAddress);
        require(token.transferFrom(msg.sender, address(this), amount), "Token transfer failed");

        emit TokensLocked(msg.sender, targetChain, receiver, amount);
    }

    /**
     * Locks native ETH in this contract to be transferred to another chain.
     * targetChain The address of the target chain where the ETH will be moved.
     * receiver The address on the target chain to receive the ETH.
     */
    function lockETH(address targetChain, address receiver) external payable {
        require(msg.value > 0, "Invalid ETH amount");
        require(targetChain != address(0), "Invalid target chain address");
        require(receiver != address(0), "Invalid receiver address");

        emit TokensLocked(msg.sender, targetChain, receiver, msg.value);
    }
}
