
# DAOGovernance Hardhat Project

This project implements a basic DAO Governance smart contract using Solidity and Hardhat. The `DAOGovernance` contract allows users to create proposals and vote on them, with each proposal assigned a unique dynamic ID.

## Features
- Create proposals with a description (max 100 characters)
- Each proposal has a unique, auto-incremented ID
- Voting period is set by `votingDuration` (default: 3 days)
- Tracks yes/no votes, proposal creator, and execution status

## Project Structure
- `contracts/DAOGovernance.sol`: Main DAO governance contract
- `test/`: Contains test scripts for the contract
- `ignition/modules/`: Deployment scripts for Hardhat Ignition

## Usage

### Install dependencies
```shell
npm install
```

### Compile contracts
```shell
npx hardhat compile
```

### Run tests
```shell
npx hardhat test
```

### Start local node
```shell
npx hardhat node
```

### Deploy contract (example)
```shell
npx hardhat ignition deploy ./ignition/modules/Lock.ts
```

## DAOGovernance Contract Example

```solidity
// Create a proposal
function createProposal(string calldata _description) external
```

## Development Notes
- Uses Solidity ^0.8.28
- Uses Hardhat for development and testing
- Console logging in Solidity is supported via Hardhat's `console.sol` (see contract for usage)

---
Feel free to contribute or open issues for improvements!
