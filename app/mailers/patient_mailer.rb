class PatientMailer < ApplicationMailer
  def send_credentials(patient, password)
    @patient = patient
    @password = password
    mail(to: @patient.email, subject: "Your login credentials")
  end
end

