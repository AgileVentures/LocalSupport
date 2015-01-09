class ProposedOrganisationEditsController < ApplicationController

  def new
    org = Organisation.find_by_id params[:organisation_id]
    @proposed_organisation_edit = ProposedOrganisationEdit.new organisation: org
  end
  def create

  end
end