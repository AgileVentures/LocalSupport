# http://blog.lucascaton.com.br/index.php/2010/10/25/how-to-test-mailers-in-rails-3-with-rspec/

require 'spec_helper'

describe CustomDeviseMailer do
  describe 'instructions' do
    #let(:user) { mock_model User, name: 'Lucas', email: 'lucas@email.com' }
    let(:mail) { CustomDeviseMailer.new }

    it 'renders the subject' do
      mail.subject.should == 'Invitation to Harrow Community Network'
    end

    #it 'renders the receiver email' do
    #  mail.to.should == [user.email]
    #end
    #
    #it 'renders the sender email' do
    #  mail.from.should == ['noreply@empresa.com']
    #end
    #
    #it 'assigns @name' do
    #  mail.body.encoded.should match(user.name)
    #end
    #
    #it 'assigns @confirmation_url' do
    #  mail.body.encoded.should match("http://aplication_url/#{user.id}/confirmation")
    #end
  end
end