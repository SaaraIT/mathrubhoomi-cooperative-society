class BranchManagerReport < ApplicationRecord
  belongs_to :loan_application
  belongs_to :creator, class_name: 'User', optional: true
end
