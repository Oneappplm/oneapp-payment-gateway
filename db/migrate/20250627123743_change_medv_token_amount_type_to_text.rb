class ChangeMedvTokenAmountTypeToText < ActiveRecord::Migration[7.1]
  def change
    change_column :invoices, :medv_token_amount, :text
  end
end
