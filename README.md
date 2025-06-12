# Token42 Project

## Overview
This project implements an ERC-20 token called "Token42" as part of the 42 School Web3 curriculum. The token is developed using Solidity and deployed using Remix IDE.

## Project Choices and Rationale

### Blockchain Platform: Ethereum/BSC
- **Choice**: Ethereum (ERC-20 standard) or Binance Smart Chain (BEP-20)
- **Rationale**: 
  - Wide adoption and community support
  - Robust tooling ecosystem
  - Compatible with most wallets and exchanges
  - Lower gas fees on BSC for testing

### Development Environment: Remix IDE
- **Choice**: Remix IDE (https://remix.ethereum.org/)
- **Rationale**:
  - Browser-based, no local setup required
  - Built-in compiler and debugger
  - Integrated deployment tools
  - Excellent for learning and prototyping
  - Direct integration with MetaMask

### Token Standard: ERC-20
- **Choice**: ERC-20 compliant token
- **Rationale**:
  - Industry standard for fungible tokens
  - Maximum compatibility with wallets and exchanges
  - Well-documented and battle-tested
  - Rich ecosystem of tools and libraries

### Security Framework: OpenZeppelin
- **Choice**: OpenZeppelin Contracts library
- **Rationale**:
  - Audited and secure contract implementations
  - Industry best practices
  - Modular and extensible design
  - Reduces development time and security risks

## Token Specifications

- **Name**: Token42 (subject to change)
- **Symbol**: T42 (subject to change)
- **Decimals**: 18
- **Total Supply**: 1,000,000 tokens
- **Network**: BSC Testnet (for development), BSC Mainnet (for final deployment)

## Project Structure

```
tokenizer/
├── README.md                 # This file
├── subject.md               # Project requirements
├── code/                    # Smart contract source code
│   ├── Token42.sol         # Main ERC-20 token contract
│   └── Multisig.sol        # Bonus: Multisig wallet contract
├── deployment/              # Deployment scripts and configs
│   ├── deploy.js           # Deployment script
│   ├── config.json         # Network configurations
│   └── addresses.json      # Deployed contract addresses
└── documentation/           # Project documentation
    ├── whitepaper.md       # Token whitepaper
    ├── api.md              # API documentation
    └── security.md         # Security considerations
```

## Development Roadmap

### Phase 1: Setup ✅
- [x] Create project structure
- [ ] Define token specifications
- [ ] Set up Remix workspace

### Phase 2: Development
- [ ] Implement ERC-20 token contract
- [ ] Add security features
- [ ] Implement ownership controls
- [ ] Add minting/burning capabilities

### Phase 3: Testing
- [ ] Unit testing in Remix
- [ ] Testnet deployment
- [ ] Integration testing
- [ ] Security review

### Phase 4: Documentation
- [ ] Complete technical documentation
- [ ] Write whitepaper
- [ ] Create usage guide

### Phase 5: Deployment
- [ ] Mainnet deployment
- [ ] Contract verification
- [ ] Block explorer listing

### Phase 6: Bonus (Optional)
- [ ] Implement multisig wallet
- [ ] Advanced governance features

## Getting Started

1. Open [Remix IDE](https://remix.ethereum.org/)
2. Create new workspace for "Token42"
3. Import OpenZeppelin contracts
4. Copy contracts from `code/` folder
5. Compile and test in JavaScript VM
6. Deploy to testnet for testing
7. Deploy to mainnet when ready

## Security Considerations

- All contracts will be based on OpenZeppelin's audited implementations
- Proper access control for administrative functions
- Protection against common vulnerabilities (reentrancy, overflow, etc.)
- Multisig wallet for enhanced security (bonus feature)

## Contract Addresses

*Will be updated after deployment*

- **Testnet**: TBD
- **Mainnet**: TBD
- **Network**: TBD

## Links and Resources

- [Remix IDE](https://remix.ethereum.org/)
- [OpenZeppelin Contracts](https://openzeppelin.com/contracts/)
- [ERC-20 Standard](https://ethereum.org/en/developers/docs/standards/tokens/erc-20/)
- [BSC Testnet Faucet](https://testnet.binance.org/faucet-smart)

---

*Last updated: June 12, 2025*