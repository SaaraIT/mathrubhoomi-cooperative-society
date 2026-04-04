class ShgTermLoanAgreement < ApplicationRecord
  belongs_to :self_help_group
  belongs_to :cooperative_branch
  belongs_to :shg_loan_application
  belongs_to :creator, class_name: 'User', optional: true
end
