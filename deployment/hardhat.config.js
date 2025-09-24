require("dotenv").config();
require("@nomicfoundation/hardhat-toolbox");
const { vars } = require("hardhat/config");

const BSCSCAN_API_KEY = vars.get("BSCSCAN_API_KEY");

module.exports = {
  solidity: "0.8.30",
  networks: {
    bsctest: {
      url: process.env.RPC_URL,
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      chainId: 97,
      gasPrice: 10000000000,
    },
  },
  paths: {
    sources: "./contract",
  },
  etherscan: {
    apiKey: {
      bscTestnet: BSCSCAN_API_KEY,
    },
  },
};