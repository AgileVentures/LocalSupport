require 'spec_helper'

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
end
