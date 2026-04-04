class CreateLoanPurposes < ActiveRecord::Migration[7.1]
  def change
    create_table :loan_purposes do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :loan_purposes, :name, unique: true
    add_index :loan_purposes, :active
  end
end
