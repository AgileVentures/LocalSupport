require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:subject){ FactoryBot.create :event }

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

end
