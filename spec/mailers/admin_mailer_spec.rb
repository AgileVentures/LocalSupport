require 'spec_helper'

describe AdminMailer do
  subject{AdminMailer.new_user_waiting_for_approval('friendly', 'admin@admin.org')}

  it{ expect{subject.deliver}.to change{ActionMailer::Base.deliveries.length}.by(1)}
  its(:subject) { should == "There is a User Waiting for Admin Approval to 'friendly'" }
  its(:to) { should == ['admin@admin.org'] }
  its(:from) { should == ['support@harrowcn.org.uk'] }
  its(:reply_to) { should == ['support@harrowcn.org.uk'] }
  its(:cc) { should == ['technical@harrowcn.org.uk'] }

end