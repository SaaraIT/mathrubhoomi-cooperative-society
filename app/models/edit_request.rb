class EditRequest < ApplicationRecord
  # Supported resource types for edit requests
  RESOURCE_TYPES = %w[
    Member
    LoanApplication
    ShgLoanApplication
    JewelLoan
    HypothecationDeed
    ProNote
    DemandPromissoryNote
    TermLoanAgreement
    GuarantorUndertaking
    ShgLoanProNote
    ShgDemandPromissoryNote
    ShgTermLoanAgreement
    ShgPersonalAgreement
  ].freeze

  belongs_to :user
  belongs_to :cooperative_branch
  belongs_to :approved_by, class_name: "User", optional: true
  belongs_to :resource, polymorphic: true, optional: true

  validates :resource_type, presence: true, inclusion: { in: RESOURCE_TYPES }
  validates :resource_id, presence: true
  validates :reason, presence: true

  scope :pending, -> { where(approved: nil) }
  scope :approved_requests, -> { where(approved: true) }
  scope :rejected, -> { where(approved: false) }
  scope :for_resource, ->(type, id) { where(resource_type: type, resource_id: id) }

  def resource
    resource_type.constantize.find_by(id: resource_id)
  end

  def status
    return "pending" if approved.nil?
    approved ? "approved" : "rejected"
  end

  def approve!(approver)
    update!(
      approved: true,
      approved_by: approver,
      approved_on: Time.current
    )
  end

  def reject!(approver, rejection_reason = nil)
    update!(
      approved: false,
      approved_by: approver,
      approved_on: Time.current,
      rejection_reason: rejection_reason
    )
  end

  def can_edit?
    approved == true
  end

  def self.has_approved_request?(resource_type, resource_id, user_id)
    where(
      resource_type: resource_type,
      resource_id: resource_id,
      user_id: user_id,
      approved: true
    ).exists?
  end

  def self.has_pending_request?(resource_type, resource_id, user_id)
    where(
      resource_type: resource_type,
      resource_id: resource_id,
      user_id: user_id,
      approved: nil
    ).exists?
  end

  # Human-readable resource type name
  def resource_type_display
    resource_type.underscore.humanize.titleize
  end

  # Get the path to view the resource
  def resource_path_info
    res = resource
    return nil unless res

    case resource_type
    when 'Member'
      { path_helper: :member_path, args: [res] }
    when 'LoanApplication'
      { path_helper: :member_loan_application_path, args: [res.member, res] }
    when 'ShgLoanApplication'
      { path_helper: :member_shg_loan_application_path, args: [res.member, res] }
    when 'JewelLoan'
      { path_helper: :member_jewel_loan_path, args: [res.member, res] }
    when 'HypothecationDeed'
      { path_helper: :member_loan_application_hypothecation_deed_path, args: [res.member, res.loan_application, res] }
    when 'ProNote'
      { path_helper: :member_loan_application_pro_note_path, args: [res.member, res.loan_application, res] }
    when 'DemandPromissoryNote'
      { path_helper: :member_loan_application_demand_promissory_note_path, args: [res.member, res.loan_application, res] }
    when 'TermLoanAgreement'
      { path_helper: :member_loan_application_term_loan_agreement_path, args: [res.member, res.loan_application, res] }
    when 'GuarantorUndertaking'
      { path_helper: :member_loan_application_guarantor_undertaking_path, args: [res.member, res.loan_application, res] }
    when 'ShgLoanProNote'
      { path_helper: :shg_loan_application_shg_loan_pro_note_path, args: [res.shg_loan_application, res] }
    when 'ShgDemandPromissoryNote'
      { path_helper: :shg_loan_application_shg_demand_promissory_note_path, args: [res.shg_loan_application, res] }
    when 'ShgTermLoanAgreement'
      { path_helper: :shg_loan_application_shg_term_loan_agreement_path, args: [res.shg_loan_application, res] }
    when 'ShgPersonalAgreement'
      { path_helper: :shg_loan_application_shg_personal_agreement_path, args: [res.shg_loan_application, res] }
    else
      nil
    end
  end
end
