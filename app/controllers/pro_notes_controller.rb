class ProNotesController < ApplicationController
  include EditPermission

  before_action :set_loan_application
  before_action :set_member
  before_action :set_pro_note, only: %i[show edit update destroy]


  def index
    base_scope = if current_user.head_office_user?
                   ProNote.all
                 else
                   Current.branch.pro_notes
                 end
    @q = base_scope.ransack(params[:q])
    @pro_notes = @q.result(distinct: true)
  end

  def new
    @pro_note = @member.pro_notes.new
  end

  def create
    @pro_note = @member.pro_notes.new(pro_note_params)
    @pro_note.cooperative_branch_id = Current.branch.id
    @pro_note.loan_application_id = params["loan_application_id"]
    @pro_note.creator_id = current_user.id
    if @pro_note.save
      redirect_to member_loan_application_path(@member, @loan_application), notice: "ProNote created successfully."
    else
      render :new
    end
  end

  def show;
    @member = @loan_application.member

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "pro_note_form_#{@pro_note.id}",
               template: "pro_notes/show",
               layout: "pdf",
               margin: { top: 5, bottom: 15 },
               footer: {
                  html: {
                    template: 'shared/pdf_header',
                    formats: [:html]
                  }
                },
               show_as_html: params.key?('debug')
      end
    end
  end

  def edit; end

  def update
    if @pro_note.update(pro_note_params)
      redirect_to member_loan_application_path(@member, @loan_application), notice: "ProNote updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @pro_note.destroy
    redirect_to member_path(@member), notice: "ProNote deleted successfully."
  end

  private

  def set_member
    @member = @loan_application.member unless @loan_application.blank?
  end

  def set_pro_note
    @pro_note = @loan_application.pro_notes.find(params[:id])
  end

  def pro_note_params
    params.require(:pro_note).permit(:amount, :place, :date,  :promissory_date, :loan_amount, :loan_details,  :sum, :interest, :promissory_not_date, :promissory_not_amount, :account_no, :account_name, :delivery_date, :loan, :loan_delivery_date, :penal_rate)
  end

  def set_loan_application
    return if params["loan_application_id"].blank?
    @loan_application = if current_user.head_office_user?
                          LoanApplication.find(params["loan_application_id"])
                        else
                          Current.branch.loan_applications.find(params["loan_application_id"])
                        end
  end

  def find_resource_for_permission_check
    @pro_note
  end

  def resource_show_path_for(resource)
    member_loan_application_pro_note_path(resource.member, resource.loan_application, resource)
  end
end
