class CreateWalletTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :wallet_transactions do |t|
      t.references :wallet, null: false, foreign_key: true
      t.string :tx_type
      t.decimal :amount, precision: 18, scale: 8
      t.string :status, default: 'pending'
      t.string :reference_id
      t.jsonb :metadata

      t.timestamps
    end
  end
end
