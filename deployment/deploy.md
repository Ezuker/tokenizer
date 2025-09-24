# Deployment Guide for Only42 Token

This guide will walk you through deploying the Only42 token contract to the BSC Testnet.

## Prerequisites

- Node.js (v16 or higher)
- npm
- A BSC Testnet account with some BNB for gas fees
- BSCScan API key (get one from [BSCScan](https://bscscan.com/apis))
- Git (for version control)

## Environment Setup

1. **Copy the environment template:**
   ```bash
   cp .env.sample .env
   ```

2. **Fill in your `.env` file with the required values:**
   ```bash
   RPC_URL=https://data-seed-prebsc-1-s1.binance.org:8545/  # BSC Testnet RPC URL
   OWNER_ADDRESS=0xYourOwnerAddressHere                    # Initial owner of the contract
   OWNER_ADDRESS2=0xYourSecondOwnerAddressHere             # Second multisig owner
   PRIVATE_KEY=0xYourPrivateKeyHere                        # Private key for deployment
   ```

3. **Set your BSCScan API key using Hardhat's secure variable system:**
   ```bash
   npx hardhat vars set BSCSCAN_API_KEY
   ```
   When prompted, enter your BSCScan API key. This securely stores the key for verification.

   **Important Notes:**
   - Use a testnet account with sufficient BNB for deployment
   - Never commit your `.env` file to version control
   - The `OWNER_ADDRESS` and `OWNER_ADDRESS2` will be set as multisig owners
   - The contract requires 2 approvals for multisig operations

## Installation

Install the required dependencies:

```bash
make setup
```

This will run `npm install` to install all necessary packages.

## Deployment Steps

### 1. Compile the Contracts

Compile the smart contracts to ensure everything is correct:

```bash
make compile
```

**Warning:** Make sure your `.env` file is properly configured before compiling.

### 2. Deploy to BSC Testnet

Deploy the Only42 contract to BSC Testnet:

```bash
make deploy
```

This command will:
- Compile the contracts
- Deploy the Only42 contract with the specified parameters
- Display the deployment address upon success

### 3. Verify the Contract (Optional but Recommended)

After successful deployment, verify your contract on BSCScan:

```bash
make verify
```

When prompted, simply enter the contract address returned from deployment. The constructor arguments will be automatically loaded from `constructor-args.js`.

Example:
```
Enter contract address: 0x1234567890123456789012345678901234567890
```

The verification will use the arguments defined in `constructor-args.js`:
- Initial owner: `OWNER_ADDRESS` from your `.env` file
- Multisig owners: `[OWNER_ADDRESS, OWNER_ADDRESS2]` from your `.env` file
- Required approvals: `2`

## Contract Parameters

The Only42 contract is deployed with the following constructor parameters:

- `_initialOwner`: The initial owner address (from `OWNER_ADDRESS`)
- `_multisigOwners`: Array of multisig owner addresses `[OWNER_ADDRESS, OWNER_ADDRESS2]`
- `_requiredApprovals`: Number of required approvals for multisig operations (set to 2)

### Getting Testnet BNB

You can get free BNB for testing from the BSC Testnet faucet:
- https://testnet.binance.org/faucet-smart

## Contract Features

After deployment, your Only42 contract will have:

- **Token Details:**
  - Name: Only42
  - Symbol: OFT
  - Decimals: 18
  - Max Supply: 42 tokens

- **Mining System:**
  - Users can solve math problems to earn tokens
  - Rewards halve every 5000 problems solved
  - Maximum 10 active problems at once

- **Multisig Governance:**
  - Pause/unpause functionality controlled by multisig
  - Requires 2 approvals for governance actions

- **Security Features:**
  - Pausable transfers
  - Burn functionality
  - Ownership controls

## Troubleshooting

### Common Issues

1. **"Cannot read properties of undefined (reading 'get')" when setting API key**
   - Make sure you're in the deployment directory and dependencies are installed
   - Run `make setup` first if you haven't already

2. **"incorrect number of arguments to constructor"**
   - Ensure your `.env` file has all required variables
   - Check that `OWNER_ADDRESS` and `OWNER_ADDRESS2` are valid addresses

3. **"insufficient funds"**
   - Make sure your deployment account has enough BNB for gas fees
   - BSC Testnet faucet: https://testnet.binance.org/faucet-smart

4. **"Failed to verify contract"**
   - Ensure your BSCScan API key is set correctly with `npx hardhat vars set BSCSCAN_API_KEY`
   - Wait a few minutes after deployment before verifying
   - Check that the contract address is correct

5. **"Network error"**
   - Verify your `RPC_URL` is correct
   - Check your internet connection

### Verification Tips

- The verification process now uses Hardhat's secure variable system for API keys
- Constructor arguments are automatically loaded from `constructor-args.js`
- If verification fails, wait a few minutes and try again (Etherscan needs time to index the contract)
