class ProposedOrganisationEditsController < ApplicationController

  def new
    org = Organisation.find_by_id params[:organisation_id]
    @proposed_organisation_edit = ProposedOrganisationEdit.new organisation: org
  end
  def create
    org = Organisation.find(params[:organisation_id])
    create_params = params.require(:proposed_organisation_edit).permit(:address, :telephone, :postcode, :name, :description, :website, :postcode, :email, :donation_info).merge(organisation: org)
    redirect_to organisation_proposed_organisation_edit_path org, ProposedOrganisationEdit.create!(create_params)
  end
  def show
    @organisation = Organisation.find(params[:organisation_id])
    @proposed_organisation_edit = ProposedOrganisationEdit.find(params[:id])
  end

end
