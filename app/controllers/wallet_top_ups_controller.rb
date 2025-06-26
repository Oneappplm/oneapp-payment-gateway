# app/controllers/wallet_top_ups_controller.rb
class WalletTopUpsController < ApplicationController
  before_action :authenticate_user!

  def stripe
    amount = params[:amount].to_f
    raise "Invalid amount" if amount <= 0

    session = Stripe::Checkout::Session.create(
      mode: 'payment',
      line_items: [{
        price_data: {
          currency: 'usd',
          product_data: { name: "MEDV Wallet Top-Up" },
          unit_amount: (amount * 100).to_i
        },
        quantity: 1
      }],
      success_url: wallet_top_up_stripe_success_url(host: request.base_url) + "?session_id={CHECKOUT_SESSION_ID}&amount=#{amount}",
      cancel_url: wallet_url(current_user.wallet, host: request.base_url)
    )

    redirect_to session.url, allow_other_host: true
  end

  def stripe_success
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    if session.payment_status == 'paid'
      amount = params[:amount].to_f
      rate = ConversionRateService.current_medv_rate
      tokens = (amount * rate).round(2)

      # Credit the tokens (real or simulated)
      wallet = current_user.wallet
      SolanaWalletService.credit_tokens(wallet.address, tokens)
      wallet.increment!(:balance, tokens)

      WalletTransaction.create!(
        wallet: wallet,
        tx_type: 'top_up',
        amount: tokens,
        status: 'completed',
        reference_id: SecureRandom.uuid,
        metadata: { usd: amount, rate: rate, stripe_session_id: session.id }
      )

      redirect_to wallet_path(wallet), notice: "Wallet topped up with #{tokens} MEDV tokens!"
    else
      redirect_to wallet_path(current_user.wallet), alert: "Stripe payment not completed."
    end
  end
end
