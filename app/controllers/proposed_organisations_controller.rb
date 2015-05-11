class ProposedOrganisationsController < ApplicationController
  def new
    @proposed_organisation = ProposedOrganisation.new 
    @categories_start_with = Category.first_category_name_in_each_type
    @user_id = session[:user_id]
  end
  def create
    org_params = ProposedOrganisationParams.build params
    usr = User.find params[:proposed_organisation][:user_id]
    @proposed_organisation = ProposedOrganisation.new(org_params)
    @proposed_organisation.users << [usr]
    if @proposed_organisation.save!
      byebug
      redirect_to @proposed_organisation, notice: 'Organisation is pending admin approval.'
    else
      render action: "new"
    end
  end
  def show
    @proposed_organisation = ProposedOrganisation.find(params[:id])
    @proposer_email = @proposed_organisation.users.first.email
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
      category_base_organisations_attributes: [:_destroy, :category_id, :id]
    )
  end
  end
