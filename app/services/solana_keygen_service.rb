# app/services/solana_keygen_service.rb
require 'base64'
require 'rbnacl'
require 'base58'


# class SolanaKeygenService
#   def self.generate
#     signing_key = RbNaCl::Signatures::Ed25519::SigningKey.generate
#     verify_key = signing_key.verify_key

#     full_keypair = signing_key.to_bytes + verify_key.to_bytes # 64 bytes total

#     {
#       public_key: Base58.binary_to_base58(verify_key.to_bytes, :bitcoin), # ✅ Base58-encoded public key
#       private_key_base58: Base58.binary_to_base58(full_keypair, :bitcoin) # ✅ Full 64-byte key
#     }
#   end

#   def self.load_keypair(base58_private_key)
#     bytes = Base58.base58_to_binary(base58_private_key, :bitcoin)
#     raise "Invalid secret key length" unless bytes.length == 64

#     RbNaCl::Signatures::Ed25519::SigningKey.new(bytes[0, 32])
#   end
# end
class SolanaKeygenService
  def self.generate
    signing_key = RbNaCl::Signatures::Ed25519::SigningKey.generate
    verify_key = signing_key.verify_key

    full_keypair = signing_key.to_bytes + verify_key.to_bytes # 64-byte secret key

    {
      public_key: Base58.binary_to_base58(verify_key.to_bytes, :bitcoin),    # ✅ Solana format
      private_key_base64: Base64.strict_encode64(full_keypair)               # ✅ For transfer.js
    }
  end

  def self.load_keypair(base64_private_key)
    bytes = Base64.strict_decode64(base64_private_key)
    raise "Invalid key length: #{bytes.length}" unless bytes.length == 64

    RbNaCl::Signatures::Ed25519::SigningKey.new(bytes[0, 32])
  end
end


