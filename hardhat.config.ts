import 'dotenv/config';
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import '@openzeppelin/hardhat-upgrades';
const { INFURA_API_KEY, ETHERSCAN_API_KEY, NETWORK,ACCOUNTS} = process.env;
const accounts = ACCOUNTS?.split(',');
const config: HardhatUserConfig = {
  solidity: "0.8.17",
  defaultNetwork: NETWORK || "hardhat",
  networks: {
    hardhat: {
      allowUnlimitedContractSize: true,
    },
    ganache: {
      url: 'http://127.0.0.1:8545',
      accounts
    },
    test: {
      url: 'http://ec2-54-178-23-104.ap-northeast-1.compute.amazonaws.com:8545',
      accounts
    },
    mainnet: {
      url: `https://mainnet.infura.io/v3/${INFURA_API_KEY}`,
      accounts
    },
    ropsten: {
      url: `https://ropsten.infura.io/v3/${INFURA_API_KEY}`,
      accounts
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${INFURA_API_KEY}`,
      accounts
    },
    goerli: {
      url: `https://goerli.infura.io/v3/b05e00d568ac421ebb76cf518e162c6b`,
      // chainId: 5,
      // gasPrice:20 * 10**9,
      timeout: 1000 * 60 * 60 * 5,
      gas: 2100000,
      gasPrice: 1000000000,
      accounts,
    },
    kovan: {
      url: `https://kovan.infura.io/v3/${INFURA_API_KEY}`,
      accounts
    },
    arbitrum: {
      url: `https://arbitrum-mainnet.infura.io/v3/${INFURA_API_KEY}`,
      accounts
    },
    optimismKovan: {
      url: `https://optimism-kovan.infura.io/v3/${INFURA_API_KEY}`,
      accounts
    },
    optimism: {
      url: `https://optimism-mainnet.infura.io/v3/${INFURA_API_KEY}`,
      accounts
    },
    mumbai: {
      url: `https://polygon-mumbai.infura.io/v3/${INFURA_API_KEY}`,
      accounts
    },
    polygon: {
      url: `https://polygon-mainnet.infura.io/v3/${INFURA_API_KEY}`,
      accounts
    },
  },
};

export default config;
