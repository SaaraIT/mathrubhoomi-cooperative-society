module EditPermission
  extend ActiveSupport::Concern

  included do
    before_action :check_edit_permission, only: [:edit, :update]
  end

  private

  def check_edit_permission
    return unless current_user.staff?

    resource = find_resource_for_permission_check
    return if resource.nil?

    resource_type = resource.class.name
    resource_id = resource.id

    # Check if resource belongs to user's branch
    resource_branch_id = resource.respond_to?(:cooperative_branch_id) ? resource.cooperative_branch_id : nil

    if resource_branch_id && resource_branch_id != current_user.cooperative_branch_id
      redirect_to resource_show_path_for(resource), alert: "You can only edit resources from your branch."
      return
    end

    unless EditRequest.has_approved_request?(resource_type, resource_id, current_user.id)
      redirect_to resource_show_path_for(resource), alert: "You don't have permission to edit this. Please request edit access first."
    end
  end

  def find_resource_for_permission_check
    raise NotImplementedError, "Subclass must implement find_resource_for_permission_check"
  end

  def resource_show_path_for(resource)
    case resource
    when Member
      member_path(resource)
    when LoanApplication
      resource.member ? member_loan_application_path(resource.member, resource) : loan_application_path(resource)
    when ShgLoanApplication
      shg_loan_application_path(resource)
    when JewelLoan
      resource.member ? member_jewel_loan_path(resource.member, resource) : jewel_loan_path(resource)
    when ShgLoanProNote, ShgTermLoanAgreement, ShgDemandPromissoryNote
      self_help_group_shg_loan_application_path(resource.shg_loan_application.self_help_group, resource.shg_loan_application)
    else
      root_path
    end
  end
end
