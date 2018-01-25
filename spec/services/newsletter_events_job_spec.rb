require 'rails_helper'

describe ::NewsletterEventsJob do
  it 'should create a campaign'

  it 'should collect all events'

  it 'should update the email list on MailChimp if necessary'

  it 'should collect all Organisation emails' do
    FactoryBot.create_list(:organisation, 20)
    FactoryBot.create(:organisation, email: '')
    emails = []
    Organisation.pluck(:email, :name).each do |email, name|
      emails << { email => name } unless email.empty?
    end
    expect(emails).to eq(NewsletterEventsJob.organisation_emails)
    expect(NewsletterEventsJob.organisation_emails.count).to eq(20)
    expect(Organisation.count).to eq(21)
  end
end