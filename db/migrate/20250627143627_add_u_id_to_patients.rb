class AddUIdToPatients < ActiveRecord::Migration[7.1]
  def change
    add_column :patients, :user_id, :bigint
    add_index :patients, :user_id
  end
end
