class CreateAdminDiscounts < ActiveRecord::Migration[7.1]
  def change
    create_table :admin_discounts do |t|
      t.integer :discount_type
      t.decimal :percentage
      t.decimal :fixed_amount
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
