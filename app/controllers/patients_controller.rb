class PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_doctor

  def index
    @patients = @doctor.patients
  end

  def new
    @patient = @doctor.patients.new
  end

  def create
    ActiveRecord::Base.transaction do
      # 1. Create the user
      generated_password = Devise.friendly_token.first(8)
      user = User.create!(
        email: params[:patient][:email_address],
        password: generated_password,
        password_confirmation: generated_password,
        user_role: "patient"
      )

      # 2. Create the patient linked to the doctor and user
      @patient = @doctor.patients.new(patient_params)
      @patient.user = user

      if @patient.save
        # Optional: Send welcome email or password instructions
        # UserMailer.with(user: user, password: generated_password).welcome_email.deliver_later
        redirect_to doctor_patients_path(@doctor), notice: "Patient and user created successfully."
      else
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = "Failed to create patient: #{e.record.errors.full_messages.to_sentence}"
    @patient ||= @doctor.patients.new(patient_params)
    render :new, status: :unprocessable_entity
  end


  def show
    @patient = @doctor.patients.find(params[:id])
  end

  def edit
    @patient = @doctor.patients.find(params[:id])
  end

  def update
    @patient = @doctor.patients.find(params[:id])
    old_attributes = @patient.attributes.slice(*patient_params.keys)
    if @patient.update(patient_params)
      changes = []

      patient_params.each do |key, new_value|
        old_value = old_attributes[key]

        next if old_value.to_s == new_value.to_s

        changes << "#{key.humanize} changed from \"#{old_value}\" to \"#{new_value}\""
      end

      log_action(
        user: current_user,
        action_type: :patient_updated,
        details: "Patient #{@patient.full_name} updated by Dr. #{current_user.doctor.full_name} updated: #{changes.join(', ')}"
      )
      redirect_to doctor_patient_path(@doctor, @patient), notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private 

  def set_doctor
    @doctor = current_user.doctor
  end

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :dob, :medical_history, :emergency_contact, :status, :gender, :email_address, :phone_number, :insurance_information, :address, :next_appointment, :last_visit_date, :active, :current_medications, :allergies)
  end
end