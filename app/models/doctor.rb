class Doctor < ApplicationRecord
	belongs_to :user
  has_many :invoices
	has_many :appointments
	has_many :patients, dependent: :destroy

  has_one_attached :profile_picture

  # validates :email, presence: true, uniqueness: true

  def full_name
  	"#{first_name} #{last_name}"
  end
end
