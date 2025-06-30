class WalletTransaction < ApplicationRecord
  belongs_to :wallet

  enum status: { pending: "pending", success: "success", failed: "failed" }

  scope :recent, -> { order(created_at: :desc) }

end
