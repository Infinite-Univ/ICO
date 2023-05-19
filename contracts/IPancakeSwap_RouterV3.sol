// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IPancake_SmartRouter{

    function increaseLiquidity(struct INonfungiblePositionManagerStruct.IncreaseLiquidityParams params) external payable returns (uint128 liquidity, uint256 amount0, uint256 amount1)

}