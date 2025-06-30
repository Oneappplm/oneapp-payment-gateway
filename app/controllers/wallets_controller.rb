# app/controllers/wallets_controller.rb
class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wallet, only: [:show, :wallet_transactions, :scan_qr]

  def show
    @last_transaction = @wallet.wallet_transactions
                              .where(tx_type: 'top_up')
                              .order(created_at: :desc)
                              .first
  end

  def wallet_transactions
  end

  def scan_qr
  end

  def qr_request
    data = {
      wallet_address: current_user.wallet.address,
      amount: 10.0 # or dynamic amount
    }

    @qr = RQRCode::QRCode.new(data.to_json)
  end

  def top_up
    usd = params[:amount].to_f
    rate = ConversionRateService.current_medv_rate
    medv_amount = (usd * rate).round(2)

    SolanaWalletService.credit_tokens(current_user.wallet.address, medv_amount)

    current_user.wallet.increment!(:balance, medv_amount)

    WalletTransaction.create!(
      wallet: current_user.wallet,
      tx_type: 'top_up',
      amount: medv_amount,
      status: 'completed',
      reference_id: SecureRandom.uuid,
      metadata: { usd: usd, rate: rate }
    )

    render json: { success: true, tokens_added: medv_amount }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def transactions
    @wallet = Wallet.find(params[:id])
    @transactions = @wallet.wallet_transactions.recent
  end

  private

  def set_wallet
    @wallet = current_user.wallet
  end
end
