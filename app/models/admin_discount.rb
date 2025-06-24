class AdminDiscount < ApplicationRecord
  enum discount_type: { percentage: 0, fixed: 1 }

  def active?
    Date.current.between?(start_date, end_date)
  end

  def apply_discount(amount)
    return amount unless active?

    if percentage?
      amount - (amount * (percentage.to_f / 100))
    else
      [amount - fixed_amount.to_f, 0].max
    end
  end
end
