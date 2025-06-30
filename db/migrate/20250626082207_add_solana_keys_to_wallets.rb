class AddSolanaKeysToWallets < ActiveRecord::Migration[7.1]
  def change
    add_column :wallets, :public_key, :string
  end
end
