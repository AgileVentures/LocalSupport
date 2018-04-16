require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:subject){ FactoryBot.create :event }

  describe 'Event with organisation or default coordinates' do
    def event
      grouped_events_by_coordinates  = Event.build_by_coordinates([subject])
      key = grouped_events_by_coordinates.keys.first
      grouped_events_by_coordinates[key].first
    end
    
    it 'should have event coordinates' do
      subject.address = '34 pinner road'
      expect(event.latitude).to eq(40.7143528)
      expect(event.longitude).to eq(-74.0059731)
    end

    it 'should have organisation coordinates' do
      expect(event.latitude).to eq(subject.organisation.latitude)
      expect(event.longitude).to eq(subject.organisation.longitude)
    end

    it 'should have default coordinates' do
      subject.organisation = nil
      subject.save!
      expect(event.latitude).to eq(0.0)
      expect(event.longitude).to eq(0.0)
    end
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a title' do
    subject.title = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without a description' do
    subject.description = nil
    expect(subject).to_not be_valid
  end

  it 'must not be created without an organisation' do
    expect(subject.organisation.class).to eq Organisation
  end

  it 'is not valid without a start_date' do
    subject.start_date = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without a end_date' do
    subject.end_date = nil
    expect(subject).to_not be_valid
  end

  it 'can be  an all day event' do
    subject.start_date = Time.zone.now.midnight
    subject.end_date = 1.day.from_now.midnight
    expect(subject.all_day_event?).to be true
  end

  it 'can be an all day event' do
    subject.start_date = 2.hours.ago
    expect(subject.all_day_event?).to be false
  end

  describe 'scopes' do
    let(:events){ FactoryBot.create_list(:upcoming_events, 10) }

    it 'should have a valid upcoming method' do
      expect { Event.upcoming(10) }.not_to raise_error
    end

    it 'should return a variable number of upcoming events' do
      expect(events.length).to eq 10
    end

    it 'should not include events that are already over' do
      FactoryBot.create_list(:previous_events, 10)
      FactoryBot.create_list(:upcoming_events, 10)
      expect(Event.upcoming(20).length).to eq 10
    end

    it 'should only contain events that are after the current datetime' do
      expect(Event.upcoming(20)).to all (have_attributes(start_date: (a_value > DateTime.current)))
    end
  end

  describe 'search' do
    before(:each) do
      FactoryBot.create(:event, title: 'New first title')
      FactoryBot.create(:event, description: 'New description')
    end

    it 'should return an empty array' do
      expect(Event.search('nisevi').empty?).to be true
    end

    it 'should return the correct register' do
      expect(Event.search('New first title').count).to eq(1)
      expect(Event.search('New first title').first.title).to eq('New first title')
      expect(Event.search('New description').first.description).to eq('New description')
    end
  end
end
