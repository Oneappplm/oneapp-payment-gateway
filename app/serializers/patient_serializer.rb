class PatientSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :dob, :gender, :email_address, :phone_number,
             :medical_history, :current_medications, :allergies, :status, :address,
             :next_appointment, :last_visit_date, :active
  belongs_to :doctor
  belongs_to :user
end
