require 'spec_helper'

describe VolunteerOp do
  it 'must have a title' do
    v = VolunteerOp.new(title:'')
    expect(v).to have(1).errors_on(:title)
  end

  it 'must have a description' do
    v = VolunteerOp.new(description:'')
    expect(v).to have(1).errors_on(:description)
  end

  it 'must not be created without an organisation' do
    v = VolunteerOp.new(organisation_id:nil)
    expect(v).to have(1).error_on(:organisation_id)
  end
end