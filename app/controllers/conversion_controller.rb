# app/controllers/conversion_controller.rb
class ConversionController < ApplicationController
  def medv_to_usd
    rate = ConversionRateService.current_medv_rate
    render json: { medv_to_usd: rate }
  end
end
