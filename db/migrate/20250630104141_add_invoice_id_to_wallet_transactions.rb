class AddInvoiceIdToWalletTransactions < ActiveRecord::Migration[7.1]
  def change
    add_reference :wallet_transactions, :invoice, foreign_key: true
  end
end
