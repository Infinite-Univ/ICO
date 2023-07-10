// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./SuperNova.sol";

contract Bank {
    //~~~~~ Immutable/Constant variables ~~~~~
    IERC20 private immutable TOKEN_SUPERNOVA;

    constructor() {
        TOKEN_SUPERNOVA = new SuperNova();
    }
}
