const hre = require("hardhat");
const { expect } = require("chai");


// Smart Contract Names
const NAME_CONTRACT_MOCK_PRESALE = 'MockPresale1';
const NAME_CONTRACT_MOCK_USDT = 'MockUSDT';
const NAME_CONTRACT_MOCK_SUPER_NOVA = 'SuperNova';

// Values for interaction with MockPresale1
const KIT_ONE = 0;
const KIT_TWO = 1;

describe('Testing Smart Contracts', function () {

    // Smart contracts
    let contractUSDT;
    let contractSuerNova;
    let contractMock;

    // Values for "MockPresale1" constructor
    const PRICE_1 = 1;
    const PRICE_2 = 2;
    const MAX_SUPPLY_1 = 1;
    const MAX_SUPPLY_2 = 1;

    function generateContractLink(address) {
        return `https://testnet.bscscan.com/address/${address}`;
    }

    function delay(segundos) {
        return new Promise((resolve) => {
            setTimeout(() => {
                resolve(undefined);
            }, 1000 * segundos);
        });
    }

    describe('Deploy Smart Contracts and testing it', () => {

        const secDelay = 20;

        it('[Mock USDT] Deploy Token', async function () {
            const Contract = await hre.ethers.getContractFactory(NAME_CONTRACT_MOCK_USDT);
            const contract = await Contract.deploy();
            contractUSDT = await contract.deployed();
            console.log('MockUSDT => ', generateContractLink(contractUSDT.address));
            expect(contractUSDT.deployTransaction.confirmations).to.be.equal(0);
            await delay(secDelay);
        });

        it('[Mock SuperNova] Deploy Token', async function () {
            const Contract = await hre.ethers.getContractFactory(NAME_CONTRACT_MOCK_SUPER_NOVA);
            const contract = await Contract.deploy();
            contractSuerNova = await contract.deployed();
            console.log('Mock SuperNova => ', generateContractLink(contractSuerNova.address));
            expect(contractSuerNova.deployTransaction.confirmations).to.be.equal(0);
            await delay(secDelay);
        });

        it('[Mock Presale] Instantiate the contract', async function () {
            const Contract = await hre.ethers.getContractFactory(NAME_CONTRACT_MOCK_PRESALE);
            const contract = await Contract.deploy(
                PRICE_1,
                PRICE_2,
                MAX_SUPPLY_1,
                MAX_SUPPLY_2,
                contractUSDT.address,
                contractSuerNova.address
            );
            contractMock = await contract.deployed();
            console.log('Mock Presale => ', generateContractLink(contractMock.address));
            expect(contractMock.deployTransaction.confirmations).to.be.equal(0);
            await delay(secDelay);
        });

        it('Approve tokens to use Mock USDT', async function () {
            const aBN = ethers.BigNumber.from("100000000000000");
            const bBN = ethers.BigNumber.from("10");
            const amount = aBN.mul(bBN);
            const response = await contractUSDT.approve(contractMock.address, amount);
            expect(response.confirmations).to.be.equal(0);
            await delay(secDelay);
        });

        it('Check kits solds to be 0', async function () {
            const responseKitOne = (await contractMock.kitsOneSold()).toString();
            const responseKitTwo = (await contractMock.kitsTwoSold()).toString();
            expect(responseKitOne).to.be.equal('0');
            expect(responseKitTwo).to.be.equal('0');
        });

        it('[Mock SuperNova] Transfer tokens to the MockPresale Smart contract', async function () {
            const aBN = ethers.BigNumber.from("100000000000000");
            const bBN = ethers.BigNumber.from("10");
            const amount = aBN.mul(bBN); // 0,001 ETH
            await contractSuerNova.transfer(contractMock.address, amount);
            await delay(secDelay);
        });

        it('Buy kit one', async function () {
            const responseBuyKitOne = await contractMock.buyKit(KIT_ONE);
            expect(responseBuyKitOne.confirmations).to.be.equal(0);
            await delay(secDelay);
        });

        it('Buy kit two', async function () {
            const responseBuyKitTwo = await contractMock.buyKit(KIT_TWO);
            expect(responseBuyKitTwo.confirmations).to.be.equal(0);
            await delay(secDelay);
        });

        it('Re-Check kits solds', async () => {
            const responseKitOne = (await contractMock.kitsOneSold()).toString();
            const responseKitTwo = (await contractMock.kitsTwoSold()).toString();
            console.log('kit one sold => ', responseKitOne);
            console.log('kit two sold => ', responseKitTwo);
            expect(responseKitOne).to.be.equal("1");
            expect(responseKitTwo).to.be.equal("1");
            await delay(secDelay);
        });

        it('Revert transaction when trying to buy more than max supply of kit one', async function () {
            await expect(contractMock.buyKit(KIT_ONE)).to.be.reverted;
            await expect(contractMock.buyKit(KIT_TWO)).to.be.reverted;
        });

        it('Get the pair created ', async () => {
            const response = await contractMock.pair();
            console.log('Pair created => ', response);
        });


    });

});