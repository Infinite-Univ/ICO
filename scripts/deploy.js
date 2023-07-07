const hre = require("hardhat");

const NAME_CONTRACT = 'XXXX'

async function main() {
  const Contract = await hre.ethers.getContractFactory(NAME_CONTRACT); // Mock Presale here
  const contract = await Contract.deploy();
  await contract.deployed();
  console.log(`Smart ${NAME_CONTRACT}  deployed to ${contract.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
