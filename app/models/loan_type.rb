class LoanType < ApplicationRecord
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  has_many :loan_applications

  scope :active, -> { where(active: true) }

  def self.options_for_select
    active.order(:name).pluck(:name, :code)
  end

  def self.code_name_hash
    active.pluck(:code, :name).to_h
  end

  def display_name
    "#{code} - #{name}"
  end

  # Seed default loan types from the existing hardcoded values
  def self.seed_defaults
    defaults = [
      { code: 'ML', name: 'Mortgage Loan' },
      { code: 'SE', name: 'Self Employment Loan' },
      { code: 'LICNSC', name: 'LIC/NSC Loan' },
      { code: 'VL', name: 'Vehicle Loan' },
      { code: 'SL', name: 'Staff Loan' },
      { code: 'EL', name: 'Education Loan' },
      { code: 'BL', name: 'Business Loan' },
      { code: 'OTHER', name: 'Other Loan' },
      { code: 'STL', name: 'Short Term Loan' },
      { code: 'DRPL', name: 'DRPL Loan' },
      { code: 'HOUSING LOAN', name: 'Housing Loan' }
    ]

    defaults.each do |attrs|
      find_or_create_by!(code: attrs[:code]) do |record|
        record.name = attrs[:name]
      end
    end
  end
end
