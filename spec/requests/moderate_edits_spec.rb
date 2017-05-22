require 'rails_helper'

describe "Proposed Edits Moderation", :type => :request, :helpers => :requests do
  let(:nonsuperadmin) { FactoryGirl.create(:user, superadmin: false) }
  let(:org){FactoryGirl.create(:organisation, name: "Friendly Organisation")}
  let(:proposed_edit){FactoryGirl.create(:proposed_organisation_edit, name: "Different Name", organisation: org)}
  before { login(nonsuperadmin) }
  it 'nonsuperadmin cannot accept edit' do
    expect{
      patch organisation_proposed_organisation_edit_path(proposed_edit.organisation, proposed_edit),
        :proposed_organisation_edit => {name: "Different Name", id: proposed_edit.id}
      org.reload
    }.not_to change{org.name}
  end
end