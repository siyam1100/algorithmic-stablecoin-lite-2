# Algorithmic Stablecoin Lite

A professional-grade repository demonstrating the core mechanics of an algorithmic stablecoin. This project uses a dual-token inflationary/deflationary model to maintain a $1.00 peg through on-chain incentives.

## System Architecture



* **StableToken (CASH)**: The asset pegged to $1.00.
* **ShareToken (BOND)**: The utility token used to recapitalize the system or receive rewards during expansion.
* **Treasury**: The "Brain" of the protocol that interacts with an Oracle to determine if it needs to mint new supply or buy back tokens.

## Mechanics
1. **Expansion**: If Price > $1.00, the Treasury mints new CASH and distributes it to BOND stakers.
2. **Contraction**: If Price < $1.00, the Treasury allows users to burn CASH in exchange for discounted BONDs to reduce circulating supply.

## Security
* **Epoch-based updates**: Supply adjustments happen only once every fixed period (e.g., 8 hours).
* **Oracle Guard**: Implements checks to prevent manipulation of the price feed.

## License
MIT
