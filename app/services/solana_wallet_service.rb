# app/services/solana_wallet_service.rb
require 'net/http'
require 'uri'
require 'json'

class SolanaWalletService
  SOLANA_ENDPOINT = "https://api.devnet.solana.com"

  def self.credit_tokens(wallet, amount)
    lamports = (amount * 1_000_000).to_i

    request_body = {
      jsonrpc: "2.0",
      id: 1,
      method: "requestAirdrop",
      params: [wallet.address, lamports]
    }

    uri = URI.parse(SOLANA_ENDPOINT)
    response = Net::HTTP.post(uri, request_body.to_json, "Content-Type" => "application/json")

    result = JSON.parse(response.body)

    if result["result"]
      Rails.logger.info("Airdropped #{amount} MEDV to #{wallet.address}, tx: #{result["result"]}")
      true
    else
      Rails.logger.error("Airdrop failed: #{result["error"]}")
      false
    end
  rescue => e
    Rails.logger.error("Solana RPC Error: #{e.message}")
    false
  end
end
