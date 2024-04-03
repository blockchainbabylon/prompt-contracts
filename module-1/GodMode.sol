//SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

/*
PROMPT:
God mode on an ERC20 token allows a special address to steal other people’s funds, create tokens, and destroy tokens.
Implement the following functions, they do what they sound like:

mintTokensToAddress(address recipient) mint function
changeBalanceAtAddress(address target) burn function
authoritativeTransferFrom(address from, address to) transfer function
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
//import ERC20 contract from open zeppelin

contract godMode is ERC20 {
//declare contract as open zeppelin ERC20
    address public godAddress;
    //address of contract owner

    constructor() ERC20("Richard Tokens", "RT") {
        godAddress = msg.sender;
    }
    /*
    initializes imported ERC20 contract with token name and symbol
    initializes the owner address variable to deployer of contract
    */

    modifier onlyGod() {
        require(msg.sender == godAddress, "only god can call thos function");
        _;
    }
    //modifier that allows only contract deployer to use function abilities

    function mintTokensToAddress(address recipient, uint256 amount) public onlyGod {
        _mint(recipient, amount);
    }
    /*
    import mint function from ERC20 contract
    takes an address to receive minted tokens and amount
    uses onlyGod modifier, making only the deployer able to use function
    */

    function changBalanceAtAddress(address target, uint256 amount) public onlyGod {
        _burn(target, amount);
    }
    /*
    imports burn function from ERC20 contract
    takes an address to burn tokens from and amount, sending them to zero address
    uses onlyGod modifier, making only the deployer able to use function
    */

    function authoritativeTransferFrom(address from, address to, uint256 amount) public onlyGod {
        _transfer(from, to, amount);
    }
    /*
    imports transfer function from ERC20 contract
    takes an address to send from, an address to send to, and an amount
    uses onlyGod modifier, making only the deployer able to use function
    */
}
