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
    const PRICE_2 = 1;
    const MAX_SUPPLY_1 = 5;
    const MAX_SUPPLY_2 = 7;

    describe('MockUSDT', () => {

        it('Deploy Token', async function () {
            const Contract = await hre.ethers.getContractFactory(NAME_CONTRACT_MOCK_USDT);
            const contract = await Contract.deploy();
            contractUSDT = await contract.deployed();
            expect(contractUSDT.deployTransaction.confirmations).to.be.equal(1);
        });

    });

    describe('SuperNova', () => {

        it('Deploy Token', async function () {
            const Contract = await hre.ethers.getContractFactory(NAME_CONTRACT_MOCK_SUPER_NOVA);
            const contract = await Contract.deploy();
            contractSuerNova = await contract.deployed();
            expect(contractSuerNova.deployTransaction.confirmations).to.be.equal(1);
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
            expect(contractMock.deployTransaction.confirmations).to.be.equal(1);
        });

        it('Approving tokens to use', async function () {
            
            //expect().to.be() // confirmation success
        });

        /*
        it('Check kits solds to be 0', async function () {

            const responseKitOne = (await contractMock.kitsOneSold()).toString();
            const responseKitTwo = (await contractMock.kitsTwoSold()).toString();
            expect(responseKitOne).to.be.equal('0'); // expect transaction confirmation
            expect(responseKitTwo).to.be.equal('0'); // expect transaction confirmation

        });
        */
        /*
                it('Buy kit one', async function () {
        
                    const responseBuyKitOne = await contractMock.buyKit(KIT_ONE);
                    const responseBuyKitTwo = await contractMock.buyKit(KIT_TWO);
                    console.log(responseBuyKitOne);
                    //expect().to.be(); // expect transaction confirmation
                    //expect().to.be(); // expect different balance
                });
                */

        /*
                it('Trying to buy more than max supply of kit one', async function () {
        
                    expect().to.be(); // expect transaction revert
                });
        
                it('Buy kit two', async function () {
        
                    expect().to.be(); // expect transaction confirmation
                    expect().to.be(); // expect different balance
                });
        
        
                it('Trying to buy more than max supply of kit two', async function () {
        
                    expect().to.be(); // expect transaction revert
                });
        
                it('Check kitsOneSold and kitsTwoSold', async function () {
        
                    expect().to.be(); // expect transaction confirmation
                    expect().to.be(); // expect have the same lenght of buyers counter
                });
        */

    });

});