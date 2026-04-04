class CreateLoanEditRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :loan_edit_requests do |t|
      t.string :loan_type, null: false
      t.bigint :loan_id, null: false
      t.references :user, null: false, foreign_key: true
      t.references :cooperative_branch, null: false, foreign_key: true
      t.references :approved_by, foreign_key: { to_table: :users }
      t.datetime :approved_on
      t.boolean :approved
      t.text :edit_reason, null: false
      t.text :rejection_reason

      t.timestamps
    end

    add_index :loan_edit_requests, [:loan_type, :loan_id]
    add_index :loan_edit_requests, :approved
  end
end
