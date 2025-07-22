class Api::V1::PatientsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_doctor

  def index
    patients = @doctor.patients
    render json: patients, status: :ok
  end

  def show
    patient = @doctor.patients.find(params[:id])
    render json: patient, serializer: PatientSerializer
  end

  def create
    @patient = @doctor.patients.new(patient_params.except(:email_address))
    @patient.user = current_user

    if @patient.save
      render json: @patient, serializer: PatientSerializer, status: :created
    else
      render json: { errors: @patient.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # def create
  #   patient = Patient.new(patient_params)
  #   if patient.save
  #     render json: patient, serializer: PatientSerializer, status: :created
  #   else
  #     render json: { errors: patient.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  def update
    patient = @doctor.patients.find(params[:id])
    if patient.update(patient_params)
      render json: patient, serializer: PatientSerializer
    else
      render json: { errors: patient.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    patient = Patient.find(params[:id])
    if patient.destroy
      render json: patient, serializer: PatientSerializer
    else
      render json: { errors: patient.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_doctor
    @doctor = current_user.doctor
  end

  def patient_params
    params.require(:patient).permit(
      :first_name, :last_name, :dob, :medical_history, :emergency_contact,
      :status, :gender, :email_address, :phone_number, :insurance_information,
      :address, :next_appointment, :last_visit_date, :active, :current_medications, :allergies
    )
  end
end


