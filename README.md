<<<<<<< HEAD
# Hardhat Full Stack Dapp Boilerplate

A fullstack hardhat and wagmi based dapp boilerplate ready to hack 🙌

## Used Technology
 - [👷🏽‍♂️ Hardhat](https://www.rainbowkit.com/)
 - [🌈 RainbowKit](https://hardhat.org/)
 - [➬ WAGMI](https://wagmi.sh/)
 - [🌐 Next JS](https://nextjs.org/)
 - [🗺 Etherscan](https://etherscan.io/)
 - [🕹 Typechain](https://github.com/dethcrypto/TypeChain)
 - [TailwindCSS](https://tailwindcss.com) – Utility-first CSS framework for rapid UI development
 - [TypeScript](https://www.typescriptlang.org/) – Static type checker for end-to-end typesafety
 - [Prettier](https://prettier.io/) – Opinionated code formatter for consistent code style
 - [ESLint](https://eslint.org/) – Pluggable linter for Next.js and TypeScript

## Prerequisite
```
Node js
npm
yarn
```
## Install dependencies
Install yarn:
```
npm i -g yarn
```
For contract dev:
Run this command on the root folder:
```
yarn
```

For Frontend dev:
Go to `frontend` folder and install node modules:
```
cd frontend
yarn

```

## Instruction
- Install a wallet like [Metamask](https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn)
- Copy `.env.example` to `.env`
  * Mac or Linux
    * ```cp .env.example .env```
  * Windows
    * ```copy .env.example .env```
- Set the env variable in `.env` file on root level and on `frontend` folder:

Variable descriptions:

1. `RPC_NODE_API_KEY`: Get from [Alchemy site](https://auth.alchemy.com/signup/) after sign up and login
2. `PRIVATE_KEY`: Export private key from metamask, follow these [instructions](https://support.metamask.io/hc/en-us/articles/360015289632-How-to-export-an-account-s-private-key)
3. `ETHERSCAN_API_KEY`: Get from [etherscan](https://etherscan.io/login)

Frontend ENV Variable:
4. `NEXT_PUBLIC_ALCHEMY_API_KEY` : Same as `RPC_NODE_API_KEY` 
- Compile Contract:
```
=======
**Repository Name:** hardhat-fullstack-boilerplate

# Hardhat Project Boilerplate

Welcome to the Hardhat Project Boilerplate, a starting point for your full-stack TypeScript blockchain projects. This boilerplate is designed to help you kickstart your development with the Hardhat framework.

## Instructions

### Compilation
To compile your project, use the following command:
```bash
>>>>>>> 302ec250803f16a20504d7955b9532340c93b3b9
npm run compile
```

### Testing
Run your tests with:
```bash
npm run test
```

### Deployment
To deploy your contracts, utilize:
```bash
npm run deploy:<network>
```
<<<<<<< HEAD
- Verify on etherscan
```
npx hardhat verify --network sepolia <YOUR_CONTRACT_ADDRESS> <Paramaters>
```
For example for `Greeter` contract:
```
npx hardhat verify --network sepolia 0xAECD7dFD9d5ED08EA916B052D90A75366B963A61 "Hello world"
=======
Replace `<network>` with the target network for deployment.

### Contract Verification on Etherscan
To verify your contracts on Etherscan, execute:
```bash
npx hardhat verify --network rinkeby <YOUR_CONTRACT_ADDRESS>
>>>>>>> 302ec250803f16a20504d7955b9532340c93b3b9
```
Make sure to replace `<YOUR_CONTRACT_ADDRESS>` with your specific contract address.

## Getting Started

1. Clone this repository to your local machine.
2. Navigate to the project directory.
3. Customize the boilerplate to match your project requirements.

