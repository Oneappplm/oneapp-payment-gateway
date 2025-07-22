class Api::V1::InvoicesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: Invoice.all, each_serializer: InvoiceSerializer
  end

  def show
    invoice = Invoice.find(params[:id])
    render json: invoice, serializer: InvoiceSerializer
  end

  def create
    invoice = Invoice.new(invoice_params)
    if invoice.save
      render json: invoice, serializer: InvoiceSerializer, status: :created
    else
      render json: { errors: invoice.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    invoice = Invoice.find(params[:id])
    if invoice.update(invoice_params)
      render json: invoice, serializer: InvoiceSerializer
    else
      render json: { errors: invoice.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:doctor_id, :patient_id, :appointment_id, :service_name, :amount,
                                    :discount, :qr_code_url, :payment_memo, :payment_method,
                                    :solana_signature, :status, :invoice_number, :clinic_name,
                                    :date_of_service, :service_description, :tax, :medv_token_amount,
                                    :due_date, :payment_confirmation_status, :crypto_type,
                                    :blockchain_network, :conversion_rate, :sender_wallet_address,
                                    :receiver_wallet_address, :payment_timestamp, :transaction_fee,
                                    :discount_type, :discount_start_date, :discount_end_date)
  end
end
