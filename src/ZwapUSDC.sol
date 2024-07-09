// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.26;

/// @notice Swap for and send USDC from ETH.
contract ZwapUSDC {
    address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address constant POOL = 0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640;
    uint160 constant MAX_SQRT_RATIO_MINUS_ONE = 1461446703485210103287273052203988822378723970341;

    /// @dev Swap `msg.value` ETH into USDC for `to`.
    function zwap(address to) public payable {
        ISwap(POOL).swap(to, false, int256(msg.value), MAX_SQRT_RATIO_MINUS_ONE, "");
    }

    /// @dev `uniswapV3SwapCallback`.
    /// Settles ETH/WETH transfers.
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

    /// @dev Receive and `zwap()`.
    receive() external payable {
        zwap(msg.sender);
    }
}

/// @dev Simple Uniswap V3 swapping interface.
interface ISwap {
    function swap(address, bool, int256, uint160, bytes calldata)
        external
        returns (int256, int256);
}
