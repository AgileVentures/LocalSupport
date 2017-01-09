class ProposedOrganisationEditsController < ApplicationController

  before_filter :authorize, :only => [:update]

  def new
    org = Organisation.friendly.find params[:organisation_id]
    @proposed_organisation_edit = ProposedOrganisationEdit.new organisation: org
  end

  def create
    org = Organisation.friendly.find(params[:organisation_id])
    create_params = proposed_edit_params.merge!(organisation: org, editor: current_user)
    proposed_org_edit = CreateProposedOrganisationEdit.with(self, create_params)
    redirect_to organisation_proposed_organisation_edit_path org, proposed_org_edit
  end

  def show
    @organisation = Organisation.friendly.find(params[:organisation_id])
    @proposed_organisation_edit = ProposedOrganisationEdit.find(params[:id])
  end

  def index
    @proposed_organisation_edits = ProposedOrganisationEdit.still_pending
  end

  def update
    # UpdateProposedOrganisationEdit.with(observer: self, params: create_params)
    proposed_edit = ProposedOrganisationEdit.find(update_params.fetch(:id))
    if proposed_edit_params.any?
      proposed_edit.accept(proposed_edit_params)
      flash[:notice] = "The edit you accepted has been applied and archived"
    else
      proposed_edit.update!(archived: true)
      flash[:notice] = "The edit you rejected has been archived"
    end
    redirect_to organisation_path proposed_edit.organisation
  end

  def set_notice(notice)
    flash[:notice] = notice
  end

  def update_params
    params.require(:proposed_organisation_edit).permit(:id)
  end

  def proposed_edit_params
    params.require(:proposed_organisation_edit).permit(
      :name,
      :description,
      :donation_info,
      :address,
      :postcode,
      :telephone,
      :website,
      :email,
    )
  end

  #  +-----+-----+
  #  |  1  |  2  |
  #  |     |     |
  #  +-----+-----+
  #  |  3  |  4  |
  #  |     |     |
  #  +-----+-----+
  #
  #  1. Not archived, not accepted ... what Rachel sees in "All proposed edits"
  #  2. Not archived, accepted ... invalid state
  #  3. archived, not accepted ... rejected edits
  #  4. archived, accepted ... accepted edits
end
