// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
PROMPT:
use token sale contract with the ability for users to transfer their tokens back
to contract and receive 0.5 ether for every 1000 tokens transfered.
should accept amounts other than 1,000.
implement a function sellBack(uint256 amount).
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
//import ERC20 contract from open zeppelin

contract MyToken is ERC20 {
//declare contract as open zeppelin ERC20
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

    function sellBack(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Not enough tokens to sell");
        
        _transfer(msg.sender, address(this), amount);

        uint256 etherAmount = (amount * (0.5 ether) * (10**18)) / (1000 * 10**18);
        payable(msg.sender).transfer(etherAmount);
    }
    /*
    function to allow users to sell back tokens to the contract and receive ether
    require statement checks that the amount being sold back is greater than 0
    require statement checks that the user has enough tokens to sell back back
    transfer function imported from ERC20 contract, transfers the tokens from the seller to the contract
    calculate the amount of ether to send back to the seller
    transfer the ether back to the seller
    */

    function withdrawEther(uint256 amount) external onlyOwner {
    uint256 reserveAmount = totalTokensMinted * (0.5 ether) * (10**18) / (1000 * TOKENS_PER_ETHER);
    uint256 availableBalance = address(this).balance - reserveAmount;
    
    require(availableBalance >= amount, "Insufficient available balance after withdrawal");
    
    payable(owner).transfer(amount);
    }
    /*
    function withdraws ether from the contract, accessible only by the owner
    calculate the amount of reserve tokens that must be maintained in the contract
    calculate the available balance by subtracting the reserve amount from the contract's balance
    require statement checks that the available balance is sufficient for withdrawal
    transfer the amount of ether to the owner
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
