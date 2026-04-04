class EditRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_resource, only: [:new, :create]

  def new
    if @resource.nil?
      redirect_to root_path, alert: 'Resource not found.'
      return
    end

    # Check if user can request edit for this resource
    unless can_request_edit?
      redirect_back fallback_location: root_path, alert: 'You cannot request edit for this resource.'
      return
    end

    # Check if there's already a pending request
    if EditRequest.has_pending_request?(@resource_type, @resource_id, current_user.id)
      redirect_back fallback_location: root_path, alert: 'You already have a pending edit request for this resource.'
      return
    end

    @edit_request = EditRequest.new(resource_type: @resource_type, resource_id: @resource_id)
  end

  def create
    @edit_request = EditRequest.new(edit_request_params)
    @edit_request.user = current_user
    @edit_request.cooperative_branch = current_user.cooperative_branch

    @resource_type = @edit_request.resource_type
    @resource_id = @edit_request.resource_id
    @resource = find_resource(@resource_type, @resource_id)

    # Check if there's already a pending request
    if EditRequest.has_pending_request?(@edit_request.resource_type, @edit_request.resource_id, current_user.id)
      redirect_back fallback_location: root_path, alert: 'You already have a pending edit request for this resource.'
      return
    end

    if @edit_request.save
      redirect_to resource_show_path, notice: 'Edit request submitted successfully. Waiting for approval.'
    else
      render :new
    end
  end

  private

  def edit_request_params
    params.require(:edit_request).permit(:resource_type, :resource_id, :reason)
  end

  def set_resource
    @resource_type = params[:resource_type]
    @resource_id = params[:resource_id]
    @resource = find_resource(@resource_type, @resource_id)
  end

  def find_resource(resource_type, resource_id)
    return nil unless resource_type.present? && resource_id.present?
    return nil unless EditRequest::RESOURCE_TYPES.include?(resource_type)

    resource_type.constantize.find_by(id: resource_id)
  end

  def can_request_edit?
    return false unless @resource
    return false unless current_user.staff?

    # Staff can only request edit for resources in their branch
    resource_branch_id = case @resource_type
    when 'Member'
      @resource.cooperative_branch_id
    when 'LoanApplication', 'ShgLoanApplication', 'JewelLoan'
      @resource.cooperative_branch_id
    when 'HypothecationDeed', 'ProNote', 'DemandPromissoryNote', 'TermLoanAgreement', 'GuarantorUndertaking'
      @resource.cooperative_branch_id
    when 'ShgDemandPromissoryNote', 'ShgTermLoanAgreement'
      @resource.cooperative_branch_id
    when 'ShgLoanProNote', 'ShgPersonalAgreement'
      @resource.shg_loan_application.cooperative_branch_id
    else
      nil
    end

    current_user.cooperative_branch_id == resource_branch_id
  end

  def resource_show_path
    case @resource_type
    when 'Member'
      member_path(@resource)
    when 'LoanApplication'
      member_loan_application_path(@resource.member, @resource)
    when 'ShgLoanApplication'
      shg_loan_application_path(@resource)
    when 'JewelLoan'
      member_jewel_loan_path(@resource.member, @resource)
    when 'HypothecationDeed'
      member_loan_application_path(@resource.member, @resource.loan_application)
    when 'GuarantorUndertaking'
      member_loan_application_path(@resource.member, @resource.loan_application)
    when 'ShgLoanProNote'
      shg_loan_application_shg_loan_pro_note_path(@resource.shg_loan_application, @resource)
    when 'ShgDemandPromissoryNote'
      shg_loan_application_shg_demand_promissory_note_path(@resource.shg_loan_application, @resource)
    when 'ShgTermLoanAgreement'
      shg_loan_application_shg_term_loan_agreement_path(@resource.shg_loan_application, @resource)
    when 'ShgPersonalAgreement'
      shg_loan_application_shg_personal_agreement_path(@resource.shg_loan_application, @resource)
    else
      root_path
    end
  end
end
