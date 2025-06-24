class Invoice < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient
  belongs_to :appointment, optional: true

  has_one :card_payment, dependent: :destroy

  enum status: {
    unpaid: 'Unpaid', 
    paid: 'Paid',
    partially_paid: 'Partially Paid',
    refunded: 'Refunded' 
  }

  enum crypto_type: {
    medv: 0,
    usdt: 1,
    usdc: 2,
    solana: 3,
    bitcoin: 4
  }

  enum blockchain_network: {
    solana_chain: 0,
    ethereum: 1,
    polygon: 2
  }

  enum discount_type: {
    percentage: 0,
    fixed: 1
  }

  # validates :service_name, :payment_method, presence: true
  before_validation :generate_invoice_number, on: :create
  before_save :calculate_total

  def generate_invoice_number
    self.invoice_number ||= "Inv-#{SecureRandom.hex(4).upcase}" 
  end

  # def calculate_total
  #   base = amount.to_f
  #   disc = discount.to_f
  #   tax_amt = tax.to_f

  #   self.total = (base - disc) + tax_amt

  #   # Example conversion: 1 USD = 10 MEDV tokens
  #   conversion_rate = 10
  #   self.medv_token_amount = total.to_f * conversion_rate
  # end

  def calculate_total
    base = amount.to_f
    tax_amt = tax.to_f
    applied_discount = discount.to_f

    if payment_method == "medv_token"
      admin_discount = AdminDiscount.order(created_at: :desc).find_by(discount_type: "percentage") # Simplified
      applied_discount = admin_discount&.apply_discount(base) || applied_discount
    end

    self.total = (base - applied_discount) + tax_amt
    self.medv_token_amount = total.to_f * (conversion_rate || 10)
  end


  def transaction_id
    solana_signature
  end

  def transaction_id=(val)
    self.solana_signature = val
  end

  def crypto_amount
    medv_token_amount
  end

  def crypto_amount=(val)
    self.medv_token_amount = val
  end

end
