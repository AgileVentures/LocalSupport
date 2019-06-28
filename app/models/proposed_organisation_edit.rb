# == Schema Information
#
# Table name: proposed_organisation_edits
#
#  id              :integer          not null, primary key
#  accepted        :boolean          default(FALSE), not null
#  address         :string(255)      default(""), not null
#  archived        :boolean          default(FALSE), not null
#  deleted_at      :datetime
#  description     :text             default(""), not null
#  donation_info   :text             default(""), not null
#  email           :string(255)      default(""), not null
#  name            :string(255)      default(""), not null
#  postcode        :string(255)      default(""), not null
#  telephone       :string(255)      default(""), not null
#  website         :string(255)      default(""), not null
#  created_at      :datetime
#  updated_at      :datetime
#  organisation_id :integer
#  user_id         :integer
#
# Indexes
#
#  index_proposed_organisation_edits_on_deleted_at  (deleted_at)
#  index_proposed_organisation_edits_on_user_id     (user_id)
#

require 'proposes_edits'
class ProposedOrganisationEdit < ApplicationRecord
  acts_as_paranoid
  belongs_to :organisation
  belongs_to :editor, :class_name => 'User', :foreign_key => 'user_id'
  include ProposesEdits
  proposes_edits_to :organisation
  editable_fields :address, :name, :description, :postcode, :email, :website, :telephone, :donation_info
  publish_fields_booleans ->(f) {publish_fields_map(f)}
  non_public_fields_editable_by :siteadmin
  non_public_fields_viewable_by :siteadmin, :superadmin
  scope :still_pending, ->{where(archived: false)}

  private

  def self.publish_fields_map field
    if field == :telephone
      :publish_phone
    else
      ('publish_' + field.to_s).to_sym
    end
  end

end
