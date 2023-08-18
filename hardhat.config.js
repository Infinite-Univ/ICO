require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config()

const { ACOCUNT_PRIVATE_KEY } = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  mocha : {
    timeout : (60000 * 4) // 4 min
  },
  solidity: "0.8.18",
  networks: {
    bsctest: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      accounts: [ACOCUNT_PRIVATE_KEY]
    }
  }
};
