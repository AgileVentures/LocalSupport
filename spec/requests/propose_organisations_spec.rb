require 'rails_helper'

describe "Moderate a proposed org", :type => :request, :helpers => :requests do
  let(:nonsuperadmin) { FactoryGirl.create(:user, superadmin: false) }
  let!(:proposed_org){FactoryGirl.create(:proposed_organisation)}
  before { login(nonsuperadmin) }

  it 'does not act upon non superadmins requests' do
    expect{patch(proposed_organisation_path(proposed_org),
                 :proposed_organisation => {action: "accept"})}.not_to change(ProposedOrganisation, :count)

  end
end
