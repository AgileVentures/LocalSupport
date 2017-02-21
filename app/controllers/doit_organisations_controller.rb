class DoitOrganisationsController < ApplicationController
  before_action :authorize

  def index
    @doit_orgs = Doit::GetManagedOrganisations.call 

    respond_to do |format|
      format.js
    end
  end
end
