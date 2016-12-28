class ProposedOrganisation < BaseOrganisation
  has_many :users, :foreign_key => 'organisation_id'
  
  def accept_proposal(rollback = false)
    org = rollback ? becomes!(ProposedOrganisation) : becomes!(Organisation)
    org.save!
    org
  end
end

