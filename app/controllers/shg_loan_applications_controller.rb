class ShgLoanApplicationsController < ApplicationController
  include LoanEditPermission

  prepend_before_action :set_shg_loan_application, only: [:show, :edit, :update, :destroy]
  before_action :set_shg

  def index
    if(current_user.super_admin? || current_user.section_head?)
      @q = ShgLoanApplication.ransack(params[:q])
    else
       @q = Current.branch.shg_loan_applications.ransack(params[:q])
    end

   
    @shg_loan_applications = @q.result(distinct: true)
  end

  def show
    @shg_loan_application = ShgLoanApplication.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "loan_application_form_#{@shg_loan_application.id}",
               template: "shg_loan_applications/show",
               layout: "pdf",
               margin: { top: 12, bottom: 12 }, 
               page_size: "A4",
               footer: {
                  html: {
                    template: 'shg_loan_applications/pdf_footer',
                    formats: [:html]
                  }
                },
               show_as_html: params.key?('debug')
      end
    end
  end

  def new
    @shg_loan_application = @self_help_group.shg_loan_applications.new

    10.times { @shg_loan_application.shg_loan_applicants.build }
  end

  def create
    @shg_loan_application = @self_help_group.shg_loan_applications.new(shg_loan_application_params)
    @shg_loan_application.cooperative_branch =  Current.branch
    @shg_loan_application.creator_id = current_user.id

    if @shg_loan_application.save
      redirect_to @shg_loan_application, notice: "Loan application was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    (10 - @shg_loan_application.shg_loan_applicants.count).times { @shg_loan_application.shg_loan_applicants.build }
  end

  def update
    if @shg_loan_application.update(shg_loan_application_params)
      redirect_to @shg_loan_application, notice: "Loan application was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shg_loan_application.destroy
    redirect_to shg_loan_applications_path, notice: "Loan application was successfully deleted."
  end

  private

  def set_shg
    @self_help_group = SelfHelpGroup.find(params[:self_help_group_id]) unless params[:self_help_group_id].blank?
  end

  def set_shg_loan_application
    @shg_loan_application = ShgLoanApplication.find(params[:id])
  end

  def find_loan_for_permission_check
    @shg_loan_application
  end

  def shg_loan_application_params
    permitted = []

    # Fields editable by staff and manager (before Head Office Section)
    if current_user.staff? || current_user.manager?
      permitted += member_editable_fields
    end

    # Fields editable by super_admin and section_head (Head Office Section and after)
    if current_user.super_admin? || current_user.section_head?
      permitted += head_office_editable_fields
    end

    # Add nested attributes
    permitted << {
      shg_loan_applicants_attributes: [
        :id,
        :shg_member_id,
        :loan_amount,
        :purpose_of_loan,
        :_destroy,
        shg_personal_agreement_attributes: [
          :id,
          :guarantor_id,
          :terms,
          :witness_name,
          :_destroy
        ]
      ]
    } if current_user.staff? || current_user.manager?

    params.require(:shg_loan_application).permit(permitted)
  end

  def member_editable_fields
    [
      :membership_number,
      :shg_name,
      :address,
      :commencement_date,
      :total_savings,
      :total_members,
      :previous_loan_date,
      :previous_loan_amount,
      :internal_loan_outstanding,
      :deposit_amount,
      :weekly_meetings,
      :records_maintained,
      :supervisor_meeting_date,
      :supervisor_sanctionable_amount,
      :supervisor_comments,
      :supervisor_unanimous,
      :supervisor_productive_more_than_nonproductive,
      :total_loan_received,
      :total_loan_repaid,
      :total_loan_outstanding,
      :excess_demand_details,
      :weekly_deposit_compliance,
      :supervisor_report,
      :bm_report,
      :bm_purpose,
      :bm_amount,
      :bm_term,
      :bm_security,
      :bm_date,
      :bm_place,
      :r_no,
      :application_date,
      :declaration_date,
      :declaration_plce
    ]
  end

  def head_office_editable_fields
    [
      :ho_report,
      :ho_date,
      :ho_place,
      :sanction_order_no,
      :sanction_order_date,
      :sanction_amount,
      :resolution_limit,
      :resolution_number,
      :inspection_report,
      :inspection_date,
      :inspection_place,
      :disbursement_date,
      :account_no,
      :account_term,
      :account_amount,
      :account_roi,
      :bm_sign_date,
      :bm_sign_place
    ]
  end
end
