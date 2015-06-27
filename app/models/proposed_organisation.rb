class ProposedOrganisation < BaseOrganisation
  has_many :users, :foreign_key => 'organisation_id'
  class MembershipEligibility < ActiveModel::Validator
    def validate(record)
      record.errors[:nonprofit] << "You must be a nonprofit to join Harrow Community Network" unless record.non_profit 
    end
  end

  validates_with MembershipEligibility
  
  def accept_proposal
    org = becomes!(Organisation)
    org.save!
    org
  end
end

