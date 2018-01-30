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
    events = Event.where('start_date >= ?', Date.today).reduce([]) do |data, event|
      data << NewsletterEventsJob.format_event(event)
    end
    expect(events).to eq(NewsletterEventsJob.events)
    expect(NewsletterEventsJob.events.count).to eq(1)
    expect(Event.count).to eq(2)
  end

  it 'should format the event properly' do
    organisation = FactoryBot.create(:organisation)
    event = FactoryBot.create(:event, organisation: organisation)
    formatted_event = NewsletterEventsJob.format_event(event)
    expect(formatted_event.keys).to eq([:title, :date, :url])
    expect(formatted_event).to be_a_kind_of(Hash)
  end

  it 'should update the email list on MailChimp if necessary'

  it 'should collect all Organisation emails' do
    FactoryBot.create_list(:organisation, 20)
    FactoryBot.create(:organisation, email: '')
    emails = Organisation.pluck(:email, :name).reduce([]) do |data, org|
      data << { org[0] => org[1] } unless org[0].empty?
      data
    end
    expect(emails).to eq(NewsletterEventsJob.organisation_emails)
    expect(NewsletterEventsJob.organisation_emails.count).to eq(20)
    expect(Organisation.count).to eq(21)
  end
end