# Only42 Token Project 🪙

## Overview
This project implements an ERC-20 token called "Only42" (O42) as part of the 42 School Web3 curriculum. The token is developed using Solidity and deployed using Remix IDE with enhanced security features including pause/unpause controls, burn functionality, and owner-based access control.

## 🌐 Deployed Contracts

### Current Status: Successfully Deployed ✅
- **Development**: ✅ Completed and tested on Remix VM
- **Testnet**: ✅ Successfully deployed on BSC Testnet

### Deployment Information

#### BSC Testnet (LIVE) 🚀
- **Contract Address**: `0x6b82271E52e06D89b19c769CeE7C274556E19Bf1`
- **Network**: BSC Testnet (Chain ID: 97)
- **Explorer**: [View on BSCScan](https://testnet.bscscan.com/address/0x6b82271E52e06D89b19c769CeE7C274556E19Bf1)
- **Status**: ✅ Deployed & Active
- **Deployment Date**: June 2025

#### Token Details
- **Name**: Only42
- **Symbol**: O42
- **Decimals**: 18
- **Total Supply**: 42 O42 (Fixed Supply)
- **Features**: ERC-20 + Ownable + Pausable + Burnable
- **Contract Type**: Fixed supply token with owner controls

## Project Choices and Rationale

### Blockchain Platform: Binance Smart Chain (BSC)
- **Choice**: BSC Testnet for development, targeting BSC ecosystem
- **Rationale**: 
  - Lower gas fees compared to Ethereum
  - Fast transaction confirmation times
  - Wide adoption and growing ecosystem
  - Compatible with Ethereum tooling (EVM-compatible)
  - Excellent for learning and testing Web3 concepts
  - The most important: No need to have BNB on mainnet

### Development Environment: Remix IDE
- **Choice**: Remix IDE (https://remix.ethereum.org/)
- **Rationale**:
  - Browser-based, no local setup required
  - Built-in compiler and debugger
  - Integrated deployment tools with MetaMask
  - Excellent for learning and prototyping
  - Direct integration with public blockchains
  - A lot of videos and stuff were on Remix

### Token Standard: ERC-20 with Security Extensions
- **Choice**: ERC-20 + OpenZeppelin security modules
- **Rationale**:
  - Industry standard for fungible tokens
  - Maximum compatibility with wallets and exchanges
  - Well-documented and battle-tested
  - OpenZeppelin provides audited security implementations
  - A lot of videos was on ERC-20 too

### Security Framework: OpenZeppelin Contracts
- **Choice**: OpenZeppelin Contracts v4.9.0
- **Rationale**:
  - Audited and secure contract implementations
  - Industry best practices for access control
  - Modular design (ERC20 + Ownable + Pausable)
  - Reduces development time and security risks

## Smart Contract Features

### Core Functionality
- **ERC-20 Compliance**: Full compatibility with ERC-20 standard
- **Fixed Supply**: 42 tokens minted at deployment (no additional minting)
- **Burnable**: Token holders can permanently destroy their tokens
- **Pausable**: Owner can halt all transfers in emergency situations
- **Ownable**: Administrative functions restricted to contract owner

### Security Features
- **Access Control**: Only owner can pause/unpause the contract
- **Balance Validation**: Burn function includes balance checks
- **Event Logging**: All major operations emit events for transparency
- **Overflow Protection**: Using Solidity 0.8.30 built-in overflow checks

### Custom Events
```solidity
event TokensMinted(address indexed to, uint256 amount);
event TokensBurned(address indexed from, uint256 amount);
event ContractPaused(address indexed by);
event ContractUnpaused(address indexed by);
```

## Project Structure

```
tokenizer/
├── README.md
├── code/
│   ├── Only42.sol              # Main ERC-20 token contract with multisig
│   ├── Only42_flattened.sol    # Flattened version for BSCScan
│   └── Only42MultisigTest.sol  # Testing contract for multisig functionality
├── deployment/
│   ├── images/
│   │   └── transaction.png     # Deployment screenshot
│   ├── private-deployment.md   # Deployment on Remix VM
│   ├── public-deployment.md    # Deployment on BSC testnet
│   └── multisig-testing.md     # Multisig testing guide for Remix
└── documentation/
    ├── vocabulary.md           # Web3 and blockchain vocabulary
    ├── chain-id-sources.md     # Official chain ID references
    └── multisig-guide.md       # Complete multisig implementation guide
```

## Getting Started

1. Open [Remix IDE](https://remix.ethereum.org/)
2. Create new workspace for "Token42"
3. Import OpenZeppelin contracts
4. Copy contracts from `code/` folder
5. Compile and test in JavaScript VM
6. Follow private-deployment to test the token
7. Follow public-deployment for publishing it on public blockchain

## Security Considerations

- All contracts will be based on OpenZeppelin's audited implementations
- Proper access control for administrative functions
- Protection against common vulnerabilities (reentrancy, overflow, etc.)
- Multisig wallet for enhanced security (bonus feature)

## Contract Addresses


- **Testnet**: 0x87b8eBac27a50014d07075769Df0df040781Cf7e
- **Network**: TBD

## Links and Resources

- [Remix IDE](https://remix.ethereum.org/)
- [OpenZeppelin Contracts](https://openzeppelin.com/contracts/)
- [ERC-20 Standard](https://ethereum.org/en/developers/docs/standards/tokens/erc-20/)
- [BSC Testnet Faucet](https://testnet.binance.org/faucet-smart)
- [ChainList](https://chainlist.org/) - Official registry of blockchain networks and Chain IDs
- [ABI-Hashex](https://abi.hashex.org) - ABI hasher for validation contract (constructor params)
- [Docs-Faucet](https://docs.bnbchain.org/bnb-smart-chain/developers/faucet/) - To get tBNB (Use discord method)

---