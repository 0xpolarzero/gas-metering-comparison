// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console2 as console} from "forge-std/Test.sol";

import {MockERC20} from "src/MockERC20.sol";

/// @dev Compare Forge gas measurements with Sepolia testnet txs
/// Note: There should be a difference of 600 gas between the two tests,
/// due to the difference between zero and non-zero bytes in the call data.
/// However, Forge fails to measure the difference and returns the exact same
/// gas usage for both tests.
/// Edit: Forge precisely measures gas costs with `--isolate` flag.
/// See https://github.com/foundry-rs/foundry/pull/7186

contract MockERC20Foundry is Test {
    MockERC20 mockERC20;

    uint256 constant MINT_ITERATIONS = 10;

    function setUp() public {
        mockERC20 = new MockERC20();
    }

    // 1. https://sepolia.etherscan.io/tx/0x886c7e6d86a3a06d0d6c5cba40579551f0bb83c646f0247da9e326a4291183b2
    // gas used: 67,839
    // 2. https://sepolia.etherscan.io/tx/0xa30ca53c4856957f95fdbf4885e0e5001892af742335301125d5ef65df867586
    // gas used: 33,639
    //
    // Test (old behavior | --isolate):
    // 1.    51,507 | 67,839
    // 2.    3,201 | 33,639
    // 3.    3,202 | 33,639
    // 4-8.  3,198 | 33,639
    // 9-10. 3,202 | 33,639
    function test_mintManyZeroes_native() public {
        address recipient = 0x0000000000000000000000000000000000000001;
        uint256 amount = 0x0000000000000000000000000000000000000000000000000000000000000001;

        for (uint256 i = 0; i < MINT_ITERATIONS; i++) {
            mockERC20.mint(recipient, amount);
        }
    }

    // 1. https://sepolia.etherscan.io/tx/0x6a985f8e7556af5cc90c0c9ef4af90d0b031f090732ea4e9c5e77debe056cd39
    // gas used: 68,439
    // 2. https://sepolia.etherscan.io/tx/0x91cc033349873f65cf69e1b967b17ea983eb266a929c044c74ef8de52697f25e
    // gas used: 34,239
    //
    // Test (old behavior | --isolate):
    // 1.    51,507 | 68,439
    // 2.    3,201 | 34,239
    // 3.    3,202 | 34,239
    // 4-8.  3,198 | 34,239
    // 9-10. 3,202 | 34,239
    function test_mintNoZero_native() public {
        address recipient = 0x1111111111111111111111111111111111111111;
        uint256 amount = 0x1111111111111111111111111111111111111111111111111111111111111111;

        for (uint256 i = 0; i < MINT_ITERATIONS; i++) {
            mockERC20.mint(recipient, amount);
        }
    }
}
