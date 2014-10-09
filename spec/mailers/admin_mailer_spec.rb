require 'spec_helper'

describe AdminMailer do
  subject{AdminMailer.new_user_waiting_for_approval('friendly', 'admin@admin.org')}
  it{ expect{subject.deliver}.to change{ActionMailer::Base.deliveries.length}.by(1)}
  its(:subject) { should == "There is a user waiting for Admin approval to 'friendly'." }
  its(:to) { should == ['admin@admin.org'] }
  its(:from) { should == ['support@harrowcn.org.uk'] }
  its(:reply_to) { should == ['support@harrowcn.org.uk'] }
  its(:cc) { should == ['technical@harrowcn.org.uk'] }

  context "new user sign up notification" do
    subject{AdminMailer.new_user_sign_up("user@charity.org",["admin@harrowcn.org.uk", "admin2@harrowcn.org.uk"])}
    it{ expect{subject.deliver}.to change{ActionMailer::Base.deliveries.length}.by(1)}
    its(:to) { should == ['admin@harrowcn.org.uk', 'admin2@harrowcn.org.uk'] }
    its(:from) { should == ['support@harrowcn.org.uk'] }
    its(:reply_to) { should == ['support@harrowcn.org.uk'] }
    its(:cc) { should == ['technical@harrowcn.org.uk'] }
  end
end
