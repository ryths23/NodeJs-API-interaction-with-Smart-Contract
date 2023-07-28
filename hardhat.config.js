require("@nomicfoundation/hardhat-toolbox");


// task("accounts", "Print the list of account",async()=>{
//   const accounts=await ethers.getSigners();

//   for( const account of accounts){
//     console.log(account.address);
//   }
// });


// Go to https://infura.io, sign up, create a new API key
// in its dashboard, and replace "KEY" with it


// Replace this private key with your Sepolia account private key
// To export your private key from Coinbase Wallet, go to
// Settings > Developer Settings > Show private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Beware: NEVER put real Ether into testing accounts
require('dotenv').config();
//const {INFURA_API_KEY, API_URL}= process.env;
const API_URL=process.env.API_URL;
const SEPOLIA_PRIVATE_KEY=process.env.SEPOLIA_PRIVATE_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
    sepolia: {
      url: [API_URL],
      accounts: [SEPOLIA_PRIVATE_KEY]
    }
  }
};
