# == Schema Information
#
# Table name: organisations
#
#  id                    :integer          not null, primary key
#  address               :string(255)      default(""), not null
#  deleted_at            :datetime
#  description           :text             default(""), not null
#  donation_info         :text             default(""), not null
#  email                 :string(255)      default(""), not null
#  gmaps                 :boolean
#  imported_at           :datetime
#  imported_from         :string
#  latitude              :float
#  longitude             :float
#  name                  :string(255)      default(""), not null
#  non_profit            :boolean
#  postcode              :string(255)      default(""), not null
#  publish_address       :boolean          default(FALSE)
#  publish_email         :boolean          default(TRUE)
#  publish_phone         :boolean          default(FALSE)
#  slug                  :string
#  telephone             :string(255)      default(""), not null
#  type                  :string           default("Organisation")
#  website               :string(255)      default(""), not null
#  created_at            :datetime
#  updated_at            :datetime
#  charity_commission_id :integer
#  imported_id           :integer
#
# Indexes
#
#  index_organisations_on_slug  (slug) UNIQUE
#

class ProposedOrganisation < BaseOrganisation
  has_many :users, :foreign_key => 'organisation_id'
  
  def accept_proposal
    org = becomes!(Organisation)
    org.save!
    org
  end
end

