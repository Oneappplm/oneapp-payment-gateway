class CreateAuditLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :audit_logs do |t|
      t.integer :action_type
      t.string :action
      t.text :details

      t.timestamps
    end
  end
end
