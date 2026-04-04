module LoanEditPermission
  extend ActiveSupport::Concern

  included do
    before_action :check_edit_permission, only: [:edit, :update]
  end

  private

  def check_edit_permission
    return unless current_user.staff?

    loan = find_loan_for_permission_check

    if loan.nil?
      redirect_to root_path, alert: "Loan not found."
      return
    end

    loan_type = loan.class.name
    loan_id = loan.id

    unless EditRequest.has_approved_request?(loan_type, loan_id, current_user.id)
      redirect_to loan_show_path_for(loan), alert: "You don't have permission to edit this loan. Please request edit access first."
    end
  end

  def find_loan_for_permission_check
    raise NotImplementedError, "Subclass must implement find_loan_for_permission_check"
  end

  def loan_show_path_for(loan)
    case loan
    when LoanApplication
      loan.member ? member_loan_application_path(loan.member, loan) : loan_application_path(loan)
    when ShgLoanApplication
      shg_loan_application_path(loan)
    when JewelLoan
      loan.member ? member_jewel_loan_path(loan.member, loan) : jewel_loan_path(loan)
    else
      root_path
    end
  end
end
