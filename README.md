# circom

# Circuit Implementation and Deployment Guide

This README file provides step-by-step instructions to implement a simple circuit using Circom, compile it, generate a proof, and deploy a Solidity verifier contract to the Sepolia or Mumbai Testnet. Finally, you will call the `verifyProof()` method on the verifier contract and assert the output is true.

## Prerequisites

Before you begin, ensure you have the following installed on your machine:

- Node.js (v14.x or higher)
- Circom (v2.0.3 or higher)
- SnarkJS (v0.4.8 or higher)
- Solidity (v0.8.x)
- Truffle or Hardhat (for contract deployment)
- Metamask or similar Ethereum wallet
- Access to Sepolia or Mumbai Testnet

## Step 1: Write the Circuit Implementation

Create a new file named `circuit.circom` and add the following code:

## Step 2: Compile the Circuit

Use Circom to compile the circuit and generate the intermediaries:

```sh
circom circuit.circom --r1cs --wasm --sym --c
```

This command will generate the following files:
- `circuit.r1cs`
- `circuit.wasm`
- `circuit.sym`
- `circuit_cpp/` (directory with C++ code)

## Step 3: Generate the Proof

First, create an input JSON file named `input.json` with the following content:

```json
{
  "A": 0,
  "B": 1
}
```

Next, generate the witness, setup phase, and the proof:

```sh
snarkjs wtns calculate circuit.wasm input.json witness.wtns
snarkjs groth16 setup circuit.r1cs pot12_final.ptau circuit_final.zkey
snarkjs zkey export verificationkey circuit_final.zkey verification_key.json
snarkjs groth16 prove circuit_final.zkey witness.wtns proof.json public.json
```

## Step 4: Deploy Solidity Verifier to Sepolia or Mumbai Testnet

1. Generate the Solidity verifier contract:

    ```sh
    snarkjs zkey export solidityverifier circuit_final.zkey verifier.sol
    ```

2. Deploy the `verifier.sol` contract to Sepolia or Mumbai Testnet using Truffle or Hardhat.

### Truffle

```sh
truffle init
```

Replace the content of `contracts/Verifier.sol` with the generated `verifier.sol`. Update `truffle-config.js` to configure the Sepolia or Mumbai network.

Deploy the contract:

```sh
truffle migrate --network sepolia
```

### Hardhat

```sh
npx hardhat init
```

Replace the content of `contracts/Verifier.sol` with the generated `verifier.sol`. Update `hardhat.config.js` to configure the Sepolia or Mumbai network.

Deploy the contract:

```sh
npx hardhat run scripts/deploy.js --network sepolia
```

## Step 5: Call verifyProof() Method

After deploying the contract, call the `verifyProof` method with the proof and public inputs. You can do this using a script or directly from your wallet.

### Example Script

Create a new script file, e.g., `verify.js`, and add the following:

```javascript
const { ethers } = require("ethers");
const Verifier = require("./build/contracts/Verifier.json");

const provider = new ethers.providers.JsonRpcProvider("YOUR_SEPOLIA_OR_MUMBAI_RPC_URL");
const wallet = new ethers.Wallet("YOUR_PRIVATE_KEY", provider);
const verifierContract = new ethers.Contract("VERIFIER_CONTRACT_ADDRESS", Verifier.abi, wallet);

async function verifyProof() {
    const proof = require("./proof.json");
    const publicSignals = require("./public.json");

    const isValid = await verifierContract.verifyProof(proof.proof, publicSignals);
    console.log(`Proof is valid: ${isValid}`);
}

verifyProof();
```

Run the script:

```sh
node verify.js
```

If everything is set up correctly, the output should be:

```
Proof is valid: true
```

## Conclusion

By following these steps, you have successfully implemented a simple circuit using Circom, compiled it, generated a proof, deployed a Solidity verifier contract to the Sepolia or Mumbai Testnet, and verified the proof. If you encounter any issues, ensure all dependencies are installed correctly and the configurations are properly set.
