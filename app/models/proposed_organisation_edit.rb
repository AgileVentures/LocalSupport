require 'proposes_edits'
class ProposedOrganisationEdit < ActiveRecord::Base
  include ProposesEdits
  proposes_edits_to :organisation
  editable_fields :address

  has_one :organisation
end
