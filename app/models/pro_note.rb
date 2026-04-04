class ProNote < ApplicationRecord
  belongs_to :member
  belongs_to :cooperative_branch
  belongs_to :loan_application
  belongs_to :creator, class_name: 'User', optional: true
end
