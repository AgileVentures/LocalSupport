require 'spec_helper'

describe Invitations::Inviter::DeviseInviteResender do
  it 'passes the boolean to Devise#resend_invitation=' do
    expect(Devise).to receive(:resend_invitation=).with(true)
    described_class.('true')
    expect(Devise).to receive(:resend_invitation=).with(false)
    described_class.('false')
  end
end

describe Invitations::Inviter::DeviseUserInviter, 'resending invitations' do
  let(:invited_by) do
    FactoryGirl.create :user, {
        email: 'admin@example.com',
        admin: true
    }
  end

  let(:org) do
    FactoryGirl.build :organization, {
        email: 'EMAIL@charity.org'
    }
  end

  let(:params) { {organization_id: org.id, email: org.email} }

  subject { ->{described_class.(params, invited_by)} }

  it 'resending invitations can be shut off' do
    Devise.resend_invitation = true
    subject.call
    expect(ActionMailer::Base.deliveries).to_not be_empty
    ActionMailer::Base.deliveries.clear

    subject.call
    expect(ActionMailer::Base.deliveries).to_not be_empty
    ActionMailer::Base.deliveries.clear

    Devise.resend_invitation = false
    subject.call
    expect(ActionMailer::Base.deliveries).to be_empty
  end
end