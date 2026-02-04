// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * @title IMiner
 * @notice Interface for the Donut Miner contract - autonomous token minting via bonding curve
 */
interface IMiner {
    // Constants
    function FEE() external pure returns (uint256);
    function DIVISOR() external pure returns (uint256);
    function PRECISION() external pure returns (uint256);
    function EPOCH_PERIOD() external pure returns (uint256);
    function PRICE_MULTIPLIER() external pure returns (uint256);
    function MIN_INIT_PRICE() external pure returns (uint256);
    function INITIAL_DPS() external pure returns (uint256);
    function HALVING_PERIOD() external pure returns (uint256);
    function TAIL_DPS() external pure returns (uint256);

    // State
    function donut() external view returns (address);
    function quote() external view returns (address);
    function startTime() external view returns (uint256);
    function treasury() external view returns (address);
    
    // Epoch info
    function currentEpochId() external view returns (uint256);
    function initPrice() external view returns (uint256);
    function dps() external view returns (uint256);
    function epochStartTime() external view returns (uint256);
    
    // Core functions
    function mint(address to, uint256 amount) external payable returns (uint256 quoteRequired);
    function quote(uint256 donutAmount) external view returns (uint256 quoteRequired);
    function quotePrice() external view returns (uint256);
    function setMiner(address _miner) external;
    function setTreasury(address _treasury) external;
    function setInitPrice(uint256 _initPrice) external;
    
    // View functions
    function getDPS() external view returns (uint256);
    function getCurrentEpochId() external view returns (uint256);
    function getEpochDonutsMined(uint256 epochId) external view returns (uint256);
    
    // Events
    event Mint(address indexed to, uint256 donutAmount, uint256 quoteAmount, uint256 fee);
    event SetMiner(address indexed miner);
    event SetTreasury(address indexed treasury);
    event SetInitPrice(uint256 initPrice);
}
