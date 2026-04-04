class CreateInterestRates < ActiveRecord::Migration[8.0]
  def change
    create_table :interest_rates do |t|
      t.string :loan_type, null: false
      t.string :loan_type_name, null: false
      t.decimal :rate, precision: 5, scale: 2, null: false
      t.integer :min_amount
      t.integer :max_amount
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :interest_rates, :loan_type
    add_index :interest_rates, :active
  end
end
