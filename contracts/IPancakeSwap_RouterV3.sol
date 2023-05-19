// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IPancake_SmartRouter{

    function createPool(
        address tokenA,
        address tokenB,
        uint24 fee
    ) external returns (address pool);

}