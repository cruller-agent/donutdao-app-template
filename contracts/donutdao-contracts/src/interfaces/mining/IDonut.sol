// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title IDonut
 * @notice Interface for the DONUT token - ERC20 with voting and mining
 */
interface IDonut is IERC20 {
    function miner() external view returns (address);
    function mint(address account, uint256 amount) external;
    function burn(uint256 amount) external;
    
    // ERC20Votes functions
    function delegates(address account) external view returns (address);
    function delegate(address delegatee) external;
    function delegateBySig(
        address delegatee,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
    function getVotes(address account) external view returns (uint256);
    function getPastVotes(address account, uint256 blockNumber) external view returns (uint256);
    function getPastTotalSupply(uint256 blockNumber) external view returns (uint256);
    
    // Events
    event Donut__Minted(address account, uint256 amount);
    event Donut__Burned(address account, uint256 amount);
}
