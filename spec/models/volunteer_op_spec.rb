require 'rails_helper'

describe VolunteerOp, :type => :model do
  it 'must have a title' do
    v = VolunteerOp.new(title:'')
    v.valid?
    expect(v.errors[:title].size).to eq(1)
  end

  it 'must have a description' do
    v = VolunteerOp.new(description:'')
    v.valid?
    expect(v.errors[:description].size).to eq(1)
  end

  it 'must not be created without an organisation' do
    v = VolunteerOp.new(organisation_id:nil)
    v.valid?
    expect(v.errors[:organisation_id].size).to eq(1)
  end

  describe '#local_only' do
    let(:organisation){FactoryGirl.create(:organisation)}
    let(:first_local){FactoryGirl.create(:local_volunteer_op, organisation: organisation)}
    let(:second_local){FactoryGirl.create(:local_volunteer_op, organisation: organisation)}
    let(:first_doit){FactoryGirl.create(:doit_volunteer_op, organisation: organisation)}
    let(:second_doit){FactoryGirl.create(:doit_volunteer_op, organisation: organisation)}

    it 'must contain local ops' do
      expect(VolunteerOp.local_only).to include(first_doit,second_doit)
    end
    it 'must contain only local ops' do
      expect(VolunteerOp.local_only).not_to include(first_doit, second_doit)
    end
  end
end
