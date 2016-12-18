class ProposedOrganisation < BaseOrganisation
  has_many :users, :foreign_key => 'organisation_id'
  
  def accept_proposal(rollback_acception = false)
    if rollback_acception
      org = becomes!(ProposedOrganisation)
    else
      org = becomes!(Organisation)
    end
    org.save!
    org
  end
end

