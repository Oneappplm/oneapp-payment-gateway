# app/services/conversion_rate_service.rb
class ConversionRateService
  def self.current_medv_rate
    ConversionRate.where(effective_on: Date.today).order(created_at: :desc).limit(1).pluck(:usd_to_medv).first || 4.0
  end

  def self.recent_rates(limit = 5)
    ConversionRate.order(effective_on: :desc).limit(limit)
  end
end
