// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Whitelist {
   
   //~~~~~ MUST CHANGE FOR MAINNET ADDRESSES ~~~~~
   address constant private USDT = 0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee; //TESTNET
   address constant private PANCAKESWAP_FACTORY_V3 = 0x0BFbCF9fa4f9C56B0F40a671Ad40E0805A091865; //TESTNET
   address constant private PANCAKESWAP_ROUTER_V3 = 0x9a489505a00cE272eAa5e07Dba6491314CaE3796; //TESTNET
    
    //~~~~~ State variables ~~~~~
    uint256 public immutable PRICE;

    constructor(uint256 _price){
      PRICE = _price;
    }

   function _createPair() internal returns(address pair) {


   }

   function _addLiquidity() internal{

   }



    

}
