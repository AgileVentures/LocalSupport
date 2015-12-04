require 'rails_helper'
require_relative '../../app/services/user_organisation_decliner'

describe UserOrganisationDecliner,'#call'  do
  let(:listener) {double :listener}
  let(:pending_org) {FactoryGirl.create(:organisation)}
  let(:user) {FactoryGirl.create(:user, pending_organisation: pending_org)}
  let(:current_user) {FactoryGirl.create(:user, superadmin: true)}

  let(:service) {UserOrganisationDecliner.new(listener, user, current_user)}

  it "deletes the pending organisation from the user" do
    allow(listener).to receive(:update_message_for_decline_success)
    expect(user.pending_organisation).not_to be_nil
    service.call
    expect(user.pending_organisation).to be_nil
  end

  it "calls update_message_for_decline_success" do
    expect(listener).to receive(:update_message_for_decline_success).with(user, pending_org)
    service.call
  end

  context "non-superadmin" do
    let(:current_user) {FactoryGirl.create(:user, superadmin: false)}
    it "does not remove the pending org if called by non-superadmin" do
      allow(listener).to receive(:authorization_failure_for_update)
      expect(user.pending_organisation).not_to be_nil
      service.call
      expect(user.pending_organisation).not_to be_nil
    end

    it "calls authorization_failure_for_update" do
      expect(listener).to receive(:authorization_failure_for_update)
      service.call
    end
  end
end
