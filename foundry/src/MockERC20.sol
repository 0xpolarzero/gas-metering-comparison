// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20} from "@solady/tokens/ERC20.sol";

/// @dev An ultra-minimalistic ERC20 token implementation.
contract MockERC20 is ERC20 {
    constructor(uint256 _initialAmount) {
        _mint(msg.sender, _initialAmount);
    }

    /* -------------------------------------------------------------------------- */
    /*                                  METADATA                                  */
    /* -------------------------------------------------------------------------- */

    function name() public pure override returns (string memory) {
        return "MockERC20";
    }

    function symbol() public pure override returns (string memory) {
        return "M20";
    }
}
