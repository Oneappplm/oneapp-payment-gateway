class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :service_name, :amount, :discount, :total, :status, :invoice_number,
             :qr_code_url, :payment_method, :solana_signature, :medv_token_amount,
             :payment_timestamp, :sender_wallet_address, :receiver_wallet_address

  belongs_to :doctor
  belongs_to :patient
end
