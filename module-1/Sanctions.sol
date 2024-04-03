// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
PROMPT:
Add the ability for a centralized authority to prevent sanctioned addresses from sending or receiving created token.
Only the centralized authority can control this list
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
//import ERC20 contract from open zeppelin

contract MyToken is ERC20 {
    address public owner;
    //address state variable
    mapping(address => bool) private blacklist;
    //state variable mapping for a blacklist associates address with a boolean

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

    function addToBlacklist(address _address) public onlyOwner {
        blacklist[_address] = true;
    }
    //function adds or converts address in blacklist array, associating it with true boolean

    function removeFromBlacklist(address _address) public onlyOwner {
        blacklist[_address] = false;
    }
    //function adds or converts address in blacklist array, associating it with false boolean
   
    function isBlacklisted(address _address) public view returns (bool) {
        return blacklist[_address];
    }
    //function returns boolean to see if certain address is blacklisted or not

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal {
        require(!blacklist[from], "Sender is blacklisted");
        require(!blacklist[to], "Recipient is blacklisted");
        _transfer(from, to, amount);
    }
    /*
    function allows transfer of tokens but not to or from blacklisted addresses
    require statement checks that sending address is not on blacklist
    require statement checks that reciever address is not on the blacklist
    imports transfer function from ERC20 contract
    */
}
