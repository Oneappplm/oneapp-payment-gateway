class Api::V1::InvoicesController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_doctor
  before_action :set_patient, except: [:index]
  before_action :set_invoice, only: [:show, :update, :destroy, :confirm_invoice_payment, :download_pdf, :pay_with_medv]

  def index
    @doctor = Doctor.find(params[:doctor_id])

    if params[:patient_id].present?
      @patient = Patient.find(params[:patient_id])
      invoices = @patient.invoices.where(doctor: @doctor).includes(:doctor)
    else
      invoices = @doctor.invoices.includes(:patient)
    end

    render json: invoices, each_serializer: InvoiceSerializer
  end

  def new
    @doctor = Doctor.find(params[:doctor_id])
    @patient = Patient.find(params[:patient_id])
    @invoice = @patient.invoices.build(doctor: @doctor)
  end


  def show
    render json: @invoice, serializer: InvoiceSerializer
  end

  def create
    invoice = @patient.invoices.build(invoice_params)
    invoice.doctor = @doctor
    invoice.payment_memo = SecureRandom.hex(6)
    invoice.status = "unpaid"

    if invoice.save
      log_action(
        user: current_user,
        action_type: :invoice_created,
        details: "Invoice #{invoice.invoice_number} created for patient #{@patient.full_name} (ID: #{@patient.id})"
      )
      InvoiceMailer.send_invoice(invoice).deliver_later

      render json: invoice, serializer: InvoiceSerializer, status: :created
    else
      render json: { errors: invoice.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @invoice.update(invoice_params)
      render json: @invoice, serializer: InvoiceSerializer
    else
      render json: { errors: @invoice.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @invoice.destroy
      render json: { message: "Invoice deleted successfully." }, status: :no_content
    else
      render json: { errors: @invoice.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def confirm_invoice_payment
    if @invoice.status == "unpaid"
      SolanaInvoiceJob.perform_later(@invoice.id)
    end

    @invoice.reload
    payment_confirmed = (@invoice.status == "paid")

    render json: {
      invoice_id: @invoice.id,
      status: @invoice.status,
      payment_confirmed: payment_confirmed,
      message: payment_confirmed ? "Payment received! Status: Paid" : "Still waiting for confirmation. Try again later."
    }
  end

  def download_pdf
    pdf_content = InvoicePdfGeneratorService.new(@invoice).generate

    send_data pdf_content,
              filename: "invoice-#{@invoice.invoice_number}.pdf",
              type: "application/pdf",
              disposition: "attachment"
  end

  def pay_with_medv
    Medv::TokenTransferService.new(@invoice).call

    render json: {
      invoice_id: @invoice.id,
      message: "Payment successful",
      status: "paid"
    }
  end

  private

  def set_doctor
    @doctor = Doctor.find_by(id: params[:doctor_id])
  end

  def set_patient
    @patient = @doctor.patients.find_by!(id: params[:patient_id])
  end

  def set_invoice
    @invoice = @doctor.invoices.includes(:card_payment).find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(
      :service_name, :amount, :discount, :payment_method, :status,
      :appointment_id, :service_description, :date_of_service, :due_date,
      :clinic_name, :medv_token_amount
    )
  end
end
