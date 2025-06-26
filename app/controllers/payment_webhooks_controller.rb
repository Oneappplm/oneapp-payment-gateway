# app/controllers/payment_webhooks_controller.rb
class PaymentWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, Rails.application.credentials[:stripe][:webhook_secret]
      )
    rescue JSON::ParserError, Stripe::SignatureVerificationError => e
      render status: 400, json: { error: e.message } and return
    end

    if event['type'] == 'payment_intent.succeeded'
      intent = event['data']['object']
      user_id = intent['metadata']['user_id']
      user = User.find(user_id)
      amount_usd = intent['amount'].to_f / 100
      WalletsController.new.top_up_from_webhook(user, amount_usd)
    end

    render json: { success: true }
  end
end
