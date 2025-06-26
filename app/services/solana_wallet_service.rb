# app/services/solana_wallet_service.rb
class SolanaWalletService
  def self.credit_tokens(wallet_address, amount)
    Rails.logger.info "Simulating transfer of #{amount} MEDV tokens to #{wallet_address}"
    # Replace with actual Solana transfer logic via Solana Web3 / py
    true
  end
end
