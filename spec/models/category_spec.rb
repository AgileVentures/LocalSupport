require 'spec_helper'

describe 'Category' do

  it 'should have a human readable name and charity commission id and ridiculous name' do
    c = Category.new(:name => "Health",:charity_commission_id => 1, :charity_commission_name => "WELL BEING AND JOYOUS EXISTENCE")
    expect(c.name).to eq("Health")
    expect(c.charity_commission_id).to eq(1)
    expect(c.charity_commission_name).to eq("WELL BEING AND JOYOUS EXISTENCE")
  end
end