class ConvertLoanEditRequestsToEditRequests < ActiveRecord::Migration[8.0]
  def up
    # Rename the table
    rename_table :loan_edit_requests, :edit_requests

    # Rename columns for polymorphic association
    rename_column :edit_requests, :loan_type, :resource_type
    rename_column :edit_requests, :loan_id, :resource_id
    rename_column :edit_requests, :edit_reason, :reason

    # Update the index
    #remove_index :edit_requests, name: "index_loan_edit_requests_on_loan_type_and_loan_id"
    #add_index :edit_requests, [:resource_type, :resource_id]
  end

  def down
    # Rename columns back
    rename_column :edit_requests, :resource_type, :loan_type
    rename_column :edit_requests, :resource_id, :loan_id
    rename_column :edit_requests, :reason, :edit_reason

    # Update the index
    remove_index :edit_requests, [:resource_type, :resource_id]
    add_index :edit_requests, [:loan_type, :loan_id], name: "index_loan_edit_requests_on_loan_type_and_loan_id"

    # Rename the table back
    rename_table :edit_requests, :loan_edit_requests
  end
end
