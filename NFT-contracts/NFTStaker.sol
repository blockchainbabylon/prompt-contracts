pragma solidity ^0.8.0;

/*
Create a Solidity smart contract that allows users to stake their NFTs (ERC721) and earn rewards in an ERC20 token.
Users should be able to stake their NFT, withdraw it later, and claim a reward if the NFT has been staked for at least one day.
The contract should interact with both an ERC20 token contract and an ERC721 NFT contract.
Keep track of users' staking balances and the time they last staked.
Include functionality for transferring NFTs and distributing rewards based on time staked.
*/

    import "./MyToken.sol"; // Import the myToken contract directly
    import "./MyNFT.sol"; // Import the myNFT contract directly

    contract NFTStaker {
        MyToken public myToken;
        MyNFT public myNFT;
        mapping(address => uint256) public stakingBalance; // Track user's staked NFTs
        mapping(uint256 => address) public stakedNFTs; // Track staked NFT ownership
        mapping(address => uint256) public lastStakedTime; // Track time of last stake

    constructor(address _myToken, address _myNFT) {
        myToken = MyToken(_myToken); // Initilize ERC20 token contract
        myNFT = MyNFT(_myNFT); // Initialize NFT contract
    }

    // Function for users to stake their NFT
    function stakeNFT(uint256 tokenId) public {
        require(myNFT.ownerOf(tokenId) == msg.sender, "Not the owner"); // Ensure user owns the NFT
        myNFT.transferFrom(msg.sender, address(this), tokenId); // Transfer NFT to contract
        stakingBalance[msg.sender] += 1; // Increase users's staking balance
        lastStakedTime[msg.sender] = block.timestamp; // Update the time of stake
        stakedNFTs[tokenId] = msg.sender; // Assign staked NFT ownership
    }

    // Function to withdraw staked NFT
    function withdrawNFT(uint256 tokenId) public {
        require(stakedNFTs[tokenId] == msg.sender, "Not the staker"); // Ensure correct staker is withdrawing
        stakingBalance[msg.sender] -= 1; // Decrease staking balance
    }

    // Function to claim staking rewards
    function claimReward() public {
        require(stakingBalance[msg.sender] > 0, "No staked NFTs"); // Ensure user has staked NFTs
        require(block.timestamp >= lastStakedTime[msg.sender] + 1 days, "Reward not yet claimable"); // Ensure 1 day has passed

        uint256 reward = 10 * 10**18; // 10 ERC20 tokens with 18 decimal places
        myToken.transfer(msg.sender, reward); // Transfer reward to user
        lastStakedTime[msg.sender] = block.timestamp; // Update staking time
    }
}