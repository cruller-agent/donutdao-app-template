// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RevenueSharing
 * @notice Example: Route revenue to DonutDAO's LiquidSignal
 * @dev This contract demonstrates how to integrate with LiquidSignal
 *      to share revenue with gDONUT holders
 */

interface ILiquidSignal {
    function deposit() external payable;
    function getTVL() external view returns (uint256);
}

contract RevenueSharing {
    ILiquidSignal public immutable liquidSignal;
    address public immutable team;
    
    // Revenue split percentages (basis points: 100 = 1%)
    uint256 public constant SIGNAL_SHARE_BPS = 5000; // 50%
    uint256 public constant TEAM_SHARE_BPS = 5000;   // 50%
    
    // Stats
    uint256 public totalRevenueCollected;
    uint256 public totalToSignal;
    uint256 public totalToTeam;
    
    event RevenueCollected(
        address indexed payer,
        uint256 amount,
        uint256 toSignal,
        uint256 toTeam
    );
    
    error TransferFailed();
    error InvalidAmount();
    
    /**
     * @param _liquidSignal Address of LiquidSignal contract on Base
     * @param _team Address to receive team share
     */
    constructor(address _liquidSignal, address _team) {
        liquidSignal = ILiquidSignal(_liquidSignal);
        team = _team;
    }
    
    /**
     * @notice Pay for service, revenue is split between LiquidSignal and team
     */
    function useService() external payable {
        if (msg.value == 0) revert InvalidAmount();
        
        // Calculate splits
        uint256 toSignal = (msg.value * SIGNAL_SHARE_BPS) / 10000;
        uint256 toTeam = msg.value - toSignal;
        
        // Update stats
        totalRevenueCollected += msg.value;
        totalToSignal += toSignal;
        totalToTeam += toTeam;
        
        // Route to LiquidSignal (gDONUT holders)
        liquidSignal.deposit{value: toSignal}();
        
        // Send to team
        (bool success, ) = team.call{value: toTeam}("");
        if (!success) revert TransferFailed();
        
        emit RevenueCollected(msg.sender, msg.value, toSignal, toTeam);
    }
    
    /**
     * @notice Get revenue statistics
     */
    function getStats() external view returns (
        uint256 revenue,
        uint256 toSignal,
        uint256 toTeam,
        uint256 signalTVL
    ) {
        return (
            totalRevenueCollected,
            totalToSignal,
            totalToTeam,
            liquidSignal.getTVL()
        );
    }
}
