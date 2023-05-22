// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IPancakeSwap_Router02.sol";
import "./IPancakeSwap_Factory.sol";

contract Presale1 {
   
  //~~~~~ MUST CHANGE FOR MAINNET ADDRESSES ~~~~~
  address constant private USDT = 0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee; //TESTNET
  address constant private INFINITE_UNIVERSE_ERC20 = 0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee;
  address constant private PANCAKESWAP_FACTORY_V2 = 0x0BFbCF9fa4f9C56B0F40a671Ad40E0805A091865; //TESTNET
  address constant private PANCAKESWAP_ROUTER_V2 = 0x9a489505a00cE272eAa5e07Dba6491314CaE3796; //TESTNET
  uint256 constant public DECIMALS = 18;

  //~~~~~ Enum ~~~~~
  enum Kits {KitOne, KitTwo}

  //~~~~~ Immutable variables ~~~~~
  uint256 private immutable PRICE_KIT_ONE;
  uint256 private immutable PRICE_KIT_TWO;
  uint256 private immutable MAX_SUPPLY_KIT_ONE;
  uint256 private immutable MAX_SUPPLY_KIT_TWO;

  //~~~~~ State variables ~~~~~
  uint256 private kitOneSold;
  uint256 private kitTwoSold;
  address[] private buyersKitOne;
  address[] private buyersKitTwo;
  mapping(address => bool) hasPurchasedKitOne;
  mapping(address => bool) hasPurchasedKitTwo;


  constructor(uint256 _price1, uint256 _price2, uint256 _maxSupply1, uint256 _maxSupply2){
    PRICE_KIT_ONE = _price1 * 10**DECIMALS;
    PRICE_KIT_TWO = _price2 * 10**DECIMALS;
    MAX_SUPPLY_KIT_ONE = _maxSupply1;
    MAX_SUPPLY_KIT_TWO = _maxSupply2;
  }

  //~~~~~ Modifier ~~~~~

  /**
   * 
   * @dev modifier to avoid smart contracts to call this contract
   * 
   */
  modifier onlyWallet(){
    require(msg.sender == tx.origin, "Whitelist: Sender must be a wallet.");
    _;
  }

  

  //~~~~~ External/Public Functions ~~~~~

  /**
   * 
   * @dev users can buy the kitOne or kitTwo 
   * by approving "PRICE_KIT_ONE" or "PRICE_KIT_TWO" in USDT
   * 
   * NOTE: 
   * -msg.sender must approve "PRICE_KIT_ONE" or "PRICE_KIT_TWO" quantity of tokens first
   * -when everything is sold out, the contract will automatically create the pair and add liquidity
   * 
   * Requirements:
   * - msg.sender must be an EOA (wallet).
   * - the user can purchase only x1 kitOne and/or x1 kitTwo per wallet.
   * - user must approve USDT first to call this function.
   * 
   */
  function buyKit(Kits _kitToBuy) external onlyWallet() {
    address _sender = msg.sender;
    if(_kitToBuy == Kits.KitOne){
      kitOneSold++;
      require(kitOneSold <= MAX_SUPPLY_KIT_ONE, "Whitelist: kit one sold out");
      require(!hasPurchasedKitOne[_sender], "Whitelist: You have already purchased kit one.");
      require(IERC20(USDT).transferFrom(_sender,address(this),PRICE_KIT_ONE));
      buyersKitOne.push(_sender);
      hasPurchasedKitOne[_sender] = true;
    }else{
      kitTwoSold++;
      require(kitTwoSold <= MAX_SUPPLY_KIT_TWO, "Whitelist: kit two sold out");
      require(!hasPurchasedKitTwo[_sender], "Whitelist: You have already purchased kit two.");
      require(IERC20(USDT).transferFrom(_sender,address(this),PRICE_KIT_TWO));
      buyersKitTwo.push(_sender);
      hasPurchasedKitTwo[_sender] = true;
    }
    _closeRound(kitOneSold, kitTwoSold);
  }

  function _closeRound(uint256 _kitOneSold, uint256 _kitTwoSold) internal {
    if(_kitOneSold == MAX_SUPPLY_KIT_ONE && _kitTwoSold == MAX_SUPPLY_KIT_TWO){
      address pair = _createPair();
      bool result = _addLiquidity(pair);
      require(result);
    }
  }

  //~~~~~ View/Pure Functions ~~~~~

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

  /**
   * 
   * @dev returns address of the buyer at the index
   * 
   * @param _index index to search in the array of buyers of kitOne
   *
   */
  function buyersOfKitOne(uint256 _index) external view returns(address){
    return buyersKitOne[_index];
  }

  /**
   * 
   * @dev returns address of the buyer at the index
   * 
   * @param _index index to search in the array of buyers of kitTwo
   *
   */
  function buyersOfKitTwo(uint256 _index) external view returns(address){
    return buyersKitTwo[_index];
  }

  /**
   * 
   * @dev returns current kits one that has been sold
   * 
   */
  function kitsOneSold() external view returns(uint256){
    return kitOneSold;
  }

  /**
   * 
   * @dev returns current kits one that has been sold
   * 
   */
  function kitsTwoSold() external view returns(uint256){
    return kitTwoSold;
  }

  function _createPair() internal returns(address){
        address pair = IPancakeFactory(PANCAKESWAP_FACTORY_V2).createPair(
            address(USDT),
            address(INFINITE_UNIVERSE_ERC20)
        );
        require(pair != address(0),"Launchpad: Failed creating pair");
        return pair;
    }

  function _addLiquidity() internal returns(bool){
    uint256 balanceUSDT = IERC20(USDT).balanceOf(address(this));
    uint256 balanceInfinite = IERC20(INFINITE_UNIVERSE_ERC20).balanceOf(address(this));

    IERC20(USDT).approve(PANCAKESWAP_ROUTER_V2, balanceUSDT);
    IERC20(INFINITE_UNIVERSE_ERC20).approve(PANCAKESWAP_ROUTER_V2, balanceInfinite);

    (, , uint256 liquidity) = IPancakeRouter02(PANCAKESWAP_ROUTER_V2).addLiquidity(
        address(USDT),
        address(INFINITE_UNIVERSE_ERC20),
        balanceUSDT,
        balanceInfinite,
        balanceUSDT,
        balanceInfinite,
        address(this), //future pair's owner
        block.timestamp + 10 minutes);
    
    require(liquidity > 0, "Launchpad: Failed adding liquidity to the LP");
    return true;
  }
    

}
