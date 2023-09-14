import { InMemorySigner } from '@taquito/signer';
import { TezosToolkit, MichelsonMap } from '@taquito/taquito';

import accounts from "../account";
import networks from "../config";
import contractAddress from "./deployments/deployed_contracts";
console.log(`contract address : ${contractAddress}`);

import * as dotenv from 'dotenv';
import * as assert from 'assert';

dotenv.config(({ path: '.env' }));

const network = process.env.TEZ_NETWORK ? process.env.TEZ_NETWORK : Error("No network specified")

if (network == "mainnet") {
    console.log("Warning you are about to deploy to mainnet !");
} else {
    const TezosNodeRPC : string = networks[network].node_url;
    const publicKey: string = accounts[network].alice.publicKey;
    const privateKey: string = accounts[network].alice.privateKey;
}

const signature = new InMemorySigner(privateKey);
const Tezos = new TezosToolkit(TezosNodeRPC);
Tezos.setProvider({ signer: signature });

Tezos.tz.getBalance(publicKey)
    .then((balance) => console.log(`The balance of ${publicKey} is ${balance.toNumber() / 1000000} ꜩ`))
    .catch((error) => console.log(JSON.stringify(error)));

const call_submitNumber = async () => {
    try {
        const instance = await Tezos.contract.at(contractAddress);
        const op = await instance.methodsObject.submitNumber(2).send();
        console.log(`Hash : ${op}`);
    }
    catch (error) {
        console.log(error)
    }
}

call_submitNumber();

