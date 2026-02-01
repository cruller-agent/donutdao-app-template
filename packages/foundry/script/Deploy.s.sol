// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/YourContract.sol";

/**
 * @title Deploy Script
 * @dev Deploy YourContract to any network
 * 
 * Usage:
 *   forge script script/Deploy.s.sol --rpc-url base --broadcast --verify
 */
contract Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy YourContract
        YourContract yourContract = new YourContract();
        
        console.log("YourContract deployed to:", address(yourContract));
        console.log("Owner:", yourContract.owner());
        
        vm.stopBroadcast();
    }
}
