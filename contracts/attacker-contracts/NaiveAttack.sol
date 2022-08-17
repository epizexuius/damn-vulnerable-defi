//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract NaiveAttack {
    address victim;
    address pool;

    constructor(address _pool, address _victim) {
        pool = _pool;
        victim = _victim;
    }
}
