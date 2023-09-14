import { outputFile } from 'fs-extra';
import { char2Bytes } from '@taquito/utils';
import { InMemorySigner } from '@taquito/signer';
import { TezosToolkit, MichelsonMap } from '@taquito/taquito';

import * as dotenv from 'dotenv';
import code from '../compiled/main.json';
import metadata from "./metadata.json";

dotenv.config(({ path: '.env' }));

const TezosNodeRPC: string = process.env.TEZOS_NODE_URL;
const publicKey: string = process.env.ADMIN_PUBLIC_KEY;
const privateKey: string = process.env.ADMIN_PRIVATE_KEY;

const signature = new InMemorySigner(privateKey);
const Tezos = new TezosToolkit(TezosNodeRPC);
Tezos.setProvider({ signer: signature });

Tezos.tz.getBalance(publicKey)
    .then((balance) => console.log(`The balance of ${publicKey} is ${balance.toNumber() / 1000000} ꜩ`))
    .catch((error) => console.log(JSON.stringify(error)));

const saveContractAddress = (name : string, address : string) => {
    outputFile(`./scripts/deployments/${name}.ts`,
    `export default ${address}`
    )
}

const deploy = async () => {
    const storage = {
        admin : publicKey,
        winner : null,
        numbers : new MichelsonMap(),
    }
    const origination = await Tezos.contract.originate({
        code: code,
        storage: storage
    });

    console.log('Awaiting confirmation...');
    const contract = await origination.contract();
    console.log('Deployed at:', contract.address);
}

deploy();