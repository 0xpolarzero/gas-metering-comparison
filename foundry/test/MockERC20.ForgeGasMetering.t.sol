// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {MainnetMetering} from "forge-gas-metering/MainnetMetering.sol";

import {MockERC20} from "src/MockERC20.sol";

/// @dev Compare emo.eth forge-gas-metering with Sepolia testnet txs
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

    // https://sepolia.etherscan.io/tx/0xb9431149b5f264acde244f36d033a754205328b72cd407c8f0e0a1d2c4337bc6
    // gas used: 50,739
    //
    // Test:
    // gas used: 63,879
    function test_mintManyZeroes_forgeGasMetering() public {
        address recipient = 0x0000000000000000000000000000000000000001;
        uint256 amount = 0x0000000000000000000000000000000000000000000000000000000000000001;

        meterCallAndLog({
            from: address(0), // equivalent to address(this)
            to: address(mockERC20),
            callData: abi.encodeWithSelector(mockERC20.mint.selector, recipient, amount),
            value: 0,
            transaction: true,
            expectRevert: false,
            message: "mintManyZeroes"
        });
    }

    // https://sepolia.etherscan.io/tx/0x749cfcba3b270f0147b18a92d9e9cdd3e56cb204020e53b50f99c01e286d734e
    // gas used: 51,339
    //
    // Test:
    // gas used: 64,479
    function test_mintNoZero_forgeGasMetering() public {
        address recipient = 0x1111111111111111111111111111111111111111;
        uint256 amount = 0x1111111111111111111111111111111111111111111111111111111111111111;

        meterCallAndLog({
            from: address(0), // equivalent to address(this)
            to: address(mockERC20),
            callData: abi.encodeWithSelector(mockERC20.mint.selector, recipient, amount),
            value: 0,
            transaction: true,
            expectRevert: false,
            message: "mintNoZero"
        });
    }
}
