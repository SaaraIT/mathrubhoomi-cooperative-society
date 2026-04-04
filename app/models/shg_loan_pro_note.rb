class ShgLoanProNote < ApplicationRecord
  belongs_to :shg_loan_application
  belongs_to :creator, class_name: 'User', optional: true
end
