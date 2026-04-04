class ShgDemandPromissoryNote < ApplicationRecord
  belongs_to :cooperative_branch
  belongs_to :shg_loan_application
  belongs_to :creator, class_name: 'User', optional: true

  validates :loan_no, presence: true
end
