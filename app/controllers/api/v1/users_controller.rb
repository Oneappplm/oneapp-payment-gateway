class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: User.all, each_serializer: UserSerializer
  end

  def create
    user = User.new(user_params)

    if user.save
      case user.user_role
      when "doctor"
        doctor = user.build_doctor(
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

        unless doctor.save
          return render json: { errors: doctor.errors.full_messages }, status: :unprocessable_entity
        end

      when "patient"
        patient = user.build_patient(
          first_name: params[:patient][:first_name],
          last_name: params[:patient][:last_name],
          phone_number: params[:patient][:phone_number],
          dob: params[:patient][:dob],
          address: "Not provided"
        )

        unless patient.save
          return render json: { errors: patient.errors.full_messages }, status: :unprocessable_entity
        end
      end

      render json: user, serializer: UserSerializer
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    user = User.find(params[:id])
    render json: user, serializer: UserSerializer
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :user_role,
      doctor_attributes: [
        :first_name,
        :last_name,
        :specialty,
        :email,
        :phone,
        :clinic_name,
        :clinic_address,
        :location
      ],
      patient_attributes: [
        :first_name,
        :last_name,
        :dob,
        :gender,
        :phone_number,
        :email_address
      ]
    )
  end
end
