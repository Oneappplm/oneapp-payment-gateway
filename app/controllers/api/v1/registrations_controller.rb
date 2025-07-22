class Api::V1::RegistrationsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    user = User.new(user_params)

    if user.save
      if user.user_role == 'doctor' && doctor_params.present?
        user.create_doctor(doctor_params)
      elsif user.user_role == 'patient' && patient_params.present?
        user.create_patient(patient_params.merge(address: "Not provided"))
      end

      render json: {
        message: 'User registered successfully',
        user: user,
        doctor: user.doctor,
        patient: user.patient
      }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :user_role)
  end

  def doctor_params
    params[:doctor]&.permit(:first_name, :last_name, :license_number, :phone, :clinic_name, :clinic_address, :location, :profile_picture)
  end

  def patient_params
    params[:patient]&.permit(:first_name, :last_name, :phone_number, :dob)
  end
end
