class HomeController < ApplicationController
  def index
    if user_signed_in?
      case current_user.user_role
      when "doctor"
        @display_name = current_user.doctor&.full_name
      when "patient"
        @display_name = "Patient"  
      end
    end
  end
end
