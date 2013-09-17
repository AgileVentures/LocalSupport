require 'spec_helper'

describe EmailHelper do

  it 'sends emails' do
    ActionMailer::Base.deliveries.size.should eql 0
    send_email recipient: "sample@domain.org", subject: "test", message: "test"
    ActionMailer::Base.deliveries.size.should eql 1
  end
  
end
