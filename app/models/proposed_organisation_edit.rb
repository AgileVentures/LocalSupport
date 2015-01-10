require 'proposes_edits'
class ProposedOrganisationEdit < ActiveRecord::Base
  belongs_to :organisation
  include ProposesEdits
  proposes_edits_to :organisation
  editable_fields :address, :name, :description, :postcode, :email, :website, :telephone, :donation_info
  publish_fields_booleans ->(f) {publish_fields_map(f)}

  private
  def self.publish_fields_map field
    if field == :telephone
      :publish_phone
    else
      ('publish_' + field.to_s).to_sym
    end
  end

end
