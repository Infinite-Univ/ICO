// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SuperNova is ERC20 {

    //~~~~~ Immutable/Constant variables ~~~~~
    uint256 constant private TOTAL_SUPPLY = 100_000_000 * 10**18;

    constructor() ERC20("SuperNova","SPN"){
        _mint(msg.sender,TOTAL_SUPPLY);
    }

    function totalSupply() public view virtual override returns (uint256) {
        return TOTAL_SUPPLY;
    } 

}