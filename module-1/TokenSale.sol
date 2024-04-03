// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
PROMPT:
Add a function where users can mint 1000 tokens if they pay 1 ether.
token should have 18 decimal places.
total supply should not exceed 1 million tokens. 
the sale should close after 1 million tokens have been minted.
must have a function to withdraw the Ethereum from the contract to your address.
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
//import ERC20 contract from open zeppelin

contract MyToken is ERC20 {
    uint256 private constant TOKEN_PRICE = 1 ether;
    //price per 1000 tokens
    uint256 private constant TOKENS_PER_ETHER = 1000;
    //number of tokens per ether
    uint256 private constant TOTAL_SUPPLY_LIMIT = 1000000 * (10**18);
    //total supply of token, 1 million, each with 18 decimal places

    uint256 private totalTokensMinted;
    //total number of tokens minted
    bool private saleClosed;
    //indicates if token sale is closed

    address private owner;
    //address of contract owner

    constructor() ERC20("MyToken", "MTK") {
        owner = msg.sender;
    }
    /*
    initializes imported ERC20 contract with token name and symbol
    initializes the owner address variable to deployer of contract
    */

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    //modifier that allows only contract deployer to use function abilities

    function buyTokens() external payable { 
        require(!saleClosed, "Token sale closed");
        require(msg.value >= TOKEN_PRICE, "Insufficient ether sent");

        uint256 tokensToMint = (msg.value / TOKEN_PRICE) * TOKENS_PER_ETHER * (10**18);
        require(tokensToMint <= TOTAL_SUPPLY_LIMIT, "Exceeds total supply limit");

        _mint(msg.sender, tokensToMint);
        totalTokensMinted += tokensToMint;
    }
    /*
    function to allow users to buy tokens by sending ether to the contract
    require statement checks if the token sale is not closed
    require statement checks that the amount of ether sent is sufficient to buy at least one token
    calculate the number of tokens to mint based on the amount of ether sent
    require statement checks that the total number of tokens to mint does not exceed the limit
    mint function imported from ERC20, calculates number of tokens and assign them to the sender
    update the total number of tokens minted
    */

    function withdrawEther(uint256 amount) external onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");
        payable(owner).transfer(amount);
    }
    /*
    function to allow the contract owner to withdraw ether from the contract
    require statement ensures that the withdrawal amount does not exceed the contract's ether balance
    transfers the specified amount of ether to the contract owner
    */

    function closeSale() external onlyOwner {
        saleClosed = true;
    }
    /*
    function to close the token sale
    only contract deployer has the ability to close sale
    */

    function isSaleClosed() external view returns (bool) {
        return saleClosed;
    }
    //function to check if the token sale is closed
}
