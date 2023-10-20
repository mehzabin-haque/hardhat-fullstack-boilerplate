import { ethers } from 'hardhat';
import { expect } from 'chai';
import { Greeter__factory, Greeter } from '../frontend/typechain'


describe('greeter', () => {
	it("should return the new greeting once it's changed", async () => {
    const signers = await ethers.getSigners();

    // We simply assign the first signer to ownerSigner
    const ownerSigner = signers[0];

		const GreeterContract: Greeter = await new Greeter__factory(ownerSigner).deploy("Hello world!");
		let tx = await GreeterContract.setGreeting('Hola, mundo!');
    await tx.wait();
		expect(await GreeterContract.greet()).to.equal('Hola, mundo!');
	});
});