// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.26;

/// @notice Swap ETH to USDC and make payments on the Arbitrum L2.
contract ZwapUSDCArb {
    address constant POOL = 0xC6962004f452bE9203591991D15f6b388e09E8D0;
    address constant USDC = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
    address constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
    uint160 internal constant MIN_SQRT_RATIO_PLUS_ONE = 4295128740;

    constructor() payable {}

    receive() external payable {
        zwap(msg.sender, int256(msg.value));
    }

    function zwap(address to, int256 amount) public payable {
        assembly ("memory-safe") {
            if iszero(amount) { amount := callvalue() }
        }
        ISwap(POOL).swap(to, true, amount, MIN_SQRT_RATIO_PLUS_ONE, "");
        _repay(address(this).balance);
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

    function _repay(uint256 dust) internal {
        assembly ("memory-safe") {
            if dust { pop(call(gas(), caller(), dust, codesize(), 0x00, codesize(), 0x00)) }
        }
    }

    struct Drop {
        address to;
        uint256 amount;
    }

    function zwapDrop(Drop[] calldata drops, uint256 sum) public payable {
        zwap(address(this), -int256(sum));
        for (uint256 i; i != drops.length; ++i) {
            _transfer(drops[i].to, drops[i].amount);
        }
    }

    function _transfer(address to, uint256 amount) internal {
        assembly ("memory-safe") {
            mstore(0x00, 0xa9059cbb000000000000000000000000)
            mstore(0x14, to)
            mstore(0x34, amount)
            pop(call(gas(), USDC, 0, 0x10, 0x44, codesize(), 0x00))
        }
    }
}

/// @dev Minimal Uniswap V3 swap interface.
interface ISwap {
    function swap(address, bool, int256, uint160, bytes calldata)
        external
        returns (int256, int256);
}
