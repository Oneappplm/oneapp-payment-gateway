require "json"
require "net/http"

module Solana
  class MedvBalanceService
    def self.get_token_balance(wallet_address)
      url = URI("https://api.devnet.solana.com")
      req = Net::HTTP::Post.new(url, "Content-Type" => "application/json")
      req.body = {
        jsonrpc: "2.0",
        id: 1,
        method: "getTokenAccountsByOwner",
        params: [
          wallet_address,
          {
            mint: ENV["MEDV_TOKEN_MINT_ADDRESS"] # or use Rails.credentials.dig
          },
          {
            encoding: "jsonParsed"
          }
        ]
      }.to_json

      res = Net::HTTP.start(url.hostname, url.port, use_ssl: true) { |http| http.request(req) }
      json = JSON.parse(res.body)

      token_account = json.dig("result", "value", 0, "account", "data", "parsed", "info", "tokenAmount", "uiAmount")
      token_account || 0.0
    rescue => e
      puts "❌ Failed to fetch MEDV balance: #{e.message}"
      0.0
    end
  end
end
