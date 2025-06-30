class AddDetailsToWalletTransactions < ActiveRecord::Migration[7.1]
  def change
    add_column :wallet_transactions, :to_address, :string
    add_column :wallet_transactions, :tx_signature, :string
  end
end
