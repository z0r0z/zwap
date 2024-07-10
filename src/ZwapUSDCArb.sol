// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.26;

/// @notice Swap ETH to USDC for any senders.
contract ZwapUSDCArb {
    address constant POOL = 0xC6962004f452bE9203591991D15f6b388e09E8D0;
    address constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;

    constructor() payable {}

    receive() external payable {
        assembly ("memory-safe") {
            mstore(0x00, 0x128acb08000000000000000000000000)
            mstore(0x14, caller())
            mstore(0x34, 1)
            mstore(0x54, callvalue())
            mstore(0x74, 4295128740)
            mstore(0x94, 0xa0)
            pop(call(gas(), POOL, 0, 0x10, 0x104, codesize(), 0x00))
        }
    }

    fallback() external payable {
        assembly ("memory-safe") {
            let amount0Delta := calldataload(0x4)
            pop(call(gas(), WETH, amount0Delta, codesize(), 0x00, codesize(), 0x00))
            mstore(0x00, 0xa9059cbb000000000000000000000000)
            mstore(0x14, POOL)
            mstore(0x34, amount0Delta)
            pop(call(gas(), WETH, 0, 0x10, 0x44, codesize(), 0x00))
        }
    }
}
