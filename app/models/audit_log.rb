class AuditLog < ApplicationRecord
  enum action_type: {
    invoice_created: 0,
    payment_processed: 1,
    patient_updated: 2,
    user_logged_in: 3,
    settings_updated: 4
  }
end
