require './app/services/create_proposed_organisation_edit'

describe CreateProposedOrganisationEdit do

  let(:model_klass) { spy(:proposed_organisation_edit) }
  let(:listener) { double :listener }
  let(:params) { double :params }

  context 'editor is siteadmin' do
    let(:editor) { double :editor, siteadmin?: true }

    before do
      allow(params).to receive(:[]).with(:editor).and_return editor
    end

    subject(:create_proposed_organisation_edit) { described_class.with(listener, params, model_klass) }

    it 'creates a proposed organisation edit' do
      create_proposed_organisation_edit
      expect(model_klass).to have_received(:create).with(params)
    end
  end

  context 'editor is not siteadmin' do

  end

end
