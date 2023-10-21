import { ethers } from 'hardhat';
import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from 'chai';
import { Greeter__factory, Greeter } from '../frontend/typechain'


describe('greeter', () => {

  async function deployOnceFixture() {
    const [owner, ...otherAccounts] = await ethers.getSigners();
    const greeter: Greeter = await new Greeter__factory(owner).deploy("Hello world!");
    return { greeter, owner, otherAccounts };
  }

	it("should return the new greeting once it's changed", async () => {
    const { greeter, owner } = await loadFixture(deployOnceFixture);
		let tx = await greeter.setGreeting('Hola, mundo!');
    await tx.wait();
		expect(await greeter.greet()).to.equal('Hola, mundo!');
	});
});