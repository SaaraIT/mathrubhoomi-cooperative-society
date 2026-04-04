class JewelAppraisersReport < ApplicationRecord
  belongs_to :jewel_loan
  belongs_to :creator, class_name: 'User', optional: true

  has_many :jewel_item_reports, dependent: :destroy

  accepts_nested_attributes_for :jewel_item_reports, allow_destroy: true
end
