require 'proposes_edits'
class ProposedOrganisationEdit < ActiveRecord::Base
  include ActiveModel::Validations

  acts_as_paranoid

  validates :postcode, presence: true, postcode: true
  validates :name, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 3 }
  validates :email, uniqueness: true, presence: true, email: true
  validates :website, :donation_info, allow_blank: true, url: true

  belongs_to :organisation
  belongs_to :editor, :class_name => "User", :foreign_key => "user_id"
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
