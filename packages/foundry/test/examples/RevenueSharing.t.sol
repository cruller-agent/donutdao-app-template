// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../contracts/examples/RevenueSharing.sol";

// Mock LiquidSignal for testing
contract MockLiquidSignal {
    uint256 public tvl;
    
    function deposit() external payable {
        tvl += msg.value;
    }
    
    function getTVL() external view returns (uint256) {
        return tvl;
    }
}

contract RevenueSharingTest is Test {
    RevenueSharing public app;
    MockLiquidSignal public mockSignal;
    address public team;
    address public user;
    
    function setUp() public {
        team = address(0x1);
        user = address(0x2);
        
        mockSignal = new MockLiquidSignal();
        app = new RevenueSharing(address(mockSignal), team);
        
        vm.deal(user, 10 ether);
    }
    
    function testRevenueS plit() public {
        vm.prank(user);
        app.useService{value: 1 ether}();
        
        // Check 50/50 split
        assertEq(mockSignal.tvl(), 0.5 ether, "Signal should receive 50%");
        assertEq(team.balance, 0.5 ether, "Team should receive 50%");
    }
    
    function testStats() public {
        vm.prank(user);
        app.useService{value: 1 ether}();
        
        (uint256 revenue, uint256 toSignal, uint256 toTeam, uint256 signalTVL) = app.getStats();
        
        assertEq(revenue, 1 ether);
        assertEq(toSignal, 0.5 ether);
        assertEq(toTeam, 0.5 ether);
        assertEq(signalTVL, 0.5 ether);
    }
    
    function testMultiplePayments() public {
        vm.startPrank(user);
        app.useService{value: 1 ether}();
        app.useService{value: 2 ether}();
        vm.stopPrank();
        
        assertEq(mockSignal.tvl(), 1.5 ether);
        assertEq(team.balance, 1.5 ether);
    }
    
    function testRevertsOnZeroPayment() public {
        vm.prank(user);
        vm.expectRevert(RevenueSharing.InvalidAmount.selector);
        app.useService{value: 0}();
    }
    
    function testFuzzRevenueSplit(uint96 amount) public {
        vm.assume(amount > 0);
        vm.deal(user, amount);
        
        vm.prank(user);
        app.useService{value: amount}();
        
        uint256 expectedHalf = uint256(amount) / 2;
        assertApproxEqRel(mockSignal.tvl(), expectedHalf, 0.01e18); // 1% tolerance for rounding
    }
}
