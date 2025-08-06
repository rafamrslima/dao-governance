import { ethers } from "hardhat";

async function main() {
  
  const voteTokenAddress = process.env.VOTE_TOKEN_ADDRESS;

  if (!voteTokenAddress || voteTokenAddress === "0x0000000000000000000000000000000000000000") {
    throw new Error("VOTE_TOKEN_ADDRESS not set or invalid in .env");
  }

  const [deployer] = await ethers.getSigners();
  console.log("Deploying from address:", deployer.address);

  const DAOFactory = await ethers.getContractFactory("DAOGovernance");
  const dao = await DAOFactory.deploy(voteTokenAddress);

  await dao.waitForDeployment();
  const contractAddress = await dao.getAddress();

  console.log("DAOGovernance deployed to:", contractAddress);
}

main().catch((err) => {
  console.error("Deployment failed:", err);
  process.exitCode = 1;
});