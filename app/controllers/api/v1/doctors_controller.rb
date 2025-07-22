class Api::V1::DoctorsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: Doctor.all, each_serializer: DoctorSerializer
  end

  def show
    doctor = Doctor.find(params[:id])
    render json: doctor, serializer: DoctorSerializer
  end

  def create
    doctor = Doctor.new(doctor_params)
    if doctor.save
      render json: doctor, serializer: DoctorSerializer, status: :created
    else
      render json: { errors: doctor.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    doctor = Doctor.find(params[:id])
    if doctor.update(doctor_params)
      render json: doctor, serializer: DoctorSerializer
    else
      render json: { errors: doctor.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def doctor_params
    params.require(:doctor).permit(:first_name, :last_name, :specialty, :license_number, :email, :phone, :clinic_name, :clinic_address, :location, :user_id)
  end
end
