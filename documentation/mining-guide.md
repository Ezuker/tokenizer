# Mining OFT Tokens on BSCScan - Complete Guide

## 📋 **Prerequisites**

Before you can mine OFT tokens, ensure you have:

- ✅ **MetaMask wallet** installed and configured
- ✅ **BSC Testnet** added to MetaMask
- ✅ **Small amount of tBNB** for gas fees (get from [BSC Faucet](https://docs.bnbchain.org/bnb-smart-chain/developers/faucet/))
- ✅ **Contract deployed and verified** on BSCScan
- ✅ **Contract is not paused** (check contract status)

---

## 🔍 **Step 1: Navigate to Your Contract on BSCScan**

1. Go to [BSC Testnet Explorer](https://testnet.bscscan.com)
2. Enter your contract address in the search bar
3. Navigate to your Only42 contract page

**You should see 3 important tabs:**
- 📄 **Code** - View contract source code
- 👁️ **Read Contract** - Query contract data (no gas fees)
- ✍️ **Write Contract** - Execute transactions (requires gas)

---

## 📖 **Step 2: Connect MetaMask to Read Contract**

### **2.1 Access Read Contract Tab**
1. Click on the **"Read Contract"** tab
2. You'll see a list of read-only functions

### **2.2 Connect Your Wallet (Optional for Reading)**
1. Click **"Connect to Web3"** button
2. Select **MetaMask** from the wallet options
3. Approve the connection in MetaMask popup
4. ✅ You should see "Connected" status

### **2.3 Check Contract Status**
Before mining, verify the contract is ready:

```javascript
// Call these functions to check status:
paused()           // Should return: false
totalSupply()      // Current tokens mined
currentReward()    // Current mining reward
MAX_SUPPLY()       // Maximum possible tokens (42 OFT)
```

---

## 🧮 **Step 3: Get Current Mining Problems**

### **3.1 Find Available Problems**
1. In the **"Read Contract"** tab, locate the [`getActiveProblems`](../code/Only42.sol) function
2. Click **"Query"** button next to it
3. **Result**: You'll see an array of current problems

### **3.2 Understand the Problem Structure**
Each problem contains:
```javascript
{
  id: "123456789012345678",           // Unique problem identifier
  firstNumber: "347",                 // First number to add
  secondNumber: "892",                // Second number to add  
  isSolved: false                     // Must be false to mine
}
```

### **3.3 Choose a Problem and Calculate**
1. **Select an unsolved problem** (`isSolved: false`)
2. **Calculate the answer**: `firstNumber + secondNumber`
3. **Example**: If `firstNumber = 347` and `secondNumber = 892`
   - **Answer = 347 + 892 = 1239**

### **3.4 Record the Information**
Write down:
- ✏️ **Problem ID**: `123456789012345678`
- ✏️ **Answer**: `1239`

---

## ⛏️ **Step 4: Connect MetaMask to Write Contract**

### **4.1 Switch to Write Contract Tab**
1. Click on the **"Write Contract"** tab
2. You'll see a list of functions that modify the contract

### **4.2 Connect Your Wallet**
1. Click **"Connect to Web3"** button
2. Select **MetaMask** 
3. Approve the connection
4. ✅ Verify "Connected" status appears

### **4.3 Ensure Correct Network**
- MetaMask should show **"BSC Testnet"**
- If not, switch networks in MetaMask

---

## 🎯 **Step 5: Execute Mining Transaction**

### **5.1 Locate the Mine Function**
1. In **"Write Contract"** tab, find the [`mine`](../code/Only42.sol) function
2. It requires two parameters:
   - `problemId` (uint256)
   - `answer` (uint256)

### **5.2 Enter Parameters**
1. **problemId**: Enter the problem ID you recorded (e.g., `123456789012345678`)
2. **answer**: Enter your calculated answer (e.g., `1239`)

### **5.3 Submit the Transaction**
1. Click **"Write"** button
2. **MetaMask popup** will appear showing:
   - Gas fee estimate
   - Transaction details
3. Click **"Confirm"** in MetaMask
4. Wait for transaction confirmation

### **5.4 Transaction Result**
**If Successful:**
- ✅ Transaction hash appears
- ✅ You receive OFT tokens (check balance)
- ✅ New problem automatically generated

**If Failed:**
- ❌ "Wrong answer!" - Recalculate and try again
- ❌ "Problem already solved" - Someone else solved it first
- ❌ "Problem not found" - Use current problem ID

---

## 🔄 **Step 6: Verify Your Mining Success**

### **6.1 Check Your Token Balance**
1. In **"Read Contract"** tab, call [`balanceOf`](../code/Only42.sol)
2. Enter your wallet address
3. **Result**: Should show your OFT token balance

### **6.2 Check Mining Statistics**
```javascript
// Useful functions to monitor:
totalSupply()          // Total OFT mined by everyone
nbProblemsSolved()     // Total problems solved
currentReward()        // Current reward per problem
```

### **6.3 Check Transaction on BSCScan**
1. Copy transaction hash from MetaMask
2. Search it on BSCScan
3. Verify transaction succeeded and tokens were minted

---

## 📊 **Mining Rewards & Economics**

### **Current Reward System**
- **Initial Reward**: 0.0042 OFT per problem solved
- **Halving**: Reward halves every 5,000 problems solved
- **Maximum Supply**: 42 OFT tokens total
- **Competition**: First to solve gets the reward

### **Reward Schedule**
| Problems Solved | Reward per Problem |
|----------------|--------------------|
| 0 - 4,999      | 0.0042 OFT        |
| 5,000 - 9,999  | 0.0021 OFT        |
| 10,000 - 14,999| 0.00105 OFT       |
| And so on...   | Continues halving  |

---

## ⚠️ **Important Tips & Troubleshooting**

### **Mining Tips**
- 🏃‍♂️ **Be Quick**: Other miners compete for the same problems
- 🔢 **Double-check Math**: Wrong answers waste gas fees
- ⛽ **Monitor Gas**: Keep some tBNB for transaction fees
- 🔄 **Refresh Problems**: New problems generate after each solve

### **Common Issues**
**"Transaction Failed"**
- Check if problem is still unsolved
- Verify your math calculation
- Ensure contract is not paused

**"Insufficient Gas"**
- Get more tBNB from faucet
- Increase gas limit in MetaMask

**"Problem Not Found"**
- Problem ID might be invalid
- Get fresh problem list from `getActiveProblems()`

---

## 🎯 **Quick Mining Checklist**

- [ ] Contract verified on BSCScan
- [ ] MetaMask connected to BSC Testnet
- [ ] Have tBNB for gas fees
- [ ] Read current problems using `getActiveProblems()`
- [ ] Calculate answer: `firstNumber + secondNumber`
- [ ] Connect to Write Contract
- [ ] Call `mine(problemId, answer)`
- [ ] Confirm transaction in MetaMask
- [ ] Verify token balance increased

---

## 🔗 **Useful Links**

- **BSC Testnet Explorer**: https://testnet.bscscan.com
- **BSC Testnet Faucet**: https://docs.bnbchain.org/bnb-smart-chain/developers/faucet/
- **MetaMask**: https://metamask.io/
- **BSC Network Setup**: https://chainlist.org/chain/97

---

**Happy Mining! ⛏️🪙**

*Remember: Mining is competitive - the first person to solve a problem correctly gets the reward!*
