
const { ethers } = require("hardhat");

async function main() {
  console.log("Deploying SupplyChain smart contract...");

  // Get the contract factory
  const SupplyChain = await ethers.getContractFactory("SupplyChain");
  
  // Deploy the contract
  const supplyChain = await SupplyChain.deploy();
  
  // Wait for deployment to finish
  await supplyChain.deployed();
  
  console.log(`SupplyChain contract deployed to: ${supplyChain.address}`);
}

// Execute the deployment
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
