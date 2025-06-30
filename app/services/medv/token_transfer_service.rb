# app/services/medv/token_transfer_service.rb
require 'base64'

module Medv
  class TokenTransferService
    def initialize(invoice)
      @invoice = invoice
      @patient = invoice.patient
      @doctor = invoice.doctor
      @amount = invoice.amount.to_f

      # ✅ Reuse existing patient wallet or create once
      @sender = Wallet.find_by(user_id: @patient.user_id)

      unless @sender
        puts "⚙️ Generating new wallet for patient..."
        keys = SolanaKeygenService.generate
        @sender = Wallet.create!(
          user_id: @patient.user_id,
          public_key: keys[:public_key],
          address: keys[:public_key],
          encrypted_private_key: encrypt(keys[:private_key_base64]),
          balance: 0
        )
      end

      # ✅ Ensure the sender has SOL
      balance = Solana::BalanceService.get_balance(@sender.address)
      puts "💼 Sender balance before transfer: #{balance} SOL"

      if balance < 0.001
        puts "🔁 Airdropping because balance is too low"
        airdrop_sol(@sender.address)
        sleep 5
      end

      # ✅ Reuse or create doctor wallet
      @receiver = Wallet.find_by(user_id: @doctor.user_id)

      unless @receiver
        puts "⚙️ Generating new wallet for doctor..."
        keys = SolanaKeygenService.generate
        @receiver = Wallet.create!(
          user_id: @doctor.user_id,
          public_key: keys[:public_key],
          address: keys[:public_key],
          encrypted_private_key: encrypt(keys[:private_key_base64]),
          balance: 0
        )
      end
    end


    def call
      puts "🔵 Sender: #{@sender.inspect}"
      puts "🟢 Receiver: #{@receiver.inspect}"
      puts "💰 Amount: #{@amount}"

      balance = Solana::BalanceService.get_balance(@sender.address)
      puts "💼 Sender balance before transfer: #{balance} SOL"

      if balance < 0.001
        puts "🔁 Airdropping because balance is too low"
        airdrop_sol(@sender.address)
        sleep 3
      end

      sender_key_base64 = decrypt(@sender.encrypted_private_key)
      decoded = Base64.strict_decode64(sender_key_base64)

      unless decoded.bytesize == 64
        puts "❌ Invalid key size: expected 64 bytes, got #{decoded.bytesize}"
        return false
      end

      sender_key_base64 = Base64.strict_encode64(decoded)
      receiver_address = @receiver.public_key
      amount_in_sol = (@amount / 1000.0).to_s

      command = "node lib/solana/transfer.js #{sender_key_base64} #{receiver_address} #{amount_in_sol}"
      puts "📤 Running: #{command}"
      output = `#{command}`

      if $?.success?
        puts "✅ Transfer successful"
        # puts "🔗 Signature: #{output.strip}"

        signature = output.strip.split("\n").last.strip
        puts "🔗 Signature: #{signature}"

        WalletTransaction.create!(
          wallet: @sender,
          to_address: receiver_address,
          amount: @amount,
          tx_signature: signature,
          status: :success
        )

        @invoice.update!(status: "Paid")
      else
        puts "❌ Transfer failed with output:"
        puts output

        WalletTransaction.create!(
          wallet: @sender,
          to_address: receiver_address,
          amount: @amount,
          tx_signature: nil,
          status: :failed,
          metadata: { error: output.strip }.to_json
        )
      end
    end

    private

    def airdrop_sol(address)
      puts "💸 Airdropping SOL to #{address}"
      output = `node lib/solana/airdrop.js #{address}`
      puts output
    end

    def encrypt(raw_base64)
      raw_base64
    end

    def decrypt(encrypted)
      decoded = Base64.strict_decode64(encrypted)
      puts "🔐 Decrypted key size: #{decoded.bytesize}"
      encrypted
    rescue ArgumentError => e
      puts "❌ Base64 decoding failed: #{e.message}"
      raise
    end
  end
end

