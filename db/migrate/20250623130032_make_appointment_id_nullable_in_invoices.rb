class MakeAppointmentIdNullableInInvoices < ActiveRecord::Migration[7.1]
  def change
    change_column_null :invoices, :appointment_id, true
  end
end
