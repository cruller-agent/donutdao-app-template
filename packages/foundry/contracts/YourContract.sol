// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title YourContract
 * @dev Replace this with your actual contract logic
 * @notice This is a starter template - customize for your needs
 */
contract YourContract {
    // State variables
    address public owner;
    uint256 public counter;
    
    // Events
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event CounterIncremented(address indexed incrementer, uint256 newValue);
    
    // Errors
    error OnlyOwner();
    error ZeroAddress();
    
    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }
    
    /**
     * @dev Increment the counter
     * @notice Anyone can call this function
     */
    function increment() external {
        counter++;
        emit CounterIncremented(msg.sender, counter);
    }
    
    /**
     * @dev Transfer ownership
     * @param newOwner Address of the new owner
     */
    function transferOwnership(address newOwner) external {
        if (msg.sender != owner) revert OnlyOwner();
        if (newOwner == address(0)) revert ZeroAddress();
        
        address previousOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(previousOwner, newOwner);
    }
    
    /**
     * @dev Get current counter value
     * @return Current counter value
     */
    function getCounter() external view returns (uint256) {
        return counter;
    }
}
