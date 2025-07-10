# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


require 'securerandom'

puts "Seeding users, doctors, patients, and invoices..."

# === USERS ===
doctor_user1 = User.find_or_create_by!(email: 'dr.smith1@example.com') do |user|
  user.password = 'password123'
  user.user_role = 'doctor'
end

doctor_user2 = User.find_or_create_by!(email: 'dr.jones1@example.com') do |user|
  user.password = 'password123'
  user.user_role = 'doctor'
end

# === DOCTORS ===
doctor1 = Doctor.find_or_create_by!(user: doctor_user1) do |doctor|
  doctor.first_name = "John"
  doctor.last_name = "Smith"
  doctor.specialty = "Cardiology"
  doctor.license_number = "DOC123456"
  doctor.email = doctor_user1.email
  doctor.phone = "1234567890"
  doctor.clinic_name = "Heart Care Clinic"
  doctor.clinic_address = "123 Main St, Cityville"
  doctor.location = "Cityville"
  doctor.email_verified = true
  doctor.phone_verified = true
  doctor.license_verified = true
end

doctor2 = Doctor.find_or_create_by!(user: doctor_user2) do |doctor|
  doctor.first_name = "Emily"
  doctor.last_name = "Jones"
  doctor.specialty = "Pediatrics"
  doctor.license_number = "DOC654321"
  doctor.email = doctor_user2.email
  doctor.phone = "9876543210"
  doctor.clinic_name = "Children's Health Center"
  doctor.clinic_address = "456 Elm St, Townsville"
  doctor.location = "Townsville"
  doctor.email_verified = true
  doctor.phone_verified = true
  doctor.license_verified = true
end

# === PATIENTS ===
def create_patient_for(doctor, email, first_name, last_name)
  user = User.find_or_create_by!(email: email) do |u|
    u.password = 'password123'
    u.user_role = 'patient'
  end

  Patient.find_or_create_by!(user: user, doctor: doctor) do |patient|
    patient.first_name = first_name
    patient.last_name = last_name
    patient.dob = Date.new(1990, 1, 1)
    patient.gender = "Male"
    patient.status = "active"
    patient.email_address = email
    patient.phone_number = "555-1234"
    patient.medical_history = "No major issues"
    patient.current_medications = "None"
    patient.allergies = "Peanuts"
    patient.insurance_information = "Provider A"
    patient.emergency_contact = "Emergency Person - 555-4321"
    patient.address = "123 Patient St, Somewhere"
    patient.last_visit_date = Date.today - 30
    patient.next_appointment = Date.today + 30
    patient.active = true
  end
end

patient1 = create_patient_for(doctor1, "patient1@example.com", "Alice", "Brown")
patient2 = create_patient_for(doctor1, "patient2@example.com", "Bob", "Green")
patient3 = create_patient_for(doctor2, "patient3@example.com", "Clara", "White")
patient4 = create_patient_for(doctor2, "patient4@example.com", "David", "Black")

# === INVOICES ===
# def create_invoice_for(doctor, patient)
#   Invoice.create!(
#     doctor: doctor,
#     patient: patient,
#     service_name: "Consultation",
#     amount: 100.00,
#     discount: 10.00,
#     tax: 5.00,
#     total: 95.00,
#     service_description: "General health consultation",
#     payment_method: "medv",
#     payment_memo: SecureRandom.hex(6),
#     status: "unpaid",
#     invoice_number: "INV#{SecureRandom.hex(3).upcase}",
#     clinic_name: doctor.clinic_name,
#     date_of_service: Date.today - 5,
#     due_date: Date.today + 10,
#     medv_token_amount: "50",
#     payment_confirmation_status: false,
#     blockchain_network: 1,
#     crypto_type: 1,
#     conversion_rate: 2.0,
#     receiver_wallet_address: "receiver_wallet_#{SecureRandom.hex(4)}",
#     sender_wallet_address: "sender_wallet_#{SecureRandom.hex(4)}",
#     transaction_fee: 0.5
#   )
# end

# [patient1, patient2, patient3, patient4].each do |patient|
#   doctor = patient.doctor
#   2.times { create_invoice_for(doctor, patient) }
# end

puts "✅ Seeding completed!"
