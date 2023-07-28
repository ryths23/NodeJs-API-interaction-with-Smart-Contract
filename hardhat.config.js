require("@nomicfoundation/hardhat-toolbox");

require('dotenv').config();
const API_URL=process.env.API_URL;
const SEPOLIA_PRIVATE_KEY=process.env.SEPOLIA_PRIVATE_KEY;
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
    sepolia: {
      url: API_URL,
      accounts: [SEPOLIA_PRIVATE_KEY]
    }
  }
};
