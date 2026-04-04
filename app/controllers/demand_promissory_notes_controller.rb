class DemandPromissoryNotesController < ApplicationController
  include EditPermission

  before_action :set_loan_application
  before_action :set_member
  before_action :set_demand_promissory_note, only: [:show, :edit, :update, :destroy]


  def index
    base_scope = if current_user.head_office_user?
                   DemandPromissoryNote.all
                 else
                   Current.branch.demand_promissory_notes
                 end
    @q = base_scope.ransack(params[:q])
    @demand_promissory_notes = @q.result(distinct: true)
  end

  def show
    @member = Member.find(params[:id])
    
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "member_form_#{@member.id}",
               template: "demand_promissory_notes/show",
               layout: "pdf",
               margin: { top: 5, bottom: 5 }, 
               footer: {
                  html: {
                    template: 'shared/pdf_header',
                    formats: [:html]
                  }
                },
                enable_local_file_access: true,
               show_as_html: params.key?('debug')
      end
    end
  end

  def new
    @demand_promissory_note = @member.demand_promissory_notes.new
  end

  def create
    @demand_promissory_note = @loan_application.demand_promissory_notes.new(demand_promissory_note_params)
    @demand_promissory_note.cooperative_branch_id = Current.branch.id
    @demand_promissory_note.member_id = params["member_id"]
    @demand_promissory_note.creator_id = current_user.id

    # For staff/manager, set default values from loan_application since they can only edit loan_no
    if current_user.staff? || current_user.manager?
      @demand_promissory_note.amount = @loan_application.sanction_amount || 0
      @demand_promissory_note.date = Date.today
      @demand_promissory_note.borrower_name = @loan_application.applicant_names_and_addresses
      @demand_promissory_note.sum = @loan_application.sanction_amount || 0
      @demand_promissory_note.interest_rate = @loan_application.int_rate || 0
      @demand_promissory_note.penal_rate = 3
      @demand_promissory_note.witness1 = @loan_application.co_obligants.first&.member&.name
    end

    Rails.logger.info "DPN Errors: #{@demand_promissory_note.errors.full_messages}" unless @demand_promissory_note.valid?

    if @demand_promissory_note.save
      redirect_to member_loan_application_path(@member, @loan_application), notice: "Demand Promissory Note created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @demand_promissory_note.update(demand_promissory_note_update_params)
      redirect_to member_loan_application_path(@member, @loan_application), notice: "Demand Promissory Note updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @demand_promissory_note.destroy
    redirect_to loan_application_path(@loan_application), notice: "Demand Promissory Note deleted successfully."
  end

  private

  def set_member
    @member = @loan_application.try(:member)
  end

  def set_demand_promissory_note
    @demand_promissory_note = @loan_application.demand_promissory_notes.find(params[:id])
  end

  def set_loan_application
    return if params["loan_application_id"].blank?
    @loan_application = if current_user.head_office_user?
                          LoanApplication.find(params["loan_application_id"])
                        else
                          Current.branch.loan_applications.find(params["loan_application_id"])
                        end
  end
  
  def demand_promissory_note_params
    # Staff and manager can only edit loan_no
    if current_user.staff? || current_user.manager?
      permitted_params = [:loan_no]
    else
      permitted_params = [:branch, :loan_no, :amount, :date, :borrower_name, :surety1_name, :surety2_name, :interest_rate, :penal_rate, :witness1, :witness2, :sum, :sum_in_words]
    end
    params.require(:demand_promissory_note).permit(permitted_params)
  end

  def demand_promissory_note_update_params
    # Staff and manager can only edit loan_no
    if current_user.staff? || current_user.manager?
      permitted_params = [:loan_no]
    else
      permitted_params = [:branch, :loan_no, :amount, :date, :borrower_name, :surety1_name, :surety2_name, :interest_rate, :penal_rate, :witness1, :witness2, :sum, :sum_in_words]
    end
    params.require(:demand_promissory_note).permit(permitted_params)
  end

  def find_resource_for_permission_check
    @demand_promissory_note
  end

  def resource_show_path_for(resource)
    member_loan_application_demand_promissory_note_path(resource.member, resource.loan_application, resource)
  end
end
