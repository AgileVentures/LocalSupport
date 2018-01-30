require 'rails_helper'

describe ::NewsletterEventsJob do
  it 'should create a campaign'

  it 'should collect all events' do
    FactoryBot.create_list(:organisation, 2)
    FactoryBot.create(:event, organisation: Organisation.first)
    FactoryBot.create(
        :event,
        start_date: Date.today - 4,
        organisation: Organisation.last
    )
    data = []
    Event.where('start_date >= ?', Date.today).each do |event|
      data << {
          id: event.id,
          title: event.title,
          start_date: event.start_date,
          end_date: event.end_date
      }
    end
    expect(data).to eq(NewsletterEventsJob.events)
    expect(NewsletterEventsJob.events.count).to eq(1)
    expect(Event.count).to eq(2)
  end

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