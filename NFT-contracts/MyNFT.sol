// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
Create an ERC721 token contract that allows users to mint unique non-fungible tokens with a specified tokenURI.
The contract should keep track of the number of NFTs created with a tokenCounter and store the metadata URI for each token.
Implement a function to create new NFTs, which assigns them to the sender and updates the tokenURIs mapping with the provided URI.
*/

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFT is ERC721 {
    uint256 public tokenCounter; // Counter for tracking the next token ID
    mapping(uint256 => string) public tokenURIs; // Mapping from token ID to its metadata URI

    // Initialize ERC721 token with name and symbol
    constructor() ERC721("MyNFT", "MNFT") {
        tokenCounter = 0; // Initialize token counter to 0
    }

    // Function to create a new NFT and assign a tokenURI
    function createCollectible(string memory tokenURI) public returns (uint256) {
        uint256 newItemId = tokenCounter; // Set the new token ID based on the current counter
        _safeMint(msg.sender, newItemId); // Mint the new token and assign it to the caller (msg.sender)
        tokenURIs[newItemId] = tokenURI; // Store the tokenURI for the newly minted token
        tokenCounter++; // Increment thetoken couunter for the next minting
        return newItemId; // Return the newly minted token ID
    }
}