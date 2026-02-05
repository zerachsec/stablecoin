// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

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

contract DSCEngine {
    ////////// ERRORS //////////
    error DSCEngine__NeedsMoreThanZero();

    mapping(address => bool ) private s_priceFeeds;


    ////////// MODIFIERS //////////
    modifier moreThanZero (uint256 amount){
        if(amount == 0){
            revert DSCEngine__NeedsMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address token){

    }

    ////////// FUNCTIONS //////////
    }
    function depositCollateralAndMintDsc() external {}

    /**
     * 
     * @param tokenCollateraladdress the address of the token to deposit as collateral
     * @param amountCollateral the amount of collateral to deposit 
     */
    function depositCollateral(address tokenCollateraladdress, uint256 amountCollateral) external {}

    function redeemCollateralForDsc() external {}

    function redeemCollaternal() external {}

    function mintDSC() external {}

    function burnDSC() external {}

    function liqidate() external {}

    function getHealthFactor() external view {}
}
