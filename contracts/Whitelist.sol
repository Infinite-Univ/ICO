// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Whitelist {
   
  //~~~~~ MUST CHANGE FOR MAINNET ADDRESSES ~~~~~
  address constant private USDT = 0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee; //TESTNET
  address constant private PANCAKESWAP_FACTORY_V3 = 0x0BFbCF9fa4f9C56B0F40a671Ad40E0805A091865; //TESTNET
  address constant private PANCAKESWAP_ROUTER_V3 = 0x9a489505a00cE272eAa5e07Dba6491314CaE3796; //TESTNET
  uint256 constant public DECIMALS = 18;

  //~~~~~ State variables ~~~~~
  uint256 public immutable PRICE;
  address[] public buyers;
  mapping(address => bool) hasPurchased;

  constructor(uint256 _price){
    PRICE = _price * 10**DECIMALS;
  }

  modifier onlyWallet(){
    require(msg.sender == tx.origin, "Whitelist: Sender must be a wallet.");
    _;
  }

  //TO DO
  function _createPair() internal returns(address pair) {

  }

  //TO DO
  function _addLiquidity() internal{

  }

  /**
   * 
   * @dev users can buy the pre sale by sending USDT
   * 
   * NOTE: msg.sender must approve 'PRICE' quantity of tokens first
   * 
   * Requirements:
   * - msg.sender must be an EOA (wallet).
   * - the user can purchase only 1 pre sale per wallet.
   * - user must approve "PRICE" quantity of USDT for this contract
   * 
   */
  function buyPreSale() external onlyWallet() {
    address _sender = msg.sender;
    require(!hasPurchased[_sender], "Whitelist: You have already purchased.");
    require(IERC20(USDT).transferFrom(_sender,address(this),PRICE));
    buyers.push(_sender);
    hasPurchased[_sender] = true;
  }


    

}
