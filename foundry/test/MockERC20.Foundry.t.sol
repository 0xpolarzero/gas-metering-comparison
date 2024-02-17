// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console2 as console} from "forge-std/Test.sol";

import {MockERC20} from "src/MockERC20.sol";

/// @dev Compare Forge gas measurements with Sepolia testnet txs
/// Note: There should be a difference of 600 gas between the two tests,
/// due to the difference between zero and non-zero bytes in the call data.
/// However, Forge fails to measure the difference and returns the exact same
/// gas usage for both tests.

contract MockERC20Foundry is Test {
    MockERC20 mockERC20;

    uint256 constant MINT_ITERATIONS = 10;

    function setUp() public {
        mockERC20 = new MockERC20();
    }

    // 1/ https://sepolia.etherscan.io/tx/0xb9431149b5f264acde244f36d033a754205328b72cd407c8f0e0a1d2c4337bc6
    // gas used: 50,739
    // 2. https://sepolia.etherscan.io/tx/0x98bee7b5a7cf66c3def3377a483c8555cb6d0a88876440dc316bf4af8c55dc63
    // gas used: 33,639
    //
    // Test:
    // 1.    51,507
    // 2.    3,201
    // 3.    3,202
    // 4-8.  3,198
    // 9-10. 3,202
    function test_mintManyZeroes_native() public {
        address recipient = 0x0000000000000000000000000000000000000001;
        uint256 amount = 0x0000000000000000000000000000000000000000000000000000000000000001;

        for (uint256 i = 0; i < MINT_ITERATIONS; i++) {
            uint256 gasPre = gasleft();
            mockERC20.mint(recipient, amount);
            uint256 gasPost = gasleft();

            console.log("gas used on try %d: %d", i + 1, gasPre - gasPost);
        }
    }

    // 1. https://sepolia.etherscan.io/tx/0x749cfcba3b270f0147b18a92d9e9cdd3e56cb204020e53b50f99c01e286d734e
    // gas used: 51,339
    // 2. https://sepolia.etherscan.io/tx/0x99f9027dc55e870bab3df5084875a29a35a3d151bd549af655613ae1fed8d08f
    // gas used: 34,239
    //
    // Test:
    // 1.    51,507
    // 2.    3,201
    // 3.    3,202
    // 4-8.  3,198
    // 9-10. 3,202
    function test_mintNoZero_native() public {
        address recipient = 0x1111111111111111111111111111111111111111;
        uint256 amount = 0x1111111111111111111111111111111111111111111111111111111111111111;

        for (uint256 i = 0; i < MINT_ITERATIONS; i++) {
            uint256 gasPre = gasleft();
            mockERC20.mint(recipient, amount);
            uint256 gasPost = gasleft();

            console.log("gas used on try %d: %d", i + 1, gasPre - gasPost);
        }
    }
}
