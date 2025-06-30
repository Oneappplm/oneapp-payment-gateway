const {
  Connection,
  clusterApiUrl,
  PublicKey,
  LAMPORTS_PER_SOL
} = require('@solana/web3.js');

const walletAddress = process.argv[2];
if (!walletAddress) {
  console.error("❌ Usage: node airdrop.js <WALLET_ADDRESS>");
  process.exit(1);
}

const connection = new Connection(clusterApiUrl("devnet"), "confirmed");

(async () => {
  try {
    const pubkey = new PublicKey(walletAddress);
    console.log("💸 Requesting airdrop to:", walletAddress);
    const sig = await connection.requestAirdrop(pubkey, 1 * LAMPORTS_PER_SOL);
    await connection.confirmTransaction(sig);
    console.log("✅ Airdrop complete. TX:", sig);
  } catch (error) {
    console.error("❌ Airdrop failed:", error.message);
    process.exit(1);
  }
})();
