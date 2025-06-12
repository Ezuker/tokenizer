// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Pausable.sol";

contract Only42 is ERC20, Ownable, Pausable {
    
    // Maximum supply cap
    uint256 public constant MAX_SUPPLY = 42 * 10**18; // 42 tokens
    
    // Events for transparency
    event TokensMinted(address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);
    event ContractPaused(address indexed by);
    event ContractUnpaused(address indexed by);
    
    constructor(address _initialOwner) ERC20("Only42", "O42") Ownable(_initialOwner) {
        uint256 initialSupply = MAX_SUPPLY; // Mint the maximum supply at deployment
        _mint(_initialOwner, initialSupply);
        emit TokensMinted(_initialOwner, initialSupply);
    }
    
    /**
     * @dev Burn tokens from caller's balance
     * @param amount Amount of tokens to burn
     */
    function burn(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Only42: insufficient balance to burn");
        
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount);
    }
    
    /**
     * @dev Pause token transfers (emergency function)
     */
    function pause() public onlyOwner {
        _pause();
        emit ContractPaused(msg.sender);
    }
    
    /**
     * @dev Unpause token transfers
     */
    function unpause() public onlyOwner {
        _unpause();
        emit ContractUnpaused(msg.sender);
    }
    
    /**
     * @dev Override transfer to include pause functionality
     */
    function transfer(address to, uint256 amount) public virtual override whenNotPaused returns (bool) {
        return super.transfer(to, amount);
    }
    
    /**
     * @dev Override transferFrom to include pause functionality
     */
    function transferFrom(address from, address to, uint256 amount) public virtual override whenNotPaused returns (bool) {
        return super.transferFrom(from, to, amount);
    }
    
    /**
     * @dev Get contract information for documentation
     */
    function getContractInfo() public pure returns (string memory, string memory, uint256, uint8) {
        return ("Only42", "O42", 42 * 10**18, 18);
    }
}