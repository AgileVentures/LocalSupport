class ProposedOrganisation < BaseOrganisation
  has_many :users, :foreign_key => 'organisation_id'
  validates_each :non_profit, :works_in_harrow, :registered_in_harrow  do  |record, attr, value|
    if attr == :non_profit
      record.errors.add(attr,"You must be a nonprofit organisation to join Harrow Community Network") unless record.non_profit
    else
      record.errors.add(attr,"You must be registered or work in Harrow to join Harrow Community Network") unless record.works_in_harrow || record.registered_in_harrow
    end
  end

  def accept_proposal
    org = becomes!(Organisation)
    org.save!
    org
  end
end

