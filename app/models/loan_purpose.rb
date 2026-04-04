class LoanPurpose < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :loan_applications

  scope :active, -> { where(active: true) }

  def self.options_for_select
    active.order(:name).pluck(:name, :id)
  end

  # Seed some default loan purposes
  def self.seed_defaults
    defaults = [
      { name: 'EDUCATION PURPOSE', description: 'For educational expenses' },
      { name: 'BUSINESS WORKING CAPITAL/INVESTMENT', description: 'For business working capital or investment' },
      { name: 'HOUSE RENOVATION', description: 'For repairing or renovating existing house' },
      { name: 'VEHICLE PURCHASE', description: 'For purchasing vehicle' },
      { name: 'WEDDING EXPENSES', description: 'For marriage related expenses' },
      { name: 'MEDICAL EXPENSES', description: 'For medical treatment expenses' },
      { name: 'PROPERTY PURCHASE', description: 'For purchasing property' },
      { name: 'RESIDENTIAL HOUSE CONSTRUCTION', description: 'For building a new residential house' },
      { name: 'RESIDENTIAL FLAT PURCHASE', description: 'For purchasing residential flat' },
      { name: 'RESIDENTIAL SITE PURCHASE', description: 'For purchasing residential site' },
      { name: 'COMMERCIAL SITE PURCHASE', description: 'For purchasing commercial site' },
      { name: 'RESIDENTIAL HOUSE RENOVATION', description: 'For renovating residential house' },
      { name: 'EXPANSION OF RESIDENTIAL BUILDING', description: 'For expanding residential building' },
      { name: 'EXPANSION OF COMMERCIAL BUILDING', description: 'For expanding commercial building' },
      { name: 'CONSUMABLE/HOUSEHOLD PURPOSE', description: 'For consumable or household purposes' },
      { name: 'SOLAR PURCHASE', description: 'For purchasing solar equipment' },
      { name: 'GOLD PURCHASE', description: 'For purchasing gold' }
    ]

    defaults.each do |attrs|
      find_or_create_by!(name: attrs[:name]) do |record|
        record.description = attrs[:description]
      end
    end
  end
end
