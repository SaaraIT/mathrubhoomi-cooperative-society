class AddLoanPurposeIdToLoanApplications < ActiveRecord::Migration[8.0]
  def up
    # Add loan_purpose_id column
    add_reference :loan_applications, :loan_purpose, foreign_key: true, null: true

    # First, ensure all existing loan_purpose values have corresponding LoanPurpose records
    execute <<-SQL
      INSERT INTO loan_purposes (name, description, active, created_at, updated_at)
      SELECT DISTINCT loan_purpose, 'Migrated from loan_applications', true, NOW(), NOW()
      FROM loan_applications
      WHERE loan_purpose IS NOT NULL
        AND loan_purpose != ''
        AND NOT EXISTS (
          SELECT 1 FROM loan_purposes WHERE LOWER(name) = LOWER(loan_applications.loan_purpose)
        )
    SQL

    # Migrate existing loan_purpose values to loan_purpose_id
    execute <<-SQL
      UPDATE loan_applications
      SET loan_purpose_id = (
        SELECT id FROM loan_purposes
        WHERE LOWER(name) = LOWER(loan_applications.loan_purpose)
        LIMIT 1
      )
      WHERE loan_purpose IS NOT NULL AND loan_purpose != ''
    SQL
  end

  def down
    remove_reference :loan_applications, :loan_purpose
  end
end
