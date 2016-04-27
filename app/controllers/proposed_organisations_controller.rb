class ProposedOrganisationsController < BaseOrganisationsController
  layout 'two_columns_with_map', except: [:index]
  before_filter :require_superadmin_or_recent_creation, only: [:show]
  before_filter :require_superadmin, only: [:update, :destroy]

  def index
    @proposed_organisations = ProposedOrganisation.all
  end

  def update
    proposed_org = ProposedOrganisation.friendly.find params[:id]
    result = AcceptProposedOrganisation.new(proposed_org).run
    set_flash_for_accepting_proposed_org result
    redirect_to organisation_path(result.accepted_organisation) and return false
  end

  def destroy
    proposed_org = ProposedOrganisation.friendly.find params[:id]
    proposed_org.destroy
    redirect_to proposed_organisations_path
  end

  def new
    @proposed_organisation = ProposedOrganisation.new 
    @user_id = session[:user_id] || current_user.try(:id)
  end

  def create
    make_user_into_org_admin_of_new_proposed_org
    if @proposed_organisation.save
      session[:proposed_organisation_id] = @proposed_organisation.id
      send_email_to_superadmin_about_org_signup @proposed_organisation
      redirect_to @proposed_organisation, notice: 'Organisation is pending admin approval.'
    else
      render :new
    end
    
  end

  def show
    @proposed_organisation = ProposedOrganisation.friendly.find(params[:id])
    proposed_organisations = ProposedOrganisation.where(id: @proposed_organisation.id)
    #refactor this into model
    @proposer_email = @proposed_organisation.users.first.email if !@proposed_organisation.users.empty?
    @markers = build_map_markers(proposed_organisations)
  end

  private

  def set_flash_for_accepting_proposed_org result
    flash[:notice] = "You have approved the following organisation"
    flash_msg = case result.status
      when AcceptProposedOrganisation::Response::INVALID_EMAIL
        "No invitation email was sent because the email associated with #{result.accepted_organisation.name}, #{result.accepted_organisation.email}, seems invalid"
      when AcceptProposedOrganisation::Response::NO_EMAIL
        "No invitation email was sent because no email is associated with the organisation"
      when AcceptProposedOrganisation::Response::INVITATION_SENT
        "An invitation email was sent to #{result.accepted_organisation.email}"
      when AcceptProposedOrganisation::Response::NOTIFICATION_SENT
        "A notification of acceptance was sent to #{result.accepted_organisation.email}"
      else
        "No mail was sent because: #{result.error_message}"
      end
     flash[:error] = flash_msg
  end

  def make_user_into_org_admin_of_new_proposed_org
    org_params = ProposedOrganisationParams.build params
    usr = User.find params[:proposed_organisation][:user_id] if params[:proposed_organisation][:user_id]
    @proposed_organisation = ProposedOrganisation.new(org_params)
    @proposed_organisation.users << [usr] if usr
  end

  def send_email_to_superadmin_about_org_signup(org)
    superadmin_emails = User.superadmins.pluck(:email)
    AdminMailer.new_org_waiting_for_approval(org, superadmin_emails).deliver_now
  end

  def require_superadmin
    unless current_user.try(:superadmin?)
      flash[:warning] = PERMISSION_DENIED
      redirect_to root_path and return false
    end
  end

  def require_superadmin_or_recent_creation
    unless session[:proposed_organisation_id] || current_user.try(:superadmin)
      flash[:notice] = PERMISSION_DENIED
      redirect_to root_path
    end
  end
end

class ProposedOrganisationParams
  def self.build params
    params.require(:proposed_organisation).permit(
      :superadmin_email_to_add,
      :description,
      :address,
      :publish_address,
      :postcode,
      :email,
      :publish_email,
      :website,
      :publish_phone,
      :donation_info,
      :name,
      :telephone,
      :non_profit,
      :works_in_harrow,
      :registered_in_harrow,
      category_ids: []
    )
  end
end
