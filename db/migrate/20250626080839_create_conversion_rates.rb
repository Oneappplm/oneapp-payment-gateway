class CreateConversionRates < ActiveRecord::Migration[7.1]
  def change
    create_table :conversion_rates do |t|
      t.float :usd_to_medv
      t.date :effective_on

      t.timestamps
    end
  end
end
