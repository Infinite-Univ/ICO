const hre = require("hardhat");

// This is for BSC TESTNET
const addressTokenUSDT = ''; // address deployed
const addressTokenSuperNova = ''; // address deployed
const NAME_CONTRACT = 'MockPresale1';


async function main() {

    // Deploy MockPresale1
    const Contract = await hre.ethers.getContractFactory(NAME_CONTRACT);
    const contract = await Contract.deploy();
    await contract.deployed();
    console.log(`Smart contract ${NAME_CONTRACT}  deployed to ${contract.address}`);

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
