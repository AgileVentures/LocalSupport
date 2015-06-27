class ProposedOrganisation < BaseOrganisation
  has_many :users, :foreign_key => 'organisation_id'
  class MembershipEligibility < ActiveModel::Validator
    def validate(record)
      record.errors[:nonprofit] << "You must be a nonprofit organisation to join Harrow Community Network" unless record.non_profit 
      unless record.works_in_harrow || record.registered_in_harrow
        record.errors[:works_or_registered] << "You must be registered or work in Harrow to join Harrow Community Network"
      end
    end
  end

  validates_with MembershipEligibility

  def accept_proposal
    org = becomes!(Organisation)
    org.save!
    org
  end
end

