# app/services/solana/balance_service.rb
require 'net/http'
require 'json'

# app/services/solana/balance_service.rb
module Solana
  class BalanceService
    def self.get_balance(address)
      Rails.cache.fetch("sol_balance_#{address}", expires_in: 5.minutes) do
        url = URI("https://api.devnet.solana.com")
        req = Net::HTTP::Post.new(url, 'Content-Type' => 'application/json')
        req.body = {
          jsonrpc: "2.0",
          id: 1,
          method: "getBalance",
          params: [address]
        }.to_json

        res = Net::HTTP.start(url.hostname, url.port, use_ssl: true) { |http| http.request(req) }
        json = JSON.parse(res.body)
        lamports = json.dig("result", "value") || 0
        (lamports.to_f / 1_000_000_000).round(5)
      end
    rescue => e
      puts "❌ Balance fetch failed: #{e.message}"
      0.0
    end
  end
end

