module AuditLogger
  def log_action(user:, action_type:, details:)
    AuditLog.create!(
      action: user.email,
      action_type: action_type,
      details: details
    )
    
  rescue => e
    Rails.logger.error "Failed to log audit event: #{e.message}"
  end
end
