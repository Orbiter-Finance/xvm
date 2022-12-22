import { ethers } from "hardhat";
import { OrbiterBridge, TestToken } from "../typechain-types";
import { deploy } from "./utils";
async function main() {
    const makerAddress = '0x0043d60e87c5dd08C86C3123340705a1556C4719';
    const xvm = await deploy<OrbiterBridge>(false, 'OrbiterBridge', makerAddress)
    console.log('USDT:');
    const usdt = await deploy<TestToken>(false, 'TestToken', ethers.utils.parseEther('10000000000000'), 6, 'USDT')
    console.log('USDC:');
    const usdc = await deploy<TestToken>(false, 'TestToken', ethers.utils.parseEther('10000000000000'), 6, 'USDC')
    console.log("DAI:")
    const dai = await deploy<TestToken>(false, 'TestToken', ethers.utils.parseEther('10000000000000'), 18, 'DAI')
    let tx = await usdt.transfer(makerAddress, "10000000000000");
    console.log(`hash：${tx.hash}`);
    await tx.wait();
    tx = await usdc.transfer(makerAddress, "10000000000000");
    console.log(`hash：${tx.hash}`);
    await tx.wait();
    tx = await dai.transfer(makerAddress, ethers.utils.parseEther('100000000'));
    console.log(`hash：${tx.hash}`);
    await tx.wait();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
