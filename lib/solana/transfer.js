const solanaWeb3 = require('@solana/web3.js');
const {
  Connection,
  clusterApiUrl,
  Keypair,
  PublicKey,
  Transaction,
  SystemProgram,
  sendAndConfirmTransaction
} = solanaWeb3;

async function transfer() {
  const [senderPrivateKeyBase64, receiverAddress, amountStr] = process.argv.slice(2);

  if (!senderPrivateKeyBase64 || !receiverAddress || !amountStr) {
    console.error("❌ Usage: node transfer.js <PRIVATE_KEY_BASE64> <TO_ADDRESS> <AMOUNT_SOL>");
    process.exit(1);
  }

  try {
    const secretKey = Buffer.from(senderPrivateKeyBase64, 'base64');
    
    console.log("🔐 Decoded key length:", secretKey.length);

    if (secretKey.length !== 64) {
      throw new Error(`bad secret key size: expected 64 bytes, got ${secretKey.length}`);
    }

    const fromKeypair = Keypair.fromSecretKey(secretKey);
    const toPublicKey = new PublicKey(receiverAddress);
    const amount = parseFloat(amountStr) * solanaWeb3.LAMPORTS_PER_SOL;
    const connection = new Connection(clusterApiUrl("devnet"), "confirmed");

    const transaction = new Transaction().add(
      SystemProgram.transfer({
        fromPubkey: fromKeypair.publicKey,
        toPubkey: toPublicKey,
        lamports: amount,
      })
    );

    const signature = await sendAndConfirmTransaction(connection, transaction, [fromKeypair]);
    console.log(signature);
  } catch (error) {
    console.error("❌ Transaction failed:", error.message);
    process.exit(1);
  }
}

transfer();
