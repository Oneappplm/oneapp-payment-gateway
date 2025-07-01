# app/services/solana/token_balance_service.rb
require 'net/http'
require 'json'

module Solana
  class TokenBalanceService
    def self.get_token_balance(wallet_address, token_mint)
      url = URI("https://api.devnet.solana.com")
      req = Net::HTTP::Post.new(url, 'Content-Type' => 'application/json')
      req.body = {
        jsonrpc: "2.0",
        id: 1,
        method: "getTokenAccountsByOwner",
        params: [
          wallet_address,
          { mint: token_mint },
          { encoding: "jsonParsed" }
        ]
      }.to_json

      res = Net::HTTP.start(url.hostname, url.port, use_ssl: true) { |http| http.request(req) }
      json = JSON.parse(res.body)
      value = json.dig("result", "value")
      return 0.0 if value.blank?

      ui_amount = value[0].dig("account", "data", "parsed", "info", "tokenAmount", "uiAmount")
      ui_amount.to_f
    rescue => e
      puts "❌ Failed to fetch token balance: #{e.message}"
      0.0
    end

    # Optional helper
    def self.get_medv_balance(wallet_address)
      get_token_balance(wallet_address, ENV["MEDV_TOKEN_MINT"])
    end
  end
end
