require 'proposes_edits'
class ProposedOrganisationEdit < ActiveRecord::Base
  belongs_to :organisation
  include ProposesEdits
  proposes_edits_to :organisation
  editable_fields :address, :name, :description, :postcode, :email, :website, :telephone, :donation_info

end
