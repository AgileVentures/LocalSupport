require './app/services/create_proposed_organisation_edit'

describe CreateProposedOrganisationEdit do
  subject(:create_proposed_organisation_edit) { described_class.with(listener, params, model_klass, user_klass, mailer_class) }

  let(:model_klass) { spy(:proposed_organisation_edit) }
  let(:user_klass) { double(:user_klass) }
  let(:mailer_class) { double(:mailer_class) }
  let(:listener) { spy :listener }
  let(:organisation) { double :organisation }
  let(:params) { { editor: editor, organisation: organisation } }

  context 'editor is siteadmin' do
    let(:editor) { double :editor, siteadmin?: true }

    it 'creates a proposed organisation edit' do
      create_proposed_organisation_edit
      expect(model_klass).to have_received(:create).with(params)
    end
  end

  context 'editor is not siteadmin' do
    let(:editor) { double :editor, siteadmin?: false }
    let(:mail) { double :mail }

    before do
      allow(listener).to receive_message_chain :flash, :[]=
      allow_any_instance_of(described_class).to receive :merge_in_non_published_fields
      allow(user_klass).to receive_message_chain(:superadmins, :pluck).and_return(:admins)
      allow(mailer_class).to receive_message_chain :edit_org_waiting_for_approval, :deliver_now
    end

    it 'merges in non published fields' do
      expect_any_instance_of(described_class).to receive :merge_in_non_published_fields
      create_proposed_organisation_edit
    end

    it 'sends email to superadmin about org edit' do
      expect(mail).to receive(:deliver_now)
      expect(mailer_class).to receive(:edit_org_waiting_for_approval).with(organisation, :admins).and_return(mail)
      create_proposed_organisation_edit
    end

    it 'sets the flash notice on the listener' do
      create_proposed_organisation_edit
      expect(listener).to have_received(:set_notice).with('Edit is pending admin approval.')
    end

    it 'creates a proposed organisation edit' do
      create_proposed_organisation_edit
      expect(model_klass).to have_received(:create).with(params)
    end
  end

end
