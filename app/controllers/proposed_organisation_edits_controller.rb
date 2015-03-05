class ProposedOrganisationEditsController < ApplicationController

  before_filter :authorize, :only => [:update]

  def new
    org = Organisation.find_by_id params[:organisation_id]
    @proposed_organisation_edit = ProposedOrganisationEdit.new organisation: org
  end

  def create
    org = Organisation.find(params[:organisation_id])
    create_params = params.require(:proposed_organisation_edit).permit(:address, :telephone, :postcode, :name,
      :description, :website, :postcode, :email, :donation_info).merge(organisation: org, editor: current_user)
    unless current_user.siteadmin?
      merge_in_non_published_fields org, create_params
    end
    redirect_to organisation_proposed_organisation_edit_path org, ProposedOrganisationEdit.create!(create_params)
  end

  def show
    @organisation = Organisation.find(params[:organisation_id])
    @proposed_organisation_edit = ProposedOrganisationEdit.find(params[:id])
  end

  def index
    #TODO use scope
    @proposed_organisation_edits = ProposedOrganisationEdit.still_pending
  end

  def update
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
  private 
  def merge_in_non_published_fields(org, create_params)
    in_memory_edit = ProposedOrganisationEdit.new(organisation: org)
    in_memory_edit.non_published_generally_editable_fields.each do |non_published_field|
      create_params.merge!(non_published_field => org.send(non_published_field))
    end
  end
end
