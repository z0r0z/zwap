// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.26;

contract ZwapUSDC {
    address constant POOL = 0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640;
    address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    constructor() payable {}

    receive() external payable {
        assembly ("memory-safe") {
            mstore(0x00, hex"128acb08")
            mstore(0x04, caller())
            mstore(0x24, 0)
            mstore(0x44, callvalue())
            mstore(0x64, 1461446703485210103287273052203988822378723970341)
            mstore(0x84, 0xa0)
            pop(call(gas(), POOL, 0, 0x00, 0x104, codesize(), 0x00))
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
        }
    }
}
