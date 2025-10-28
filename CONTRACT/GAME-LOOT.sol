// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title GAMELOOT
 * @dev A simple play-to-earn reward ecosystem where players earn points
 *      and claim rewards from a funded pool.
 */
contract GAMELOOT {
    address public owner;
    uint256 public totalPool; // Total ETH available for rewards
    mapping(address => uint256) public playerPoints;

    event PoolFunded(address indexed sender, uint256 amount);
    event PointsEarned(address indexed player, uint256 points);
    event RewardClaimed(address indexed player, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Fund the reward pool (only owner)
    function fundPool() external payable onlyOwner {
        require(msg.value > 0, "Must send ETH to fund the pool");
        totalPool += msg.value;
        emit PoolFunded(msg.sender, msg.value);
    }

    /// @notice Players earn points by playing (simulated here)
    function playGame(uint256 score) external {
        require(score > 0, "Score must be positive");
        uint256 pointsEarned = score / 10; // Simple formula: 10 score = 1 point
        playerPoints[msg.sender] += pointsEarned;
        emit PointsEarned(msg.sender, pointsEarned);
    }

    /// @notice Claim rewards based on earned points
    function claimReward() external {
        uint256 points = playerPoints[msg.sender];
        require(points > 0, "No points to redeem");
        uint256 reward = points * 0.001 ether; // 1 point = 0.001 ETH
        require(address(this).balance >= reward, "Not enough funds in pool");

        playerPoints[msg.sender] = 0;
        totalPool -= reward;

        payable(msg.sender).transfer(reward);
        emit RewardClaimed(msg.sender, reward);
    }
}

