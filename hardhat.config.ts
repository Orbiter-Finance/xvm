import 'dotenv/config';
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-web3";
import 'hardhat-contract-sizer';
import '@openzeppelin/hardhat-upgrades';
const { INFURA_API_KEY ,ALCHEMY_KEY, NETWORK,ACCOUNTS} = process.env;
const accounts = ACCOUNTS?.split(',');
const config: HardhatUserConfig = {
  defaultNetwork: NETWORK || "hardhat",
  solidity: {
    version: '0.8.17',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
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
    goerli: {
      url: `https://eth-goerli.g.alchemy.com/v2/${ALCHEMY_KEY}`,
      // chainId: 5,
      // gasPrice:1 * 10**9,
      timeout: 1000 * 60 * 60 * 5,
      // gas: 300000,
      // gasPrice: 1000000000,
      accounts,
    },
    arbitrum: {
      url: `https://arbitrum-mainnet.infura.io/v3/${INFURA_API_KEY}`,
      accounts
    },
    arbitrumGoerli: {
      url: `https://goerli-rollup.arbitrum.io/rpc`,
      accounts
    },
    optimismGoerli: {
      url: `https://goerli.optimism.io`,
      accounts
    },
    optimism: {
      url: `https://optimism-mainnet.infura.io/v3/${INFURA_API_KEY}`,
      accounts
    },
    mumbai: {
      url: `https://polygon-testnet.public.blastapi.io`,
      accounts
    },
    metisGoerli: {
      url: `https://stardust.metis.io/?owner=588`,
      accounts
    },
    zksyncGoerli: {
      url: `https://zksync2-testnet.zksync.dev`,
      accounts
    },
    scrollGoerli: {
      url: `https://prealpha.scroll.io/l2`,
      accounts
    },
    bscTestnet: {
      url: `https://data-seed-prebsc-2-s3.binance.org:8545`,
      accounts
    },
    polygonZKEVM: {
      url:"https://rpc.public.zkevm-test.net",
      accounts
    },
    polygon: {
      url: `https://polygon-mainnet.infura.io/v3/${INFURA_API_KEY}`,
      accounts
    },
  },
};

export default config;
