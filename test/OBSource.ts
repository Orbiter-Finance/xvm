import { OBSource } from "../typechain-types";
import { deploy } from "../scripts/utils";
import { expect } from 'chai';
describe("OBSource", function () {
    describe("Deployment", function () {
        it("Deploy", async function () {
          const contract = await deploy<OBSource>(false,'OBSource');
          expect(await contract.address).not.empty;
        });
    });
});