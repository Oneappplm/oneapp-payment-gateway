class DoctorSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :specialty, :email, :phone, :clinic_name, :clinic_address, :location
  belongs_to :user
end
