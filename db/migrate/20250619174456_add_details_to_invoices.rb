class AddDetailsToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :invoice_number, :string
    add_column :invoices, :clinic_name, :string
    add_column :invoices, :date_of_service, :date
    add_column :invoices, :service_description, :text
    add_column :invoices, :tax, :decimal, precision: 10, scale: 2
    add_column :invoices, :medv_token_amount, :decimal, precision: 10, scale: 2
    add_column :invoices, :due_date, :date
    add_column :invoices, :payment_confirmation_status, :boolean, default: false
    add_column :invoices, :crypto_type, :integer
    add_column :invoices, :blockchain_network, :integer
    add_column :invoices, :conversion_rate, :decimal
    add_column :invoices, :sender_wallet_address, :string
    add_column :invoices, :receiver_wallet_address, :string
    add_column :invoices, :payment_timestamp, :datetime
    add_column :invoices, :transaction_fee, :decimal
    add_column :invoices, :discount_type, :integer
    add_column :invoices, :discount_start_date, :date
    add_column :invoices, :discount_end_date, :date
  end
end
