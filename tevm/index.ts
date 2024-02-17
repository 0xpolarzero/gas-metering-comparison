// Run from /tevm with: pnpm ts-node index.ts
import { TevmClient, createMemoryClient } from 'tevm';
import { MOCKERC20_BYTECODE, MOCKERC20_ABI } from './constants';

const MINT_ITERATIONS = 2;

/* ------------------------------- BENCHMARKS ------------------------------- */
/**
 * Results with many zeroes: {
    recipient: '0x0000000000000000000000000000000000000001',
    amount: '0x0000000000000000000000000000000000000000000000000000000000000001',
    gasUsed: [ '46495', '2695' ]
  }

 * Results with no zeroes: {
    recipient: '0x1111111111111111111111111111111111111111',
    amount: '0x1111111111111111111111111111111111111111111111111111111111111111',
    gasUsed: [ '46495', '2695' ]
  }
 */

/* ---------------------------------- TEVM ---------------------------------- */
// Batch mint provided tokens ids/amounts pairs
const mintTwice = async (recipient: string, amount: string) => {
  const caller = `0x${'1'.repeat(40)}` as const;
  const tevm = await createMemoryClient({
    fork: {
      url: 'https://eth.llamarpc.com',
    },
  });

  const token = '0x171593d3E5Bc8A2E869600F951ed532B9780Cbd2';
  await tevm.setAccount({
    address: token,
    deployedBytecode: MOCKERC20_BYTECODE,
  });

  let gasUsed: string[] = [];
  for (let i = 0; i < MINT_ITERATIONS; i++) {
    const { executionGasUsed, errors } = await tevm.contract({
      caller,
      to: token,
      abi: MOCKERC20_ABI,
      functionName: 'mint',
      args: [recipient, amount],
      createTransaction: true,
    });

    if (errors) console.log('Errors:', errors);
    gasUsed.push(executionGasUsed.toString());
  }

  return { recipient, amount, gasUsed };
};

/* ---------------------------------- MAIN ---------------------------------- */
const main = async () => {
  const withManyZeroes = [
    '0x0000000000000000000000000000000000000001',
    '0x0000000000000000000000000000000000000000000000000000000000000001',
  ];
  const withNoZero = [
    '0x1111111111111111111111111111111111111111',
    '0x1111111111111111111111111111111111111111111111111111111111111111',
  ];

  const resultsWithManyZeroes = await mintTwice(
    withManyZeroes[0],
    withManyZeroes[1],
  );
  const resultsWithNoZero = await mintTwice(withNoZero[0], withNoZero[1]);

  console.log('Results with many zeroes:', resultsWithManyZeroes);
  console.log('Results with no zeroes:', resultsWithNoZero);
};

main();
