class ProposedOrganisationEditsController < ApplicationController

  def new
    org = Organisation.find_by_id params[:organisation_id]
    @proposed_organisation_edit = ProposedOrganisationEdit.new organisation: org
  end
  def create
    org = Organisation.find(params[:organisation_id])
    create_params = params.require(:proposed_organisation_edit).permit(:address, :telephone, :postcode, :name,
      :description, :website, :postcode, :email, :donation_info).merge(organisation: org, editor: current_user)
    redirect_to organisation_proposed_organisation_edit_path org, ProposedOrganisationEdit.create!(create_params)
  end
  def show
    @organisation = Organisation.find(params[:organisation_id])
    @proposed_organisation_edit = ProposedOrganisationEdit.find(params[:id])
  end
  def index
    @proposed_organisation_edits = ProposedOrganisationEdit.all
  end
  def update
    if proposed_edit_params.any?
      # update bool for accept / reject
      @proposed_organisation_edit.accept_edits(propsed_edit_params)
    end
    # update bool for archived
  end

  def propsed_edit_params
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
