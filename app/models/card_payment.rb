class CardPayment < ApplicationRecord
  belongs_to :invoice

  enum status: { pending: "pending", completed: "completed", failed: "failed" }
end

