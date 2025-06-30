# app/services/solana/price_service.rb
require 'net/http'
require 'json'

module Solana
  class PriceService
    def self.sol_to_usd
      Rails.cache.fetch("sol_usd_price", expires_in: 10.minutes) do
        url = URI("https://api.coingecko.com/api/v3/simple/price?ids=solana&vs_currencies=usd")
        response = Net::HTTP.get(url)
        json = JSON.parse(response)

        price = json.dig("solana", "usd")
        puts "✅ SOL to USD rate: $#{price}"
        price.to_f
      end
    rescue => e
      puts "❌ Failed to fetch SOL/USD: #{e.message}"
      0.0
    end
  end
end

#This pulls live market data directly from CoinGecko’s servers.