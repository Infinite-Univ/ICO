// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Presale1 {
   
  //~~~~~ MUST CHANGE FOR MAINNET ADDRESSES ~~~~~
  address constant private USDT = 0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee; //TESTNET
  address constant private PANCAKESWAP_FACTORY_V3 = 0x0BFbCF9fa4f9C56B0F40a671Ad40E0805A091865; //TESTNET
  address constant private PANCAKESWAP_ROUTER_V3 = 0x9a489505a00cE272eAa5e07Dba6491314CaE3796; //TESTNET
  uint256 constant public DECIMALS = 18;

  //~~~~~ Enum ~~~~~
  enum Kits {Kit1, Kit2}

  //~~~~~ Immutable variables ~~~~~
  uint256 public immutable PRICE_KIT_ONE;
  uint256 public immutable PRICE_KIT_TWO;
  uint256 public immutable MAX_SUPPLY_KIT_ONE;
  uint256 public immutable MAX_SUPPLY_KIT_TWO;

  //~~~~~ State variables ~~~~~
  address[] public buyersKitOne;
  address[] public buyersKitTwo;
  mapping(address => bool) hasPurchasedKitOne;
  mapping(address => bool) hasPurchasedKitTwo;

  constructor(uint256 _price1, uint256 _price2, uint256 _maxSupply1, uint256 _maxSupply2){
    PRICE_KIT_ONE = _price1 * 10**DECIMALS;
    PRICE_KIT_TWO = _price2 * 10**DECIMALS;
    MAX_SUPPLY_KIT_ONE = _maxSupply1;
    MAX_SUPPLY_KIT_TWO = _maxSupply2;
  }

  /**
   * 
   * @dev modifier to avoid smart contracts to call this contract
   * 
   */
  modifier onlyWallet(){
    require(msg.sender == tx.origin, "Whitelist: Sender must be a wallet.");
    _;
  }

  /**
   * 
   * @dev users can buy the pre sale by sending USDT
   * 
   * NOTE: msg.sender must approve 'PRICE' quantity of tokens first
   * 
   * Requirements:
   * - msg.sender must be an EOA (wallet).
   * - the user can purchase only x1 kitOne per wallet.
   * - user must approve "PRICE_KIT_ONE" quantity of USDT for this contract
   * 
   */
  function buyKitOne() external onlyWallet() {
    address _sender = msg.sender;
    require(!hasPurchasedKitOne[_sender], "Whitelist: You have already purchased kit one.");
    require(IERC20(USDT).transferFrom(_sender,address(this),PRICE_KIT_ONE));
    buyersKitOne.push(_sender);
    hasPurchasedKitOne[_sender] = true;
  }

  /**
   * 
   * @dev users can buy the pre sale by sending USDT
   * 
   * NOTE: msg.sender must approve 'PRICE_KIT_TWO' quantity of tokens first
   * 
   * Requirements:
   * - msg.sender must be an EOA (wallet).
   * - the user can purchase only x1 kitTwo per wallet.
   * - user must approve "PRICE_KIT_TWO" quantity of USDT for this contract
   * 
   */
  function buyKitTwo() external onlyWallet() {
    address _sender = msg.sender;
    require(!hasPurchasedKitTwo[_sender], "Whitelist: You have already purchased kit one.");
    require(IERC20(USDT).transferFrom(_sender,address(this),PRICE_KIT_TWO));
    buyersKitTwo.push(_sender);
    hasPurchasedKitTwo[_sender] = true;
  }

  /**
   * 
   * @dev returns true if the user has purchased kitOne
   * 
   * @param _user address of the user to verify if has purchased
   *
   */
  function userHasPurchasedKitOne(address _user) external view returns(bool){
    return hasPurchasedKitOne[_user];
  }

  /**
   * 
   * @dev returns true if the user has purchased kitTwo
   * 
   * @param _user address of the user to verify if has purchased
   *
   */
  function userHasPurchasedKitTwo(address _user) external view returns(bool){
    return hasPurchasedKitTwo[_user];
  }


  //TO DO
  function _createPair() internal returns(address pair) {

  }

  //TO DO
  function _addLiquidity() internal{

  }
    

}
