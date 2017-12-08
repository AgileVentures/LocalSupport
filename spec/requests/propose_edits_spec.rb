require 'rails_helper'

describe 'Propose an edit', type: :request, helpers: :requests do
  let(:nonsuperadmin) { FactoryBot.create(:user, superadmin: false) }
  let(:org) {
    FactoryBot.create(
        :organisation,
        name: 'Friendly Organisation',
        address: '34 pinner road',
        telephone: '202',
        email: 'blah@blah.org',
        publish_email: false
    )
  }
  let(:proposed_edit){ FactoryBot.build(:proposed_organisation_edit, organisation: org) }
  before { login(nonsuperadmin) }

  it 'non-published fields are copied into proposed org edit' do
    expect(ProposedOrganisationEdit.still_pending).to be_empty
    post organisation_proposed_organisation_edits_path(proposed_edit.organisation),
      params: {proposed_organisation_edit: {name: 'Different Name'}}
    edit = ProposedOrganisationEdit.still_pending.reorder(updated_at: :desc).first
    expect(edit.address).to eq '34 pinner road'
    expect(edit.telephone).to eq '202'
    expect(edit.email).to eq 'blah@blah.org'
  end
end