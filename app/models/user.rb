class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_one :doctor
  has_one :patient, dependent: :destroy
  has_many :appointments, foreign_key: :patient_id

  has_one :wallet, dependent: :destroy

  # enum user_role: { doctor: 'doctor', patient: 'patient', admin: 'admin' }
  enum user_role: { doctor: 'doctor', patient: 'patient' }

  accepts_nested_attributes_for :doctor
  accepts_nested_attributes_for :patient

  #validates :user_role, presence: true, inclusion: { in: %w[doctor patient] }
end
