require 'rails_helper'

describe AdminMailer, :type => :mailer do
  subject { AdminMailer.new_user_waiting_for_approval('friendly', 'superadmin@superadmin.org') }
  it { expect{subject.deliver_now}.to change{ActionMailer::Base.deliveries.length}.by(1) }
  it { expect(subject.subject).to eq "There is a user waiting for Admin approval to 'friendly'." }
  it { expect(subject.to).to eq ['superadmin@superadmin.org'] }
  it { expect(subject.from).to eq ['support@harrowcn.org.uk'] }
  it { expect(subject.reply_to).to eq ['support@harrowcn.org.uk'] }
  it { expect(subject.cc).to eq ['technical@harrowcn.org.uk'] }

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
end
