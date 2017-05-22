require 'rails_helper'

describe AdminMailer, :type => :mailer do
  context "new user sign up notification" do
    subject { AdminMailer.new_user_waiting_for_approval('friendly', 'superadmin@superadmin.org') }
    it { expect{subject.deliver_now}.to change{ActionMailer::Base.deliveries.length}.by(1) }
    it { expect(subject.subject).to eq "There is a user waiting for Admin approval to 'friendly'." }
    it { expect(subject.to).to eq ['superadmin@superadmin.org'] }
    it { expect(subject.from).to eq ['support@harrowcn.org.uk'] }
    it { expect(subject.reply_to).to eq ['support@harrowcn.org.uk'] }
    it { expect(subject.cc).to eq ['technical@harrowcn.org.uk'] }
  end

  context "new user sign up notification" do
    subject do
      AdminMailer.new_user_sign_up(
        "user@charity.org", ["superadmin@harrowcn.org.uk", "superadmin2@harrowcn.org.uk"]
      )
    end
    it { expect{subject.deliver_now}.to change{ActionMailer::Base.deliveries.length}.by(1) }
    it { expect(subject.to).to eq ['superadmin@harrowcn.org.uk', 'superadmin2@harrowcn.org.uk'] }
    it { expect(subject.from).to eq ['support@harrowcn.org.uk'] }
    it { expect(subject.reply_to).to eq ['support@harrowcn.org.uk'] }
    it { expect(subject.cc).to eq ['technical@harrowcn.org.uk'] }
  end

  context "new proposed org notification" do
    subject { AdminMailer.new_org_waiting_for_approval(double("Organisation", name: 'friendly'), 'superadmin@superadmin.org') }
    it { expect{subject.deliver_now}.to change{ActionMailer::Base.deliveries.length}.by(1) }
    it { expect(subject.subject).to eq "A new organisation has been proposed for inclusion in Harrow Community Network" }
    it { expect(subject.to).to eq ['superadmin@superadmin.org'] }
    it { expect(subject.from).to eq ['support@harrowcn.org.uk'] }
    it { expect(subject.reply_to).to eq ['support@harrowcn.org.uk'] }
    it { expect(subject.cc).to eq ['technical@harrowcn.org.uk'] }
  end

  context "proposed org edit notification" do
    subject { AdminMailer.edit_org_waiting_for_approval(double("Organisation", name: 'friendly'), 'superadmin@superadmin.org') }
    it { expect{subject.deliver_now}.to change{ActionMailer::Base.deliveries.length}.by(1) }
    it { expect(subject.subject).to eq "An edit to 'friendly' is awaiting Admin approval." }
    it { expect(subject.to).to eq ['superadmin@superadmin.org'] }
    it { expect(subject.from).to eq ['support@harrowcn.org.uk'] }
    it { expect(subject.reply_to).to eq ['support@harrowcn.org.uk'] }
    it { expect(subject.cc).to eq ['technical@harrowcn.org.uk'] }
  end

end
