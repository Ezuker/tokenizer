const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying with address:", deployer.address);

  const ownerAddress = process.env.OWNER_ADDRESS;
  const ownerAddress2 = process.env.OWNER_ADDRESS2;

  console.log("Owner address:", ownerAddress);

  const Tokenizer = await hre.ethers.getContractFactory("Only42");
  const tokenizer = await Tokenizer.deploy(ownerAddress, [ownerAddress, ownerAddress2], 2);

  await tokenizer.waitForDeployment();

  console.log("✅ TokenizeArt deployed to:", await tokenizer.getAddress());
}

main().catch((error) => {
  console.error("❌ Deployment failed:", error);
  process.exitCode = 1;
});