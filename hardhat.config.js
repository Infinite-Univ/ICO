require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config()

const { ACOCUNT_PRIVATE_KEY } = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  networks: {
    bsctest: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      accounts: [ACOCUNT_PRIVATE_KEY]
    }
  }
};
