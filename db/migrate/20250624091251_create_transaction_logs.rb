class CreateTransactionLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :transaction_logs do |t|
      t.references :invoice, null: false, foreign_key: true
      t.string :solana_tx
      t.string :memo
      t.string :status
      t.decimal :amount
      t.datetime :confirmed_at

      t.timestamps
    end
  end
end
