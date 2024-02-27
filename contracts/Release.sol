// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TokenLock.sol";

contract NoEvmRelease is EVM_side {
    address public evmBridge; // Address of the EVM bridge contract
    IERC20 public token; // Declare the ERC20 token contract

    event TokensReleased(address indexed receiver, uint256 amount);
    event ContractDeployed(address evmBridge, address tokenContract);

    
    //Modifier to restrict functions to be called only by the EVM bridge.
    modifier onlyEvmBridge() {
        require(msg.sender == evmBridge, "Only EVM bridge can call this function");
        _;
    }

    /**
     * Constructor to set the EVM bridge address and ERC20 token contract.
     * _evmBridge The address of the EVM bridge contract.
     * _tokenAddress The address of the ERC20 token contract.
     */
    constructor(address _evmBridge, address _tokenAddress) {
        evmBridge = _evmBridge;
        token = IERC20(_tokenAddress); // Assign the ERC20 token contract address to the token variable

        emit ContractDeployed(_evmBridge, _tokenAddress);
    }

    /**
     * Function to release tokens on the non-EVM chain on confirmation from the EVM side.
     * receiver The address to receive the released tokens.
     * amount The amount of tokens to release.
     */
    function releaseTokens(address receiver, uint256 amount) external onlyEvmBridge {
        require(centralizedVerification(msg.sender, receiver, amount), "Lock event verification failed");

        token.transfer(receiver, amount);

        // Emit event indicating tokens have been released
        emit TokensReleased(receiver, amount);
    }

     /*In this case, the `centralizedVerification` function does not read or modify the state of the contract, it simply performs a simple data validation check. 
     Therefore, to adhere to best practices and optimize gas costs, I had used `pure` instead of `view`.*/
    function centralizedVerification(address sender, address receiver, uint256 amount) internal pure returns (bool) {
        require(receiver != address(0) && amount > 0, "Invalid receiver address or amount");
        return true;
    }
}
