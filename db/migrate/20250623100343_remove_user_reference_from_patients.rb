class RemoveUserReferenceFromPatients < ActiveRecord::Migration[7.1]
  def change
    remove_reference :patients, :user, null: false, foreign_key: true
  end
end
