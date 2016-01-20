require './app/services/create_proposed_organisation_edit'

describe CreateProposedOrganisationEdit do
  subject(:create_proposed_organisation_edit) { described_class.with(listener, params, model_klass, user_klass, mailer_class) }

  let(:model_klass) { spy(:proposed_organisation_edit) }
  let(:user_klass) { double(:user_klass) }
  let(:mailer_class) { double(:mailer_class) }
  let(:listener) { double :listener }
  let(:params) { {} }

  before do
    allow(params).to receive(:[]).with(:editor).and_return editor
  end

  context 'editor is siteadmin' do
    let(:editor) { double :editor, siteadmin?: true }

    it 'creates a proposed organisation edit' do
      create_proposed_organisation_edit
      expect(model_klass).to have_received(:create).with(params)
    end
  end

  context 'editor is not siteadmin' do
    let(:editor) { double :editor, siteadmin?: false }
    let(:organisation) { double :organisation }

    before do
      allow(params).to receive(:[]).with(:organisation).and_return organisation
      allow(listener).to receive_message_chain :flash, :[]=
      allow(described_class).to receive :merge_in_non_published_fields
      allow(user_klass).to receive_message_chain :superadmins, :pluck
      allow(mailer_class).to receive_message_chain :edit_org_waiting_for_approval, :deliver_now
    end

    it 'merges in non published fields' do
      expect(described_class).to receive :merge_in_non_published_fields
      create_proposed_organisation_edit
    end

    it 'sends email to superadmin about org edit' do
      expect(mailer_class).to receive_message_chain :edit_org_waiting_for_approval, :deliver_now
      create_proposed_organisation_edit
    end

    it 'sets the flash notice on the listener' do
      expect(listener).to receive_message_chain :flash, :[]=
      create_proposed_organisation_edit
    end

    it 'creates a proposed organisation edit' do
      create_proposed_organisation_edit
      expect(model_klass).to have_received(:create).with(params)
    end
  end

end
