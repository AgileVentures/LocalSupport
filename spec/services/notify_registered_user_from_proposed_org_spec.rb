require 'rails_helper'

describe  NotifyRegisteredUserFromProposedOrg do

  let(:user){FactoryGirl.create(:user)}
  let(:proposed_org){FactoryGirl.create(:orphan_proposed_organisation).accept_proposal}
  let(:subject){NotifyRegisteredUserFromProposedOrg.new(user, proposed_org).run}

  it 'sends email' do
    expect(->{subject}).to change{ActionMailer::Base.deliveries.size}.by(1)
  end

end