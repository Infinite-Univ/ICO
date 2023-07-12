// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockUSDT is ERC20 {

    //~~~~~ Immutable/Constant variables ~~~~~
    uint256 constant private MAX_SUPPLY = 100_000_000 * 10**18;

    constructor() ERC20("MockUSDT","MUSDT"){
        _mint(msg.sender,MAX_SUPPLY);
    }

    function maxSupply() external pure returns (uint256) {
        return MAX_SUPPLY;
    }

}