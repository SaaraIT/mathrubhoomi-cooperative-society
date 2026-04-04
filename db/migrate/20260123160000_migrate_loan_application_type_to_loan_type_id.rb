class MigrateLoanApplicationTypeToLoanTypeId < ActiveRecord::Migration[8.0]
  def up
    # Add loan_type_id column
    add_reference :loan_applications, :loan_type, foreign_key: true

    # Migrate existing data from loan_application_type to loan_type_id
    execute <<-SQL
      UPDATE loan_applications
      SET loan_type_id = loan_types.id
      FROM loan_types
      WHERE loan_applications.loan_application_type = loan_types.code
    SQL

    # Remove the old column
    remove_column :loan_applications, :loan_application_type
  end

  def down
    # Add back the old column
    add_column :loan_applications, :loan_application_type, :string

    # Migrate data back
    execute <<-SQL
      UPDATE loan_applications
      SET loan_application_type = loan_types.code
      FROM loan_types
      WHERE loan_applications.loan_type_id = loan_types.id
    SQL

    # Remove the foreign key and column
    remove_reference :loan_applications, :loan_type, foreign_key: true
  end
end
