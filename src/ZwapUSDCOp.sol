// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.26;

/// @notice Swap ETH to USDC and make payments on the Optimism L2.
contract ZwapUSDCOp {
    address constant POOL = 0x1fb3cf6e48F1E7B10213E7b6d87D4c073C7Fdb7b;
    address constant USDC = 0x0b2C639c533813f4Aa9D7837CAf62653d097Ff85;
    address constant WETH = 0x4200000000000000000000000000000000000006;
    uint160 constant MAX_SQRT_RATIO_MINUS_ONE = 1461446703485210103287273052203988822378723970341;

    constructor() payable {}

    receive() external payable {
        zwap(msg.sender, int256(msg.value));
    }

    function zwap(address to, int256 amount) public payable {
        assembly ("memory-safe") {
            if iszero(amount) { amount := callvalue() }
        }
        ISwap(POOL).swap(to, false, amount, MAX_SQRT_RATIO_MINUS_ONE, "");
        _repay(address(this).balance);
    }

    fallback() external payable {
        assembly ("memory-safe") {
            let amount1Delta := calldataload(0x24)
            pop(call(gas(), WETH, amount1Delta, codesize(), 0x00, codesize(), 0x00))
            mstore(0x00, 0xa9059cbb000000000000000000000000)
            mstore(0x14, POOL)
            mstore(0x34, amount1Delta)
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
