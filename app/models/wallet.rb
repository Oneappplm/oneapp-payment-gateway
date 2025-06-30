class Wallet < ApplicationRecord
  belongs_to :user
  has_many :wallet_transactions

  encrypts :encrypted_private_key

  before_create :generate_solana_keys

  def decrypted_private_key_base64
    encrypted_private_key
  end

  def private_key_bytesize
    Base64.binary_from_base58(decrypted_private_key_base64).bytesize
  end


  private

  def generate_solana_keys
    return if public_key.present? && encrypted_private_key.present?

    keypair = SolanaKeygenService.generate
    self.public_key = keypair[:public_key]
    self.encrypted_private_key = keypair[:private_key_base58]
  end
end

