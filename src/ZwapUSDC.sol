// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.26;

/// @notice Swap ETH to USDC and make payments.
contract ZwapUSDC {
    address constant POOL = 0x88e6A0c2dDD26FEEb64F039a2c41296FcB3f5640;
    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
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
        _transfer(msg.sender, _balanceOfThis());
    }

    function _transfer(address to, uint256 amount) internal {
        assembly ("memory-safe") {
            mstore(0x00, 0xa9059cbb000000000000000000000000)
            mstore(0x14, to)
            mstore(0x34, amount)
            pop(call(gas(), USDC, 0, 0x10, 0x44, codesize(), 0x00))
        }
    }

    function _balanceOfThis() internal view returns (uint256 amount) {
        assembly ("memory-safe") {
            mstore(0x00, 0x70a08231000000000000000000000000)
            mstore(0x14, address())
            pop(staticcall(gas(), USDC, 0x10, 0x24, 0x20, 0x20))
            amount := mload(0x20)
        }
    }
}

/// @dev Minimal Uniswap V3 swap interface.
interface ISwap {
    function swap(address, bool, int256, uint160, bytes calldata)
        external
        returns (int256, int256);
}
