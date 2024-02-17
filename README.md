# Gas measurements comparison

Comparing the way Forge, Tevm, Hardhat and forge-gas-metering will report gas usage against Sepolia testnet transactions.

There are two subsequent mint transactions on a newly deployed mock ERC20 contract, for each of the two scenarios. There are 50 `0` bytes from the transaction's data in the first scenario that are turned into `1` bytes in the second one, which explains the expected 600 gas overhead (`600 = 50 * (16 - 4)`).

The idea is to figure out which of these tools will report different gas usage based on the amount of zero and non-zero bytes that need to be read/written.

## Results

> The process is the following:
>
> 1. deploy the contract;
> 2. mint the same amount of tokens to the same address twice.
>
> `recipient = 0x0000000000000000000000000000000000000001 | 0x1111111111111111111111111111111111111111`
>
> `amount = 0x0000000000000000000000000000000000000000000000000000000000000001 | 0x1111111111111111111111111111111111111111111111111111111111111111`

| Medium                 | Zero bytes (1st) | Non-zero bytes (1st) | Zero bytes (2nd) | Non-zero bytes (2nd) | Difference (1st) | Difference (2nd) |
| ---------------------- | ---------------- | -------------------- | ---------------- | -------------------- | ---------------- | ---------------- |
| Reference (Sepolia tx) | 67,839           | 68,439               | 33,639           | 34,239               | 600              | 600              |
| Hardhat                | 68,218           | 68,818               | 34,018           | 34,618               | 600              | 600              |
| forge-gas-metering     | 63,879           | 64,479               | 21,579           | 22,179               | 600              | 600              |
| Forge (test)           | 51,507           | 51,507               | 3,201            | 3,201                | 0                | 0                |
| Forge (script)         | 46,895           | 46,895               | 3,095            | 3,095                | 0                | 0                |
| Tevm                   | 46,495           | 46,495               | 2,695            | 2,695                | 0                | 0                |

## How to reproduce

### Clone and install

```bash
git clone git@github.com:0xpolarzero/gas-metering-comparison.git
cd gas-metering-comparison

# From the root:
# Foundry
cd foundry
forge install

# Hardhat
cd hardhat
pnpm install

# Tevm
cd tevm
pnpm install
```

### Sepolia

This will deploy the contract and mint the tokens twice. Which will provide both the reference Sepolia txs and the measurements from the script.

**In `/foundry`**:

1. Create `.env` and fill it with the content in `.env.example`;

2. run `source .env`;

3. deploy the contract and mint the tokens:

```bash
  forge script script/DeployAndCall.s.sol:DeployAndCall --rpc-url $RPC_URL_SEPOLIA --broadcast -vvvv --sig "run(address, uint256)" 0x0000000000000000000000000000000000000001 0x0000000000000000000000000000000000000000000000000000000000000001
  # or
  forge script script/DeployAndCall.s.sol:DeployAndCall --rpc-url $RPC_URL_SEPOLIA --broadcast -vvvv --sig "run(address, uint256)" 0x1111111111111111111111111111111111111111 0x1111111111111111111111111111111111111111111111111111111111111111
```

### Hardhat

**In `/hardhat`**: run `pnpm hardhat test`.

### forge-gas-metering

**In `/foundry`**: run `forge test --mc MockERC20ForgeGasMetering -vv`.

### Foundry (Forge)

**In `/foundry`**: run `forge test --mc MockERC20Foundry -vv`.

### Tevm

**In `/tevm`**: run `pnpm ts-node index.ts`.
