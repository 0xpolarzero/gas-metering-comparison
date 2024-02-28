import { loadFixture } from '@nomicfoundation/hardhat-toolbox-viem/network-helpers';
import { viem } from 'hardhat';

const MINT_ITERATIONS = 2;

describe('MockERC20', function () {
  const deployMockERC20Fixture = async () => {
    const mockERC20 = await viem.deployContract('MockERC20', []);
    console.log(mockERC20);
    const publicClient = await viem.getPublicClient();

    const mintMultipleAndReturnGasUsed = async (
      recipient: `0x${string}`,
      amount: bigint
    ): Promise<string[]> => {
      let gasUsed = [];

      for (let i = 0; i < MINT_ITERATIONS; i++) {
        const txHash = await mockERC20.write.mint([recipient, amount]);
        const receipt = await publicClient.waitForTransactionReceipt({
          hash: txHash,
        });
        gasUsed.push(receipt.gasUsed.toString());
      }

      return gasUsed;
    };

    return { mintMultipleAndReturnGasUsed };
  };

  describe('Mint', function () {
    it('Many zero bytes', async function () {
      const { mintMultipleAndReturnGasUsed } = await loadFixture(
        deployMockERC20Fixture
      );

      const gasUsed = await mintMultipleAndReturnGasUsed(
        '0x0000000000000000000000000000000000000001',
        BigInt(
          '0x0000000000000000000000000000000000000000000000000000000000000001'
        )
      );

      console.log(
        'Gas used with many zero bytes:\n',
        gasUsed.map((gas, i) => `Tx ${i + 1}: ${gas}`).join('\n')
      );
    });

    it('No zero byte', async function () {
      const { mintMultipleAndReturnGasUsed } = await loadFixture(
        deployMockERC20Fixture
      );

      const gasUsed = await mintMultipleAndReturnGasUsed(
        '0x1111111111111111111111111111111111111111',
        BigInt(
          '0x1111111111111111111111111111111111111111111111111111111111111111'
        )
      );

      console.log(
        'Gas used with no zero bytes:\n',
        gasUsed.map((gas, i) => `Tx ${i + 1}: ${gas}`).join('\n')
      );
    });
  });
});
