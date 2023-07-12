const hre = require("hardhat");
const NAME_CONTRACT = 'MockUSDT';
const NAME_CONTRACT_TWO = 'SuperNova';

async function main() {

    // Deploy [ Token ] Mock USDT
    const Contract = await hre.ethers.getContractFactory(NAME_CONTRACT);
    const contract = await Contract.deploy();
    await contract.deployed();
    console.log(`Smart contract ${NAME_CONTRACT}  deployed to ${contract.address}`);

    // Deploy [ Token ] Super Nova
    const ContractTwo = await hre.ethers.getContractFactory(NAME_CONTRACT_TWO);
    const contractTwo = await ContractTwo.deploy();
    await contract.deployed();
    console.log(`Smart contract ${NAME_CONTRACT_TWO}  deployed to ${contractTwo.address}`);

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
