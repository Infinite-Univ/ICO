// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IPancakeV3Factory {

    function createPool(
        address tokenA,
        address tokenB,
        uint24 fee
    ) external returns (address pool);

}