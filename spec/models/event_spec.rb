require 'rails_helper'

RSpec.describe Event, type: :model do
  subject do
    described_class.new(title: 'My Title', description: 'My description',
                        start_date: Time.zone.now, end_date: Time.zone.now + 1.week)
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

    before(:all) do
      FactoryGirl.create_list(:upcoming_events, 10)
    end

    it 'should have a valid upcoming method' do
      expect { Event.upcoming(10) }.not_to raise_error
    end

    it 'should return a variable number of upcoming events' do
      expect(Event.upcoming(10).length).to eq 10
    end

    xit 'should not include events that are already over' do
      FactoryGirl.create_list(:previous_events, 10)
      expect(Event.upcoming(20).length).to eq 10
    end

    xit 'should only contain events that are after the current datetime' do
      expect(Event.upcoming(20)).to all (have_attributes(start_date: (a_value > DateTime.current)))
    end

  end

end
