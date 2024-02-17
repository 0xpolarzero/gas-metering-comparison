// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console2 as console} from "forge-std/Script.sol";

import {MockERC20} from "src/MockERC20.sol";

/// @dev Deploy the mock contract and mint to get reference gas measurements
/// @dev Take this opportunity to measure the gas usage of the mint function
/// according to Forge.
/// Note: This will actually log the following, regardless of the recipient and amount:
/// == Logs ==
///   gas used on try 1: 46895
///   gas used on try 2: 3095
///
/// Which means that it doesn't consider the amounts of zero/non-zero bytes in the call data.
/// It's worth noting that it returns the same figures as Tevm +400 gas.

contract DeployAndCall is Script {
    uint256 constant MINT_ITERATIONS = 2;

    // To run the forge script and pass the target arguments, use the following command:
    // forge script script/DeployAndCall.s.sol:DeployAndCall --rpc-url $RPC_URL_SEPOLIA --broadcast -vvvv --sig "run(address, uint256)" 0x0000000000000000000000000000000000000001 0x0000000000000000000000000000000000000000000000000000000000000001
    // or
    // forge script script/DeployAndCall.s.sol:DeployAndCall --rpc-url $RPC_URL_SEPOLIA --broadcast -vvvv --sig "run(address, uint256)" 0x1111111111111111111111111111111111111111 0x1111111111111111111111111111111111111111111111111111111111111111
    function run(address recipient, uint256 amount) public {
        uint256[] memory gasUsed = new uint256[](MINT_ITERATIONS);

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        MockERC20 mockERC20 = new MockERC20();

        for (uint256 i = 0; i < MINT_ITERATIONS; i++) {
            uint256 gasPre = gasleft();
            mockERC20.mint(recipient, amount);
            uint256 gasPost = gasleft();

            gasUsed[i] = gasPre - gasPost;
        }

        vm.stopBroadcast();

        for (uint256 i = 0; i < MINT_ITERATIONS; i++) {
            console.log("gas used on try %d: %d", i + 1, gasUsed[i]);
        }
    }
}
