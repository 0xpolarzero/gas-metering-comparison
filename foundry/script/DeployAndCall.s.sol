// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";

import {MockERC20} from "src/MockERC20.sol";

/// @dev Deploy the mock contract and mint to get reference gas measurements

contract DeployAndCall is Script {
    uint256 constant MINT_ITERATIONS = 2;

    // To run the forge script and pass the target arguments, use the following command:
    // forge script script/DeployAndCall.s.sol:DeployAndCall --rpc-url $RPC_URL_SEPOLIA --broadcast -vvvv --sig "run(address, uint256)" 0x0000000000000000000000000000000000000001 0x0000000000000000000000000000000000000000000000000000000000000001
    // or
    // forge script script/DeployAndCall.s.sol:DeployAndCall --rpc-url $RPC_URL_SEPOLIA --broadcast -vvvv --sig "run(address, uint256)" 0x1111111111111111111111111111111111111111 0x1111111111111111111111111111111111111111111111111111111111111111
    function run(address recipient, uint256 amount) public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        MockERC20 mockERC20 = new MockERC20();

        for (uint256 i = 0; i < MINT_ITERATIONS; i++) {
            mockERC20.mint(recipient, amount);
        }

        vm.stopBroadcast();
    }
}
