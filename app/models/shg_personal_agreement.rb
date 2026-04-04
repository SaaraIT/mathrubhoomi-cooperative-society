class ShgPersonalAgreement < ApplicationRecord
  belongs_to :shg_loan_applicant

  belongs_to :shg_loan_application
  belongs_to :guarantor, class_name: "Member"
  belongs_to :creator, class_name: 'User', optional: true
end
