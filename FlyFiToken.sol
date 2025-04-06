// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title FlyFiToken
 * @dev Biologically-inspired ERC-20 token with optional impulse-based transaction metadata.
 */
contract FlyFiToken is ERC20, Ownable {
    uint256 private constant INITIAL_SUPPLY = 1_000_000_000 * 10 ** 18;

    // Optional: Track last impulse per address to implement cooldown logic
    mapping(address => uint256) public lastImpulse;

    // Impulse structure to simulate bio-inspired metadata
    struct Impulse {
        uint256 signalStrength;
        address initiator;
        uint256 timestamp;
    }

    event ImpulseSent(address indexed from, address indexed to, uint256 amount, uint256 signalStrength);

    constructor() ERC20("FlyFi", "FLY") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    /**
     * @notice Sends tokens with impulse metadata (optional, lightweight)
     * @param to recipient address
     * @param amount token amount
     * @param signalStrength optional metadata (0–100 scale)
     */
    function transferWithImpulse(address to, uint256 amount, uint256 signalStrength) public returns (bool) {
        require(block.timestamp > lastImpulse[msg.sender] + 2, "Impulse too soon.");
        _transfer(msg.sender, to, amount);
        lastImpulse[msg.sender] = block.timestamp;

        emit ImpulseSent(msg.sender, to, amount, signalStrength);
        return true;
    }

    /**
     * @notice Admin can burn tokens from any address (DAO controlled in future)
     */
    function burn(address from, uint256 amount) public onlyOwner {
        _burn(from, amount);
    }
}
