# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  def create
    super do |user|
      if user.persisted?
        case user.user_role
        when "doctor"
          user.build_doctor(
            first_name: params[:doctor][:first_name],
            last_name: params[:doctor][:last_name],
            specialty: params[:doctor][:specialty],
            license_number: params[:doctor][:license_number],
            email: params[:doctor][:email],
            phone: params[:doctor][:phone],
            clinic_name: params[:doctor][:clinic_name],
            clinic_address: params[:doctor][:clinic_address],
            location: params[:doctor][:location],
            email_verified: false,
            phone_verified: false,
            license_verified: false,
            profile_picture: params[:doctor][:profile_picture]
          )
          user.doctor.save
        when "patient"
          user.build_patient(
            first_name: params[:patient][:first_name],
            last_name: params[:patient][:last_name],
            phone_number: params[:patient][:phone_number],
            dob: params[:patient][:dob],
            address: "Not provided"
          )
          user.patient.save
        end
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :user_role,
      :first_name, :last_name, :specialty, :license_number, :phone,
      :clinic_name, :clinic_address, :location
    )
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_role])
  end
end
