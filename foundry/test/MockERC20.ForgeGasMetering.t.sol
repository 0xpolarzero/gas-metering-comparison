// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {MainnetMetering} from "forge-gas-metering/MainnetMetering.sol";

import {MockERC20} from "src/MockERC20.sol";

/// @dev Compare emo.eth forge-gas-metering with Sepolia testnet txs
/// Note: We can only use a single `meterCallAndLog` per test, hence the 4 tests.
/// Note: There should be a difference of 600 gas between the two tests,
/// due to the difference between zero and non-zero bytes in the call data.
/// This is accurately caught by `meterCallAndLog`, even though there is a
/// significant overhead in gas usage.

contract MockERC20ForgeGasMetering is MainnetMetering, Test {
    MockERC20 mockERC20;

    function setUp() public {
        setUpMetering({verbose: false});
        mockERC20 = new MockERC20();
    }

    // 1. https://sepolia.etherscan.io/tx/0x886c7e6d86a3a06d0d6c5cba40579551f0bb83c646f0247da9e326a4291183b2
    // gas used: 67,839
    //
    // Test:
    // gas used: 63,879
    function test_mintManyZeroes_first_forgeGasMetering() public {
        address recipient = 0x0000000000000000000000000000000000000001;
        uint256 amount = 0x0000000000000000000000000000000000000000000000000000000000000001;

        meterCallAndLog({
            from: address(0), // equivalent to address(this)
            to: address(mockERC20),
            callData: abi.encodeWithSelector(mockERC20.mint.selector, recipient, amount),
            value: 0,
            transaction: true,
            expectRevert: false,
            message: "mintManyZeroes first tx"
        });
    }

    // 1. https://sepolia.etherscan.io/tx/0x6a985f8e7556af5cc90c0c9ef4af90d0b031f090732ea4e9c5e77debe056cd39
    // gas used: 68,439
    //
    // Test:
    // gas used: 64,479
    function test_mintNoZero_first_forgeGasMetering() public {
        address recipient = 0x1111111111111111111111111111111111111111;
        uint256 amount = 0x1111111111111111111111111111111111111111111111111111111111111111;

        meterCallAndLog({
            from: address(0),
            to: address(mockERC20),
            callData: abi.encodeWithSelector(mockERC20.mint.selector, recipient, amount),
            value: 0,
            transaction: true,
            expectRevert: false,
            message: "mintNoZero first tx"
        });
    }

    // 2. https://sepolia.etherscan.io/tx/0xa30ca53c4856957f95fdbf4885e0e5001892af742335301125d5ef65df867586
    // gas used: 33,639
    //
    // Test:
    // gas used:
    function test_mintManyZeroes_second_forgeGasMetering() public {
        address recipient = 0x0000000000000000000000000000000000000001;
        uint256 amount = 0x0000000000000000000000000000000000000000000000000000000000000001;

        mockERC20.mint(recipient, amount);

        meterCallAndLog({
            from: address(0), // equivalent to address(this)
            to: address(mockERC20),
            callData: abi.encodeWithSelector(mockERC20.mint.selector, recipient, amount),
            value: 0,
            transaction: true,
            expectRevert: false,
            message: "mintManyZeroes second tx"
        });
    }

    // 2. https://sepolia.etherscan.io/tx/0x91cc033349873f65cf69e1b967b17ea983eb266a929c044c74ef8de52697f25e
    // gas used: 34,239
    //
    // Test:
    // gas used:
    function test_mintNoZero_second_forgeGasMetering() public {
        address recipient = 0x1111111111111111111111111111111111111111;
        uint256 amount = 0x1111111111111111111111111111111111111111111111111111111111111111;

        mockERC20.mint(recipient, amount);

        meterCallAndLog({
            from: address(0),
            to: address(mockERC20),
            callData: abi.encodeWithSelector(mockERC20.mint.selector, recipient, amount),
            value: 0,
            transaction: true,
            expectRevert: false,
            message: "mintNoZero second tx"
        });
    }
}
