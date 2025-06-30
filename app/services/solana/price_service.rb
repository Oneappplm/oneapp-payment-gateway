# app/services/solana/price_service.rb
require 'net/http'
require 'json'

module Solana
  class PriceService
    def self.sol_to_usd
      Rails.cache.fetch("sol_usd_price", expires_in: 10.minutes) do
        url = URI("https://api.coingecko.com/api/v3/simple/price?ids=solana&vs_currencies=usd")
        res = Net::HTTP.get(url)
        json = JSON.parse(res)
        json.dig("solana", "usd").to_f
      end
    rescue => e
      puts "❌ Failed to fetch SOL/USD: #{e.message}"
      0.0
    end
  end
end
