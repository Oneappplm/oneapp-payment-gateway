class CreateWallets < ActiveRecord::Migration[7.1]
  def change
    create_table :wallets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :address, null: false
      t.decimal :balance, precision: 18, scale: 8, default: 0
      t.text :encrypted_private_key

      t.timestamps
    end
    add_index :wallets, :address, unique: true
  end
end
