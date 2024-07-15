// SPDX-License-Identifier: AGPL-3.0-only
/*pragma solidity ^0.8.19;

import {ZwapUSDCArb} from "../src/ZwapUSDCArb.sol";
import {Test} from "../lib/forge-std/src/Test.sol";

contract ZwapUSDCArbTest is Test {
    address constant VB = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;
    address constant USDC = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;

    ZwapUSDCArb internal zwap;

    address alice;
    address bob;
    address charlie;

    function setUp() public payable {
        vm.createSelectFork(vm.rpcUrl("arbi")); // Arbitrum fork.
        zwap = new ZwapUSDCArb();
        alice = makeAddr("alice");
        bob = makeAddr("bob");
        charlie = makeAddr("charlie");
    }

    function testZwapInput() public payable {
        uint256 balanceBefore = IERC20(USDC).balanceOf(VB);
        vm.prank(VB);
        zwap.zwap{value: 0.000999 ether}(VB, 0.000999 ether);
        uint256 balanceAfter = IERC20(USDC).balanceOf(VB);
        assertTrue(balanceAfter > balanceBefore);
    }

    function testZwapZeroInput() public payable {
        uint256 balanceBefore = IERC20(USDC).balanceOf(VB);
        vm.prank(VB);
        zwap.zwap{value: 0.000999 ether}(VB, 0);
        uint256 balanceAfter = IERC20(USDC).balanceOf(VB);
        assertTrue(balanceAfter > balanceBefore);
    }

    function testZwapExactOutput() public payable {
        uint256 balanceBefore = IERC20(USDC).balanceOf(VB);
        vm.prank(VB);
        zwap.zwap{value: 0.000999 ether}(VB, -3000000);
        uint256 balanceAfter = IERC20(USDC).balanceOf(VB);
        assertEq(balanceAfter, balanceBefore + 3000000);
    }

    function testZwapReceive() public payable {
        uint256 balanceBefore = IERC20(USDC).balanceOf(VB);
        vm.prank(VB);
        (bool ok,) = address(zwap).call{value: 0.000999 ether}("");
        assert(ok);
        uint256 balanceAfter = IERC20(USDC).balanceOf(VB);
        assertTrue(balanceAfter > balanceBefore);
    }

    function testZwapDrop() public payable {
        ZwapUSDCArb.Drop[] memory drops = new ZwapUSDCArb.Drop[](3);
        drops[0].to = alice;
        drops[0].amount = 1000000;
        drops[1].to = bob;
        drops[1].amount = 1000000;
        drops[2].to = charlie;
        drops[2].amount = 1000000;
        uint256 balanceBefore = IERC20(USDC).balanceOf(alice);
        vm.prank(VB);
        zwap.zwapDrop{value: 0.000999 ether}(drops, 3000000);
        uint256 balanceAfter = IERC20(USDC).balanceOf(alice);
        assertTrue(balanceAfter > balanceBefore);
    }
}

interface IERC20 {
    function balanceOf(address) external view returns (uint256);
}
*/
