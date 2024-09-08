// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
Develop an ERC20 token contract with an initial supply that is minted to the deployer's address.
The contract should use OpenZeppelin's ERC20 implementation and allow the deployer to set the total supply,
which should be multiplied by 10^18 to account for 18 decimal places.
Ensure that the token's name is "MyToken" and its symbol is "MTK".
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
//import ERC20 contract from open zeppelin

contract MyToken is ERC20 {
//declare contract as open zeppelin ERC20
constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
    uint256 initialSupplyWithDecimals = initialSupply * 10**18;
    _mint(msg.sender, initialSupplyWithDecimals);
    }
    /*
    initializes imported ERC20 contract with token name and symbol
    give deployer ability to set initial supply, each token has 18 decimal places
    mint the initial supply to the contract deployer
    */
}