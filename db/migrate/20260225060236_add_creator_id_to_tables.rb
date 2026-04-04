class AddCreatorIdToTables < ActiveRecord::Migration[8.0]
  def change
    add_reference :branch_manager_reports, :creator, foreign_key: { to_table: :users }
    add_reference :additional_shares_applications, :creator, foreign_key: { to_table: :users }
    add_reference :branch_reports, :creator, foreign_key: { to_table: :users }
    add_reference :demand_promissory_notes, :creator, foreign_key: { to_table: :users }
    add_reference :guarantor_undertakings, :creator, foreign_key: { to_table: :users }
    add_reference :head_office_reports, :creator, foreign_key: { to_table: :users }
    add_reference :hypothecation_deeds, :creator, foreign_key: { to_table: :users }
    add_reference :jewel_appraisers_reports, :creator, foreign_key: { to_table: :users }
    add_reference :jewel_loan_promissory_notes, :creator, foreign_key: { to_table: :users }
    add_reference :jewel_loans, :creator, foreign_key: { to_table: :users }
    add_reference :loan_applications, :creator, foreign_key: { to_table: :users }
    add_reference :members, :creator, foreign_key: { to_table: :users }
    add_reference :pro_notes, :creator, foreign_key: { to_table: :users }
    add_reference :shg_demand_promissory_notes, :creator, foreign_key: { to_table: :users }
    add_reference :shg_loan_applications, :creator, foreign_key: { to_table: :users }
    add_reference :shg_loan_pro_notes, :creator, foreign_key: { to_table: :users }
    add_reference :shg_personal_agreements, :creator, foreign_key: { to_table: :users }
    add_reference :shg_term_loan_agreements, :creator, foreign_key: { to_table: :users }
    add_reference :term_loan_agreements, :creator, foreign_key: { to_table: :users }
  end
end
