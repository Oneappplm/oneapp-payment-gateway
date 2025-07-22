class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: User.all, each_serializer: UserSerializer
  end

  # def create
  #   user = User.new(user_params)
  #   if user.save
  #     render json: { id: user.id, email: user.email, role: user.user_role }, status: :created
  #   else
  #     render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
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
