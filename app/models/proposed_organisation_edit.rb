require 'proposes_edits'
class ProposedOrganisationEdit < ActiveRecord::Base
  include ProposesEdits
  proposes_edits_to :organisation
  editable_fields :address, :name, :description, :postcode, :email, :website, :telephone, :donation_info

  has_one :organisation
end
