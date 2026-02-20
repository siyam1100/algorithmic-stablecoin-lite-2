// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title Treasury
 * @dev Manages the supply of the stablecoin based on price oracle data.
 */
contract Treasury is Ownable, ReentrancyGuard {
    IERC20 public cash;
    IERC20 public bond;
    
    uint256 public constant TARGET_PRICE = 1e18; // $1.00 (18 decimals)
    uint256 public lastEpochTime;
    uint256 public epochLength = 8 hours;

    event SupplyExpanded(uint256 amount);
    event SupplyContracted(uint256 amount);

    constructor(address _cash, address _bond) Ownable(msg.sender) {
        cash = IERC20(_cash);
        bond = IERC20(_bond);
    }

    /**
     * @dev Adjusts supply. In a real scenario, this is triggered by a Keeper or Bot.
     * @param currentPrice The price of CASH from an Oracle (e.g., Chainlink).
     */
    function allocateSeigniorage(uint256 currentPrice) external onlyOwner {
        require(block.timestamp >= lastEpochTime + epochLength, "Epoch not reached");
        
        if (currentPrice > TARGET_PRICE) {
            uint256 percentage = (currentPrice - TARGET_PRICE) * 100 / TARGET_PRICE;
            uint256 mintAmount = (IERC20(cash).totalSupply() * percentage) / 100;
            // Logic to mint and distribute to stakers would go here
            emit SupplyExpanded(mintAmount);
        } else if (currentPrice < TARGET_PRICE) {
            // Logic to issue bonds at a discount
            emit SupplyContracted(TARGET_PRICE - currentPrice);
        }
        
        lastEpochTime = block.timestamp;
    }
}
