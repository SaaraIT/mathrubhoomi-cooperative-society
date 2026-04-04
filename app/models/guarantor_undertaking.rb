class GuarantorUndertaking < ApplicationRecord
  belongs_to :member # the borrower
  belongs_to :cooperative_branch
  belongs_to :guarantor, class_name: "Member"  # the guarantor, also a member
  belongs_to :loan_application
  belongs_to :creator, class_name: 'User', optional: true
end
