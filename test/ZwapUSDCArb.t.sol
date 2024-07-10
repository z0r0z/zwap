// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import {ZwapUSDCArb} from "../src/ZwapUSDCArb.sol";
import {Test} from "../lib/forge-std/src/Test.sol";

contract ZwapUSDCArbTest is Test {
    address constant VB = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;
    address constant USDC = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;

    ZwapUSDCArb internal zwap;

    function setUp() public payable {
        vm.createSelectFork(vm.rpcUrl("arbi")); // Arbitrum fork.
        zwap = new ZwapUSDCArb();
    }

    function testZwapReceive() public payable {
        uint256 balanceBefore = IERC20(USDC).balanceOf(VB);
        vm.prank(VB);
        (bool ok,) = address(zwap).call{value: 0.000999 ether}("");
        assert(ok);
        uint256 balanceAfter = IERC20(USDC).balanceOf(VB);
        assertTrue(balanceAfter > balanceBefore);
    }
}

interface IERC20 {
    function balanceOf(address) external view returns (uint256);
}
