require 'rails_helper'

describe CustomDeviseMailer, :type => :mailer do
  context "proposed org approved" do
    let(:proposed_org){FactoryGirl.create(:orphan_proposed_organisation)}
    let(:email){"unregistered@email.com"}
    let(:user){FactoryGirl.create(:user)}
    subject { CustomDeviseMailer.proposed_org_approved(proposed_org,email,user) }

    it { expect(subject.subject).to eq "Your organisation has been approved for inclusion in the Harrow Community Network!"}
    it { expect(subject.to).to eq [email] }
    it { expect(subject.from).to eq ['support@harrowcn.org.uk'] }
    it { expect(subject.reply_to).to eq ['support@harrowcn.org.uk'] }
    it { expect(subject.cc).to eq ['technical@harrowcn.org.uk'] }
  end
end