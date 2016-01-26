require 'proposes_edits'
class ProposedOrganisationEdit < ActiveRecord::Base
  before_validation :add_url_protocol

  acts_as_paranoid

  belongs_to :organisation
  belongs_to :editor, :class_name => "User", :foreign_key => "user_id"
  include ProposesEdits
  proposes_edits_to :organisation
  editable_fields :address, :name, :description, :postcode, :email, :website, :telephone, :donation_info
  publish_fields_booleans ->(f) {publish_fields_map(f)}
  non_public_fields_editable_by :siteadmin
  non_public_fields_viewable_by :siteadmin, :superadmin
  scope :still_pending, ->{where(archived: false)}

  validates_format_of :donation_info, :allow_blank => true,
    :with => /^(?:http:\/\/|https:\/\/|)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :multiline => true, :message => "Please enter a valid URL"
  validates_format_of :website, :allow_blank => true,
    :with => /^(?:http:\/\/|https:\/\/|)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix, :multiline => true, :message => "Please enter a valid URL"


  def add_url_protocol
      self.website = "http://#{self.website}" if needs_url_protocol? self.website
      self.donation_info = "http://#{self.donation_info}" if needs_url_protocol? self.donation_info
  end

  private
  def self.publish_fields_map field
    if field == :telephone
      :publish_phone
    else
      ('publish_' + field.to_s).to_sym
    end
  end

  def needs_url_protocol? url
    !valid_url_with_protocol?(url) && url.length > 0
  end

  def valid_url_with_protocol? url
    url[/\Ahttp:\/\//] || url[/\Ahttps:\/\//]
  end
end
