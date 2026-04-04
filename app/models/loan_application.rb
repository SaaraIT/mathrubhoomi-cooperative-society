class LoanApplication < ApplicationRecord
  validates :r_no, presence: true

  belongs_to :member
  belongs_to :loan_type, optional: true
  belongs_to :loan_purpose, optional: true
  has_many :co_obligants, dependent: :destroy
  has_many :guarantor_undertakings, dependent: :destroy
  has_many :term_loan_agreements
  has_many :demand_promissory_notes
  has_many :pro_notes
  has_many :hypothecation_deeds
  belongs_to :cooperative_branch
  belongs_to :creator, class_name: 'User', optional: true
  has_many :loan_application_co_applicants, dependent: :destroy
  has_many :co_applicants, through: :loan_application_co_applicants, source: :member

  accepts_nested_attributes_for :co_obligants, allow_destroy: true
  accepts_nested_attributes_for :co_applicants, allow_destroy: true
  accepts_nested_attributes_for :member
  accepts_nested_attributes_for :loan_application_co_applicants, allow_destroy: true

  # Returns the loan type code (for backward compatibility)
  def loan_application_type
    loan_type&.code
  end

  # Returns the loan type name
  def loan_application_type_name
    loan_type&.name
  end

  # Returns the loan purpose name (for backward compatibility)
  def loan_purpose_name
    loan_purpose&.name
  end

  def surety_names
    co_obligants.map { |co| co.member&.name }.compact.join(", ")
  end

  def applicant_names
    ([member.name] + co_applicants.pluck(:name)).join(' and ')
  end

  def applicant_names_and_addresses
    ([member.name_and_address(false)] + co_applicants.map{|m| m.name_and_address(false)}).join(' and ')
  end

  def surety_names_with_address(br=false)
    co_obligants.map do |co|
      member = co.member
      next unless member.present?

      "#{member.name_and_address}"
    end.compact.join(" and ")
  end

  def int_rate
    interest_rate = InterestRate.matching_rate(
      loan_application_type,
      sanction_amount.to_i
    )

    return interest_rate.rate if interest_rate.present?

    fallback_rate
  end

  private

  def fallback_rate
    case loan_application_type
    when "ML", "SE", "LICNSC" then 15.5
    when "VL"                then 8.0
    when "SL"                then 16.5
    when "EL"                then 14.0
    when "BL"                then 16.0
    when "OTHER"             then 13.0
    when "STL"               then 12.0
    when "DRPL"              then 18.5
    when "HOUSING LOAN"
      case sanction_amount.to_i
      when 0..1_000_000           then 10.5
      when 1_000_001..2_500_000   then 12.0
      else                             12.5
      end
    end
  end
end
