// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IPancakeSwap_Router02.sol";
import "./IPancakeSwap_Factory.sol";

contract MockPresale1 {
    //~~~~~ MUST CHANGE FOR MAINNET ADDRESSES ~~~~~
    IERC20 private USDT; //TESTNET
    IERC20 private SUPER_NOVA; //TESTNET
    address private constant PANCAKESWAP_FACTORY_V2 =
        0x6725F303b657a9451d8BA641348b6761A6CC7a17; //TESTNET
    address private constant PANCAKESWAP_ROUTER_V2 =
        0xD99D1c33F9fC3444f8101754aBC46c52416550D1; //TESTNET
    uint256 private constant DECIMALS = 14; // This gonna change for 14 decimals for test cases | original 18 decimals

    //~~~~~ Enum ~~~~~
    enum Kits {
        KitOne,
        KitTwo
    }

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
    address pairCreated;

    constructor(
        uint256 _price1,
        uint256 _price2,
        uint256 _maxSupply1,
        uint256 _maxSupply2,
        IERC20 _addressTokenUSD,
        IERC20 _addressTokenSuperNova
    ) {
        PRICE_KIT_ONE = _price1 * 10 ** DECIMALS;
        PRICE_KIT_TWO = _price2 * 10 ** DECIMALS;
        MAX_SUPPLY_KIT_ONE = _maxSupply1;
        MAX_SUPPLY_KIT_TWO = _maxSupply2;
        USDT = _addressTokenUSD;
        SUPER_NOVA = _addressTokenSuperNova;
    }

    //~~~~~ Modifier ~~~~~

    /**
     *
     * @dev Modifier to avoid smart contracts to call this contract
     *
     */
    modifier onlyWallet() {
        require(msg.sender == tx.origin, "Whitelist: Sender must be a wallet.");
        _;
    }

    //~~~~~ External/Public Functions ~~~~~

    /**
     *
     * @dev Users can buy the kitOne or kitTwo
     * by approving "PRICE_KIT_ONE" or "PRICE_KIT_TWO" in USDT
     *
     * NOTE:
     * -Msg.sender must approve "PRICE_KIT_ONE" or "PRICE_KIT_TWO" quantity of tokens first
     * -When everything is sold out, the contract will automatically create the pair and add liquidity
     *
     * Requirements:
     *  -Msg.sender must be an EOA (wallet).
     *  -The user can purchase only x1 kitOne and/or x1 kitTwo per wallet.
     *  -User must approve USDT first to call this function.
     *
     */
    function buyKit(Kits _kitToBuy) external onlyWallet {
        address _sender = msg.sender;
        if (_kitToBuy == Kits.KitOne) {
            kitOneSold++;
            require(
                kitOneSold <= MAX_SUPPLY_KIT_ONE,
                "Whitelist: kit one sold out"
            );
            require(
                !hasPurchasedKitOne[_sender],
                "Whitelist: You have already purchased kit one."
            );
            require(
                IERC20(USDT).transferFrom(_sender, address(this), PRICE_KIT_ONE)
            );
            buyersKitOne.push(_sender);
            hasPurchasedKitOne[_sender] = true;
        } else {
            kitTwoSold++;
            require(
                kitTwoSold <= MAX_SUPPLY_KIT_TWO,
                "Whitelist: kit two sold out"
            );
            require(
                !hasPurchasedKitTwo[_sender],
                "Whitelist: You have already purchased kit two."
            );
            require(
                IERC20(USDT).transferFrom(_sender, address(this), PRICE_KIT_TWO)
            );
            buyersKitTwo.push(_sender);
            hasPurchasedKitTwo[_sender] = true;
        }
        //_closeRound(kitOneSold, kitTwoSold);
    }

    //~~~~~ Internal/Private Functions ~~~~~

    /**
     *
     * @param _kitOneSold Current kits one that has been sold
     * @param _kitTwoSold Current kits two that has been sold
     *
     * NOTE
     * When both kits are sold out:
     *    1. The contract will automatically create the pair USDT/SuperNova
     *    2. The contract will automatically add all the funds it posses to the pair USDT/SuperNova
     *
     */
    function _closeRound(uint256 _kitOneSold, uint256 _kitTwoSold) internal {
        if (
            _kitOneSold == MAX_SUPPLY_KIT_ONE &&
            _kitTwoSold == MAX_SUPPLY_KIT_TWO
        ) {
            address _pair = _createPair();
            bool result = _addLiquidity();
            require(result);
            pairCreated = _pair;
        }
    }

    /**
     *
     * @dev This function create the pair USDT/SuperNova
     *
     */
    function _createPair() internal returns (address) {
        address _pair = IPancakeFactory(PANCAKESWAP_FACTORY_V2).createPair(
            address(USDT),
            address(SUPER_NOVA)
        );
        require(_pair != address(0), "Launchpad: Failed creating pair");
        return _pair;
    }

    /**
     *
     * @dev This function adds liquidity to the pair USDT/SuperNova
     *
     */
    function _addLiquidity() internal returns (bool) {
        uint256 balanceUSDT = (USDT).balanceOf(address(this));
        uint256 balanceInfinite = (SUPER_NOVA).balanceOf(address(this));

        (USDT).approve(PANCAKESWAP_ROUTER_V2, balanceUSDT);
        (SUPER_NOVA).approve(PANCAKESWAP_ROUTER_V2, balanceInfinite);

        (, , uint256 liquidity) = IPancakeRouter02(PANCAKESWAP_ROUTER_V2)
            .addLiquidity(
                address(USDT),
                address(SUPER_NOVA),
                balanceUSDT,
                balanceInfinite,
                balanceUSDT,
                balanceInfinite,
                address(this), //future pair's owner
                block.timestamp + 10 minutes
            );

        require(liquidity > 0, "Launchpad: Failed adding liquidity to the LP");
        return true;
    }

    //~~~~~ View/Pure Functions ~~~~~

    /**
     *
     * @dev Returns true if the user has purchased kitOne
     *
     * @param _user Address of the user to verify if has purchased
     *
     */
    function userHasPurchasedKitOne(
        address _user
    ) external view returns (bool) {
        return hasPurchasedKitOne[_user];
    }

    /**
     *
     * @dev Returns true if the user has purchased kitTwo
     *
     * @param _user Address of the user to verify if has purchased
     *
     */
    function userHasPurchasedKitTwo(
        address _user
    ) external view returns (bool) {
        return hasPurchasedKitTwo[_user];
    }

    /**
     *
     * @dev Returns address of the buyer at the index
     *
     * @param _index Index to search in the array of buyers of kitOne
     *
     */
    function buyersOfKitOne(uint256 _index) external view returns (address) {
        return buyersKitOne[_index];
    }

    /**
     *
     * @dev Returns address of the buyer at the index
     *
     * @param _index Index to search in the array of buyers of kitTwo
     *
     */
    function buyersOfKitTwo(uint256 _index) external view returns (address) {
        return buyersKitTwo[_index];
    }

    /**
     *
     * @dev Returns current kits one that has been sold
     *
     */
    function kitsOneSold() external view returns (uint256) {
        return kitOneSold;
    }

    /**
     *
     * @dev Returns current kits one that has been sold
     *
     */
    function kitsTwoSold() external view returns (uint256) {
        return kitTwoSold;
    }

    /**
     *
     * @dev This function should return address(0)
     * unless the round has been closed (sold out),
     * in that case, it must return the address of the pair USDT/SuperNova
     *
     */
    function pair() external view returns (address) {
        return pairCreated;
    }
}
