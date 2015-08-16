require 'rails_helper'

describe OrgAdminMailer, :type => :mailer do
  context "new org admin notification" do
    subject { OrgAdminMailer.new_org_admin(double("Organisation", name: 'friendly'), 'orgadmin@friendly.org') }
    it { expect{subject.deliver_now}.to change{ActionMailer::Base.deliveries.length}.by(1) }
    it { expect(subject.subject).to eq "You have been made an organisation administrator on the Harrow Community Network" }
    it { expect(subject.to).to eq ['orgadmin@friendly.org'] }
    it { expect(subject.from).to eq ['support@harrowcn.org.uk'] }
    it { expect(subject.reply_to).to eq ['support@harrowcn.org.uk'] }
    it { expect(subject.cc).to eq ['technical@harrowcn.org.uk'] }
  end
end
