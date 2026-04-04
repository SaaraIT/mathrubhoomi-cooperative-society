class DemandPromissoryNote < ApplicationRecord
  belongs_to :member
  belongs_to :cooperative_branch
  belongs_to :loan_application
  belongs_to :creator, class_name: 'User', optional: true
  
  validates :loan_no, :sum, :date, presence: true
  validates :interest_rate, :penal_rate, numericality: true, allow_nil: true
end
