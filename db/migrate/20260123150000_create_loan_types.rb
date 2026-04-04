class CreateLoanTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :loan_types do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.text :description
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :loan_types, :code, unique: true
    add_index :loan_types, :active
  end
end
