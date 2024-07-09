// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import {ZwapUSDC} from "../src/ZwapUSDC.sol";
import {Test} from "../lib/forge-std/src/Test.sol";

contract ZwapUSDCTest is Test {
    address constant VB = 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045;
    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    ZwapUSDC internal zwap;

    function setUp() public payable {
        vm.createSelectFork(vm.rpcUrl("main")); // Ethereum mainnet fork.
        zwap = new ZwapUSDC();
    }

    function testZwapReceive() public payable {
        vm.prank(VB);
        (bool ok,) = address(zwap).call{value: 1 ether}("");
        assert(ok);
    }
}

interface IERC20 {
    function balanceOf(address) external view returns (uint256);
}
