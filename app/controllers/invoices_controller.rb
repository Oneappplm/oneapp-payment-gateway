class InvoicesController < ApplicationController
	before_action :set_doctor
  before_action :set_patient, except: [:index]
  before_action :set_invoice, only: [:show]

	def index
	  if params[:patient_id]
	    @patient = Patient.find(params[:patient_id])
	    @doctor = Doctor.find(params[:doctor_id])
	    @invoices = @patient.invoices.includes(:doctor)
	  else
	    @doctor = Doctor.find(params[:doctor_id])
	    @invoices = @doctor.invoices.includes(:patient)
	  end
	end


	def new
		@invoice = @patient.invoices.new
		# @appointments = @patient.appointments
	end

	def create
		@doctor = Doctor.find(params[:doctor_id])
		@patient = @doctor.patients.find(params[:patient_id])

		@invoice = @patient.invoices.build(invoice_params)
		@invoice.doctor = @doctor
		# @appointments = @patient.appointments

		@invoice.payment_memo = SecureRandom.hex(6)
		@invoice.status = "unpaid"

		if @invoice.save
			log_action(
		    user: current_user,
		    action_type: :invoice_created,
		    details: "Invoice #{@invoice.invoice_number} created for patient #{@patient.full_name} (ID: #{@patient.id})"
		  )
			InvoiceMailer.send_invoice(@invoice).deliver_now
			redirect_to [@doctor, @patient, @invoice], notice: "Invoice created and sent to patient!"
		else
			render :new, status: :unprocessable_entity
		end
	end

	def show
	end

	def edit
		@appointments = @patient.appointments
	end

	def update
		@appointments = @patient.appointments
    if @invoice.update(invoice_params)
      redirect_to doctor_patient_invoice_path(@doctor, @patient, @invoice), notice: "Invoice updated!"
    else
      render :edit, status: :unprocessable_entity
    end
	end

	def confirm_invoice_payment
		invoice = Invoice.find(params[:invoice_id])

    # Enqueue payment verification job if order still pending
    if invoice.status == "unpaid"
      SolanaInvoiceJob.perform_later(invoice.id)
    end

    # Reload invoice to get updated status (optional if job is very fast)
    invoice.reload

    payment_confirmed = (invoice.status == "paid")

    respond_to do |format|
      format.json do
        render json: {
          invoice_id: invoice.id,
          status: invoice.status,
          payment_confirmed: payment_confirmed,
          message: payment_confirmed ? "Payment received! Status: Paid" : "Still waiting for confirmation. Try again later."
        }
      end
    end
	end

	def download_pdf
		invoice = @doctor.invoices.find(params[:id])
	  pdf_content = InvoicePdfGeneratorService.new(invoice).generate

	  send_data pdf_content,
	            filename: "invoice-#{invoice.invoice_number}.pdf",
	            type: "application/pdf",
	            disposition: "attachment"

	end

	def pay_with_medv
	  invoice = Invoice.find(params[:id])
	  Medv::TokenTransferService.new(invoice).call

	  redirect_to [@doctor, @patient, @invoice], notice: "Payment successful"
	end


	private

	def set_doctor
		@doctor = Doctor.find_by(id: params[:doctor_id])
	end

	def set_patient
		Rails.logger.info "DEBUG PARAMS: #{params.inspect}"
		@patient = @doctor.patients.find_by!(id: params[:patient_id])
	end

	def set_invoice
		@invoice = @doctor.invoices.includes(:card_payment).find(params[:id])
	end

	def invoice_params
    params.require(:invoice).permit(:service_name, :amount, :discount, :payment_method, :status, :appointment_id, :service_name, :service_description, :amount, :discount, :tax, :payment_method, :status, :appointment_id, :date_of_service, :due_date, :clinic_name, :medv_token_amount)
  end
end
