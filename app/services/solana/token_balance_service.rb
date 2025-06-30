# app/services/solana/token_balance_service.rb
require 'net/http'
require 'json'

module Solana
  class TokenBalanceService
    def self.get_medv_balance(wallet_address)
      url = URI("https://api.devnet.solana.com")
      req = Net::HTTP::Post.new(url, 'Content-Type' => 'application/json')
      req.body = {
        jsonrpc: "2.0",
        id: 1,
        method: "getTokenAccountsByOwner",
        params: [
          wallet_address,
          { mint: ENV["MEDV_TOKEN_MINT"] }, # set this in ENV
          { encoding: "jsonParsed" }
        ]
      }.to_json

      res = Net::HTTP.start(url.hostname, url.port, use_ssl: true) { |http| http.request(req) }
      json = JSON.parse(res.body)

      value = json.dig("result", "value")
      return 0.0 if value.blank?

      ui_amount = value[0].dig("account", "data", "parsed", "info", "tokenAmount", "uiAmountString")
      ui_amount.to_f
    rescue => e
      puts "❌ Failed to fetch MEDV token balance: #{e.message}"
      0.0
    end
  end
end
