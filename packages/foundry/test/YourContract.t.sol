// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/YourContract.sol";

contract YourContractTest is Test {
    YourContract public yourContract;
    address public owner;
    address public user;
    
    function setUp() public {
        owner = address(this);
        user = address(0x1);
        yourContract = new YourContract();
    }
    
    function testInitialState() public {
        assertEq(yourContract.owner(), owner);
        assertEq(yourContract.counter(), 0);
    }
    
    function testIncrement() public {
        yourContract.increment();
        assertEq(yourContract.counter(), 1);
        
        yourContract.increment();
        assertEq(yourContract.counter(), 2);
    }
    
    function testIncrementByUser() public {
        vm.prank(user);
        yourContract.increment();
        assertEq(yourContract.counter(), 1);
    }
    
    function testTransferOwnership() public {
        yourContract.transferOwnership(user);
        assertEq(yourContract.owner(), user);
    }
    
    function testTransferOwnershipOnlyOwner() public {
        vm.prank(user);
        vm.expectRevert(YourContract.OnlyOwner.selector);
        yourContract.transferOwnership(user);
    }
    
    function testTransferOwnershipZeroAddress() public {
        vm.expectRevert(YourContract.ZeroAddress.selector);
        yourContract.transferOwnership(address(0));
    }
    
    function testFuzzIncrement(uint8 iterations) public {
        for (uint256 i = 0; i < iterations; i++) {
            yourContract.increment();
        }
        assertEq(yourContract.counter(), iterations);
    }
}
