class AddColumnToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :user_role, :string
  end
end
