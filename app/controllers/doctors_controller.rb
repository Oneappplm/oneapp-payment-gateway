class DoctorsController < ApplicationController

  # def index
  #   # @doctors = Doctor.all
  #   if current_user&.user_role == "doctor"
  #     @doctor = current_user.doctor
  #   end
  # end

  def new
    @doctor = Doctor.new
  end

  def create
    @doctor = Doctor.new(doctor_params)
    @doctor.user = current_user
    if @doctor.save
      redirect_to @doctor, notice: "Doctor account created successfully."
    else
      render :new
    end
  end

  def show
    @doctor = Doctor.find(params[:id])
  end

  def edit
    @doctor = current_user.doctor
  end

  def update
    @doctor = current_user.doctor
    if @doctor.update(doctor_params)
      redirect_to @doctor, notice: 'Profile updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def doctor_params
    params.require(:doctor).permit(:first_name, :last_name, :email, :specialty, :license_number, :phone, :profile_picture, :clinic_name, :clinic_address, :location, user_attributes: [:id, :email])
  end
end