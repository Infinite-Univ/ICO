const hre = require("hardhat");
const NAME_CONTRACT = 'MockUSDT';
const NAME_CONTRACT_TWO = 'SuperNova';

/*
    Last deploy
    Smart contract MockUSDT  deployed to https://testnet.bscscan.com/address/0xC23a1548cf77799D0a481eeb5010f76C4D356ed9
    Smart contract SuperNova  deployed to https://testnet.bscscan.com/address/0xd531FCb1c3B9447Ae9815A69EeB95D2c0178460E
*/

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
