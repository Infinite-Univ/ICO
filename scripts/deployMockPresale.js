const hre = require("hardhat");

/*
    Last deploy
    https://testnet.bscscan.com/address/0x5A4054995556c78fDE28c01E2F93103aa1f9Be06
*/

// Values to deploy
const ADDRESS_MOCK_USDT = '0xC23a1548cf77799D0a481eeb5010f76C4D356ed9'; // ERC20 address deployed in BSC Testnet
const ADDRESS_SUPER_NOVA = '0xd531FCb1c3B9447Ae9815A69EeB95D2c0178460E'; // ERC20 address deployed in BSC Testnet
const NAME_CONTRACT = 'MockPresale1';
const PRICE_1 = 1;
const PRICE_2 = 1;
const MAX_SUPPLY_1 = 5;
const MAX_SUPPLY_2 = 7;

async function main() {

    // Deploy MockPresale1
    const Contract = await hre.ethers.getContractFactory(NAME_CONTRACT);
    const contract = await Contract.deploy(
        PRICE_1,
        PRICE_2,
        MAX_SUPPLY_1,
        MAX_SUPPLY_2,
        ADDRESS_MOCK_USDT,
        ADDRESS_SUPER_NOVA
    );
    await contract.deployed();
    console.log(`Smart contract ${NAME_CONTRACT}  deployed to ${contract.address}`);

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
