class PaymentsController < ApplicationController
  include AuditLogger

  def stripe
    invoice = Invoice.find(params[:invoice_id])
    session = Stripe::Checkout::Session.create(
      mode: 'payment',
      line_items: [{
        price_data: {
          currency: 'usd',
          product_data: { name: "Invoice ##{invoice.invoice_number}" },
          unit_amount: (invoice.total * 100).to_i
        },
        quantity: 1
      }],
      success_url: payments_stripe_success_url + "?session_id={CHECKOUT_SESSION_ID}&invoice_id=#{invoice.id}",
      cancel_url: doctor_patient_invoice_url(invoice.doctor_id, invoice.patient_id, invoice)
    )
    redirect_to session.url, allow_other_host: true
  end

  def stripe_success
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    if session.payment_status == 'paid'
      invoice = Invoice.find(params[:invoice_id])

      payment_intent = Stripe::PaymentIntent.retrieve(session.payment_intent)
      charge = payment_intent.latest_charge && Stripe::Charge.retrieve(payment_intent.latest_charge)

      invoice.update(
        status: 'paid', 
        payment_method: 'card'
      )

      # Save card payment details
      invoice.create_card_payment!(
        card_type: charge.payment_method_details.card.brand.titleize,
        masked_number: "**** **** **** #{charge.payment_method_details.card.last4}",
        expiry_date: "#{charge.payment_method_details.card.exp_month}/#{charge.payment_method_details.card.exp_year.to_s[-2..]}",
        card_holder_name: charge.billing_details.name,
        stripe_transaction_id: charge.id,
        stripe_fee: (charge.balance_transaction ? Stripe::BalanceTransaction.retrieve(charge.balance_transaction).fee / 100.0 : 0),
        tokenized_data: charge.payment_method,
        secure_3d: charge.payment_method_details.card.three_d_secure == 'authenticated',
        payment_gateway: "Stripe",
        paid_at: Time.at(charge.created),
        status: 'completed'
      )

      # Log audit
      log_action(
        user: current_user,
        action_type: "payment_processed",
        details: "Invoice #{invoice.invoice_number} marked as paid via Stripe (#{charge.id})"
      )
      redirect_to doctor_patient_invoice_url(invoice.doctor_id, invoice.patient_id, invoice), notice: "Payment successful!"
    else
      redirect_to invoice, alert: "Payment not completed."
    end
  end

  def paypal
    invoice = Invoice.find(params[:invoice_id])
    client = PayPal::PayPalHttpClient.new(PAYPAL_ENV)
    request = PayPalCheckoutSdk::Orders::OrdersCreateRequest::new
    request.request_body({
      intent: 'CAPTURE',
      purchase_units: [{
        amount: { currency_code: 'USD', value: invoice.total.to_s }
      }],
      application_context: {
        return_url: payments_paypal_success_url(invoice_id: invoice.id),
        cancel_url: payments_paypal_cancel_url(invoice_id: invoice.id)
      }
    })
    result = client.execute(request)
    redirect_to result.result.links.find { |l| l.rel == 'approve' }.href
  end

  def paypal_success
    invoice = Invoice.find(params[:invoice_id])
    client = PayPal::PayPalHttpClient.new(PAYPAL_ENV)
    request = PayPalCheckoutSdk::Orders::OrdersCaptureRequest::new(params[:token])
    client.execute(request)
    invoice.update(status: 'paid')
    redirect_to invoice, notice: "PayPal payment successful!"
  end

  def paypal_cancel
    redirect_to invoice_path(params[:invoice_id]), alert: "Payment cancelled."
  end
end