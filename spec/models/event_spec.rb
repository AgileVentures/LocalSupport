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
    
    it "should have a valid upcoming method" do
      expect { Event.upcoming }.not_to raise_error
    end

  end

end
