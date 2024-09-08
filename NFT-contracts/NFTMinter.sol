pragma solidity ^0.8.0;

/*
Design a contract that facilitates minting NFTs by using an ERC20 token as payment.
This contract should interact with both the MyToken and MyNFT contracts. Implement a function to mint a new NFT, which requires the sender to approve the transfer of ERC20 tokens to the contract and then transfers the tokens as payment.
Upon successful payment, the contract should create a new NFT with the specified tokenURI.
*/

    import "./MyToken.sol"; // Import the MyToken contract directly
    import "./MyNFT.sol"; // Import the MyNFT contract directly

    contract NFTMinter {
        MyToken public myToken;
        MyNFT public myNFT; 

    constructor(address _myToken, address _myNFT) {
        myToken = MyToken(_myToken);
        myNFT = MyNFT(_myNFT); // Cast to MyNFT type
    }

    function mintNFT(string memory tokenURI) public {
        uint256 tokenCost = 10 * 10**18; // 10 ERC20 tokens with 18 decimal places

        // Approve the transfer of ERC20 tokens from the user to the contract
        myToken.approve(msg.sender, tokenCost);

        // Ensure user has approved the transfer of ERC20 tokens
        //checks if the user (msg.sender) has approved themselves (as the spender) to spend tokens on their own behalf.
        require(myToken.allowance(msg.sender, msg.sender) >= tokenCost, "Not enough tokens approved");

        // Transfer ERC20 tokens from the user to the contract
        myToken.transferFrom(msg.sender, address(this), tokenCost);

        // Create the NFT
        myNFT.createCollectible(tokenURI);
        }
}