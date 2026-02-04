// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {IVoter} from "../interfaces/governance/IVoter.sol";
import {IGovernanceToken} from "../interfaces/governance/IGovernanceToken.sol";
import {IMiner} from "../interfaces/mining/IMiner.sol";
import {ICore} from "../interfaces/franchise/ICore.sol";
import {IRig} from "../interfaces/franchise/IRig.sol";

/**
 * @title DonutDAOIntegration
 * @notice Example contract demonstrating integration with all DonutDAO systems
 * @dev This is a reference implementation - adapt for your specific use case
 */
contract DonutDAOIntegration {
    using SafeERC20 for IERC20;

    // Core contracts
    IGovernanceToken public immutable gDonut;
    IVoter public immutable voter;
    IMiner public immutable miner;
    ICore public immutable core;
    IERC20 public immutable donut;

    // Events
    event DonutMined(address indexed recipient, uint256 amount, uint256 cost);
    event VoteCast(address[] strategies, uint256[] weights);
    event TokenLaunched(address indexed unit, address indexed rig, address indexed launcher);
    event StakeUpdated(uint256 newBalance);

    constructor(
        address _gDonut,
        address _voter,
        address _miner,
        address _core,
        address _donut
    ) {
        gDonut = IGovernanceToken(_gDonut);
        voter = IVoter(_voter);
        miner = IMiner(_miner);
        core = ICore(_core);
        donut = IERC20(_donut);
    }

    // ============ GOVERNANCE FUNCTIONS ============

    /**
     * @notice Stake DONUT to get voting power
     * @param amount Amount of DONUT to stake
     */
    function stakeForVoting(uint256 amount) external {
        donut.safeTransferFrom(msg.sender, address(this), amount);
        donut.approve(address(gDonut), amount);
        gDonut.stake(amount);
        
        emit StakeUpdated(gDonut.balanceOf(address(this)));
    }

    /**
     * @notice Unstake gDONUT to get DONUT back
     * @param amount Amount of gDONUT to unstake
     */
    function unstake(uint256 amount) external {
        gDonut.unstake(amount);
        donut.safeTransfer(msg.sender, amount);
        
        emit StakeUpdated(gDonut.balanceOf(address(this)));
    }

    /**
     * @notice Vote for strategies with our staked weight
     * @param strategies Array of strategy addresses to vote for
     * @param weights Array of weights (basis points, sum to 10000)
     */
    function vote(address[] calldata strategies, uint256[] calldata weights) external {
        require(strategies.length == weights.length, "Length mismatch");
        
        uint256 totalWeight;
        for (uint i = 0; i < weights.length; i++) {
            totalWeight += weights[i];
        }
        require(totalWeight == 10000, "Weights must sum to 10000");
        
        voter.vote(strategies, weights);
        emit VoteCast(strategies, weights);
    }

    /**
     * @notice Claim bribe rewards from strategies we voted for
     * @param bribes Array of bribe contract addresses
     */
    function claimBribes(address[] calldata bribes) external {
        voter.claimBribes(bribes);
    }

    /**
     * @notice Get our current voting power
     * @return Voting power (gDONUT balance)
     */
    function getVotingPower() external view returns (uint256) {
        return gDonut.balanceOf(address(this));
    }

    // ============ MINING FUNCTIONS ============

    /**
     * @notice Mine DONUT by providing ETH
     * @param recipient Address to receive mined DONUT
     * @param amount Amount of DONUT to mine
     */
    function mineDonut(address recipient, uint256 amount) external payable {
        uint256 cost = miner.quote(amount);
        require(msg.value >= cost, "Insufficient ETH");
        
        miner.mint{value: cost}(recipient, amount);
        emit DonutMined(recipient, amount, cost);
        
        // Refund excess
        if (msg.value > cost) {
            payable(msg.sender).transfer(msg.value - cost);
        }
    }

    /**
     * @notice Check current DONUT mining price
     * @return Price per DONUT in wei
     */
    function getCurrentMiningPrice() external view returns (uint256) {
        return miner.quotePrice();
    }

    /**
     * @notice Calculate cost to mine specific amount
     * @param donutAmount Amount of DONUT to mine
     * @return Cost in wei
     */
    function calculateMiningCost(uint256 donutAmount) external view returns (uint256) {
        return miner.quote(donutAmount);
    }

    /**
     * @notice Check if mining is profitable vs market price
     * @param marketPrice Current DONUT market price (from DEX)
     * @return profitable True if mining is cheaper than buying
     * @return savingsPercent Percentage saved by mining (basis points)
     */
    function checkMiningProfitability(uint256 marketPrice) 
        external 
        view 
        returns (bool profitable, uint256 savingsPercent) 
    {
        uint256 minerPrice = miner.quotePrice();
        
        if (minerPrice < marketPrice) {
            profitable = true;
            savingsPercent = ((marketPrice - minerPrice) * 10000) / marketPrice;
        }
    }

    // ============ FRANCHISE FUNCTIONS ============

    /**
     * @notice Launch a new token via Franchise
     * @param params Launch parameters
     * @return unit New token address
     * @return rig Mining contract address
     * @return auction Auction contract address
     * @return lpToken LP token address
     */
    function launchToken(ICore.LaunchParams calldata params) 
        external 
        returns (
            address unit,
            address rig,
            address auction,
            address lpToken
        ) 
    {
        // Transfer DONUT from launcher
        donut.safeTransferFrom(msg.sender, address(this), params.donutAmount);
        donut.approve(address(core), params.donutAmount);
        
        // Launch token
        (unit, rig, auction, lpToken) = core.launch(params);
        
        emit TokenLaunched(unit, rig, msg.sender);
    }

    /**
     * @notice Mine a launched token via Rig
     * @param rigAddress Rig contract address
     * @param epochId Current epoch ID
     * @param deadline Transaction deadline
     * @param maxPrice Maximum price willing to pay
     * @param epochUri Epoch metadata URI
     * @dev See IRig interface for mine() details
     */
    function mineLaunchedToken(
        address rigAddress,
        uint256 epochId,
        uint256 deadline,
        uint256 maxPrice,
        string memory epochUri
    ) external returns (uint256 price) {
        IRig rig = IRig(rigAddress);
        price = rig.mine(msg.sender, epochId, deadline, maxPrice, epochUri);
    }

    /**
     * @notice Get all deployed rigs
     * @return Array of rig addresses
     */
    function getAllRigs() external view returns (address[] memory) {
        uint256 length = core.deployedRigsLength();
        address[] memory rigs = new address[](length);
        
        for (uint i = 0; i < length; i++) {
            rigs[i] = core.deployedRigs(i);
        }
        
        return rigs;
    }

    /**
     * @notice Check if a rig is legitimate (deployed by Core)
     * @param rigAddress Rig to check
     * @return True if deployed by Core contract
     */
    function isLegitimateRig(address rigAddress) external view returns (bool) {
        return core.isDeployedRig(rigAddress);
    }

    // ============ COMBINED STRATEGIES ============

    /**
     * @notice Automated strategy: Mine DONUT if profitable, stake for voting
     * @param targetDonutAmount Amount of DONUT to acquire
     * @param marketPrice Current market price for profitability check
     */
    function autoAcquireAndStake(uint256 targetDonutAmount, uint256 marketPrice) external payable {
        uint256 minerPrice = miner.quotePrice();
        
        // Mine if cheaper than market
        if (minerPrice < marketPrice) {
            uint256 cost = miner.quote(targetDonutAmount);
            require(msg.value >= cost, "Insufficient ETH");
            
            miner.mint{value: cost}(address(this), targetDonutAmount);
            emit DonutMined(address(this), targetDonutAmount, cost);
            
            // Refund excess
            if (msg.value > cost) {
                payable(msg.sender).transfer(msg.value - cost);
            }
        } else {
            // Would buy from DEX here in production
            revert("Mining not profitable, implement DEX purchase");
        }
        
        // Stake acquired DONUT
        donut.approve(address(gDonut), targetDonutAmount);
        gDonut.stake(targetDonutAmount);
        emit StakeUpdated(gDonut.balanceOf(address(this)));
    }

    /**
     * @notice Get comprehensive protocol stats
     * @return totalStaked Total DONUT staked in governance
     * @return votingPower Our voting power
     * @return currentDPS Current DONUT emission rate
     * @return totalRigs Total tokens launched
     */
    function getProtocolStats() 
        external 
        view 
        returns (
            uint256 totalStaked,
            uint256 votingPower,
            uint256 currentDPS,
            uint256 totalRigs
        ) 
    {
        totalStaked = gDonut.totalSupply();
        votingPower = gDonut.balanceOf(address(this));
        currentDPS = miner.getDPS();
        totalRigs = core.deployedRigsLength();
    }

    // ============ UTILITY FUNCTIONS ============

    /**
     * @notice Rescue any ERC20 tokens sent to this contract
     * @param token Token address
     * @param amount Amount to rescue
     */
    function rescueTokens(address token, uint256 amount) external {
        IERC20(token).safeTransfer(msg.sender, amount);
    }

    /**
     * @notice Rescue any ETH sent to this contract
     */
    function rescueETH() external {
        payable(msg.sender).transfer(address(this).balance);
    }

    // Allow receiving ETH
    receive() external payable {}
}
