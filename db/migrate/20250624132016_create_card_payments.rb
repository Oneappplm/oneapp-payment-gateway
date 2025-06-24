class CreateCardPayments < ActiveRecord::Migration[7.1]
  def change
    create_table :card_payments do |t|
      t.references :invoice, null: false, foreign_key: true
      t.string :card_type
      t.string :masked_number
      t.string :expiry_date
      t.string :card_holder_name
      t.string :stripe_transaction_id
      t.float :stripe_fee
      t.string :tokenized_data
      t.boolean :secure_3d
      t.string :status
      t.string :payment_gateway
      t.datetime :paid_at

      t.timestamps
    end
  end
end
