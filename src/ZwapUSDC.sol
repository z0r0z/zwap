// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.26;

/// @notice Swap any ETH sent to this contract into USDC at market rate.
contract ZwapUSDC {
    bytes32 constant WETH = 0x000000000000000000000000C02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    bytes32 constant POOL = 0x00000000000000000000000088e6A0c2dDD26FEEb64F039a2c41296FcB3f5640;
    uint256 constant MAX_SQRT_RATIO_MINUS_ONE = 1461446703485210103287273052203988822378723970341;

    receive() external payable {
        assembly ("memory-safe") {
            mstore(0x00, hex"128acb08")
            mstore(0x04, caller())
            mstore(0x24, 0)
            mstore(0x44, callvalue())
            mstore(0x64, MAX_SQRT_RATIO_MINUS_ONE)
            mstore(0x84, 0xa0)
            mstore(0xa4, 0)
            pop(call(gas(), POOL, 0, 0x00, 0xc4, codesize(), 0x00))
        }
    }

    fallback() external payable {
        assembly ("memory-safe") {
            let amount1Delta := calldataload(0x24)
            if iszero(eq(caller(), POOL)) { revert(codesize(), 0x00) }
            pop(call(gas(), WETH, amount1Delta, codesize(), 0x00, codesize(), 0x00))
            mstore(0x14, POOL)
            mstore(0x34, amount1Delta)
            mstore(0x00, 0xa9059cbb000000000000000000000000)
            pop(call(gas(), WETH, 0, 0x10, 0x44, codesize(), 0x00))
            mstore(0x34, 0)
        }
    }
}
