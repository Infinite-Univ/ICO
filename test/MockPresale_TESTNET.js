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
    const MAX_SUPPLY_1 = 5;
    const MAX_SUPPLY_2 = 7;

    describe('MockUSDT', () => {

        it('Deploy Token', async function () {
            const Contract = await hre.ethers.getContractFactory(NAME_CONTRACT_MOCK_USDT);
            const contract = await Contract.deploy();
            contractUSDT = await contract.deployed();
            expect(contractUSDT.deployTransaction.confirmations).to.be.equal(0);
        });

    });

    describe('SuperNova', () => {

        it('Deploy Token', async function () {
            const Contract = await hre.ethers.getContractFactory(NAME_CONTRACT_MOCK_SUPER_NOVA);
            const contract = await Contract.deploy();
            contractSuerNova = await contract.deployed();
            expect(contractSuerNova.deployTransaction.confirmations).to.be.equal(0);
        })

    });

    describe('MockPresale', function () {

        it('Instantiate the contract', async function () {
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
            expect(contractMock.deployTransaction.confirmations).to.be.equal(0);
        });

        it('Approve tokens to use USDT', async function () {
            const aBN = ethers.BigNumber.from("100000000000000");
            const bBN = ethers.BigNumber.from("10");
            const amount = aBN.mul(bBN); // 0,001 ETH
            console.log('monto habilitado => ', amount);
            const response = await contractUSDT.approve(contractMock.address, amount);
            expect(response.confirmations).to.be.equal(0);
        });

        it('Check kits solds to be 0', async function () {
            const responseKitOne = (await contractMock.kitsOneSold()).toString();
            const responseKitTwo = (await contractMock.kitsTwoSold()).toString();
            expect(responseKitOne).to.be.equal('0');
            expect(responseKitTwo).to.be.equal('0');
        });

        it('Checking balance available', async function () {
            const [owner] = await ethers.getSigners();
            const response = await contractUSDT.balanceOf(owner.address);
            const responseSP = await contractSuerNova.balanceOf(owner.address);
            console.log('balance tokens USDT => ', response);
            console.log('balance tokens Super Nova => ', responseSP);
        });

        it('Buy kit one', async function () {
            const responseBuyKitOne = await contractMock.buyKit(KIT_ONE);
            console.log('respuesta kit uno vendido =>', responseBuyKitOne);
            expect(responseBuyKitOne.confirmations).to.be.equal(0);
        });

        it('Buy kit two', async function () {
            const responseBuyKitTwo = await contractMock.buyKit(KIT_TWO);
            console.log('respuesta kit dos vendido => ', responseBuyKitTwo);
            expect(responseBuyKitTwo.confirmations).to.be.equal(0);
        });

        it('Re-Check kits solds', async () => {
            const responseKitOne = (await contractMock.kitsOneSold()).toString();
            const responseKitTwo = (await contractMock.kitsTwoSold()).toString();
            console.log('resultado kit uno vendidos => ', responseKitOne);
            console.log('resultado kit dos vendidos => ', responseKitTwo);
            expect(responseKitOne).to.be.equal(1);
            expect(responseKitTwo).to.be.equal(1);
        });

        /*
                it('Trying to buy more than max supply of kit one', async function () {
        
                    expect().to.be(); // expect transaction revert
                });
        */

    });

});