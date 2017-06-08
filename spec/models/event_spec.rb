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

  describe "scopes" do

    before(:all) do
      FactoryGirl.create_list(:upcoming_events, 10)
    end
    
    it "should have a valid upcoming method" do
      expect { Event.upcoming(10) }.not_to raise_error
    end

    it "should return a variable number of upcoming events" do
      expect(Event.upcoming(10).length).to eq 10
    end

   it "should not include events that are already over" do
     FactoryGirl.create_list(:previous_events, 10)
     expect(Event.upcoming(20).length).to eq 10
   end

   it "should only contain events that are after the current datetime" do
     expect(Event.upcoming(20)).to all (have_attributes(:start_date => (a_value > DateTime.now())))
   end

  end

end
