class ProposedOrganisation < BaseOrganisation
  has_many :users, :foreign_key => 'organisation_id'
end
