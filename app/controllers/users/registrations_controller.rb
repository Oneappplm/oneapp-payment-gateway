# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
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

  # def create
  #   super do |user|
  #     if params[:user][:user_role] == "doctor"
  #       user.build_doctor(
  #         first_name: params[:doctor][:first_name],
  #         last_name: params[:doctor][:last_name],
  #         specialty: params[:doctor][:specialty],
  #         license_number: params[:doctor][:license_number],
  #         email: params[:doctor][:email],
  #         phone: params[:doctor][:phone],
  #         clinic_name: params[:doctor][:clinic_name],
  #         clinic_address: params[:doctor][:clinic_address],
  #         location: params[:doctor][:location],
  #         email_verified: false,
  #         phone_verified: false,
  #         license_verified: false,
  #         profile_picture: params[:doctor][:profile_picture]
  #       ).save
  #     end

  #     if params[:user][:user_role] == "doctor"
  #       user.build_doctor(
  #         first_name: params[:doctor][:first_name],
  #         last_name: params[:doctor][:last_name],
  #         specialty: params[:doctor][:specialty],
  #         license_number: params[:doctor][:license_number],
  #         email: params[:doctor][:email],
  #         phone: params[:doctor][:phone],
  #         clinic_name: params[:doctor][:clinic_name],
  #         clinic_address: params[:doctor][:clinic_address],
  #         location: params[:doctor][:location],
  #         email_verified: false,
  #         phone_verified: false,
  #         license_verified: false,
  #         profile_picture: params[:doctor][:profile_picture]
  #       ).save
  #     end
  #   end
  # end

  private

  def sign_up_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :user_role,
      :first_name, :last_name, :specialty, :license_number, :phone,
      :clinic_name, :clinic_address, :location
    )
  end

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super do |user|
  #     if user.persisted?
  #       case user.user_role
  #       when "doctor"
  #         user.build_doctor(
  #           first_name: params[:doctor][:first_name],
  #           last_name: params[:doctor][:last_name],
  #           specialty: params[:doctor][:specialty],
  #           license_number: params[:doctor][:license_number],
  #           email: params[:doctor][:email],
  #           phone: params[:doctor][:phone],
  #           clinic_name: params[:doctor][:clinic_name],
  #           clinic_address: params[:doctor][:clinic_address],
  #           location: params[:doctor][:location],
  #           email_verified: false,
  #           phone_verified: false,
  #           license_verified: false,
  #           profile_picture: params[:doctor][:profile_picture]
  #         )
  #         user.doctor.save
  #       when "patient"
  #         user.build_patient(
  #           first_name: params[:patient][:first_name],
  #           last_name: params[:patient][:last_name],
  #           phone: params[:patient][:phone],
  #           dob: params[:patient][:dob],
  #           address: params[:patient][:address]
  #         )
  #         user.patient.save
  #       end
  #     end
  #   end
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_role])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
