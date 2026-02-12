// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {DecentralizedStableCoin} from "./DecentralizedStableCoin.sol";
import {ReentrancyGuard} from "lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

/**
 * @title DSCEngine
 * @author Zer4ch
 * @notice This contract is the core of the Decentralized Stable Coin system. It
 *         manages collateral deposits, minting and burning of the stable coin,
 *         and ensures the system remains overcollateralized.
 *
 * it is similar to DAI if DAI had no governace, no fees, and was only backed by WETH and WBTC.
 *
 * our DSC system should always be " overcollateralized " . this means the value of collateral
 *
 * @notice This contract is incomplete and serves as a placeholder for the DSCEngine logic.
 */

contract DSCEngine is ReentrancyGuard {
    ////////// ERRORS //////////
    error DSCEngine__NeedsMoreThanZero();
    error DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
    error DSCEngine__TokenNotAllowed();
    error DSCEngine__TransferFailed();

    mapping(address token => address priceFeed) private s_priceFeeds;
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;
    mapping(address user => uint256 amountDscMinted) private s_DSCMinted;

    DecentralizedStableCoin private immutable i_dsc;

    /////////// EVENT //////////

    event collateralDeposited(address indexed user, address indexed token, uint256 amount);

    ////////// MODIFIERS //////////
    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert DSCEngine__NeedsMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address token) {
        if (s_priceFeeds[token] == address(0)) {
            revert DSCEngine__TokenNotAllowed();
        }
        _;
    }

    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address dscAddress) {
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert DSCEngine__TokenAddressesAndPriceFeedAddressesMustBeSameLength();
        }

        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
        }
        i_dsc = DecentralizedStableCoin(dscAddress);
    }

    ////////// FUNCTIONS //////////

    function depositCollateralAndMintDsc() external {}

    /**
     * @notice follows Check Effects-Interactions pattern and uses reentrancy guard to prevent reentrancy attack.
     * @param tokenCollateraladdress the address of the token to deposit as collateral
     * @param amountCollateral the amount of collateral to deposit
     */

    function depositCollateral(address tokenCollateraladdress, uint256 amountCollateral)
        external
        moreThanZero(amountCollateral)
        isAllowedToken(tokenCollateraladdress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][tokenCollateraladdress] += amountCollateral;
        emit collateralDeposited(msg.sender, tokenCollateraladdress, amountCollateral);
        bool success = IERC20(tokenCollateraladdress).transferFrom(msg.sender, address(this), amountCollateral);
        if (!success) {
            revert DSCEngine__TransferFailed();
        }
    }

    function redeemCollateralForDsc() external {}

    function redeemCollaternal() external {}

    // @notice follows Check Effects-Interactions pattern and uses reentrancy guard to prevent reentrancy attack.
    function mintDSC(uint256 amountDscToMint) external moreThanZero(amountDscToMint) nonReentrant {
        s_DSCMinted[msg.sender] += amountDscToMint;
        revertIfHealthFactorIsBroken(msg.sender);
    }

    function burnDSC() external {}

    function liqidate() external {}

    function getHealthFactor() external view {}

    //////////// PRIVATE FUNCTIONS //////////

    function _getAccountInformation(address user)
        private
        view
        returns (uint256 totalDscMinted, uint256 collateralValueInUsd)
    {
        totalDscMinted = s_DSCMinted[user];
        collateralValueInUsd = getAccountCollateralValue(user);
    }

    function _healthFactor(address user) private view returns (uint256) {
        //total DSC minted
        // total colalaaeral value
        (uint256 totalDscMinted, uint256 collateralValueInUsd) = _getAccountInformation(user);
    }

    function _revertIfHealthFactorIsBroken(address user) private view {}

    function getAccountCollateralValue(address user) public view returns (uint256) {}
}

