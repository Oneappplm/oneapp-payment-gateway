// lib/solana/generate_keypair.js

const { Keypair } = require('@solana/web3.js');

function generateKeypair() {
  const keypair = Keypair.generate();

  const publicKey = keypair.publicKey.toBase58(); // ✅ Solana address
  const privateKeyBase64 = Buffer.from(keypair.secretKey).toString('base64'); // ✅ 64-byte Uint8Array → Base64

  return {
    publicKey,
    privateKeyBase64,
  };
}

const keys = generateKeypair();
console.log(JSON.stringify(keys, null, 2));
