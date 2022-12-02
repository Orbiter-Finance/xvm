import { ethers } from "hardhat";
import { OBSource } from "../typechain-types";
import { deploy } from "./utils";

async function main() {
  const contract = await deploy<OBSource>(false,'OBSource')

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
