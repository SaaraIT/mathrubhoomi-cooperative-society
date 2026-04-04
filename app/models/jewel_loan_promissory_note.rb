class JewelLoanPromissoryNote < ApplicationRecord
  belongs_to :jewel_loan
  belongs_to :creator, class_name: 'User', optional: true
end
