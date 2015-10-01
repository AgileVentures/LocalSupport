require 'rails_helper'

describe InviteUnregisteredUserFromProposedOrg do

  context 'successful invite' do

    let(:unregistered_email){"unregistered@email.com"}
    let(:proposed_org){FactoryGirl.create(:proposed_organisation)}
    let(:subject){InviteUnregisteredUserFromProposedOrg.new(unregistered_email,proposed_org).run}

    it 'sends an email' do
      pending
    end

  end

end
