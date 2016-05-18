require 'rails_helper'

describe WithoutTimestamps do

  it 'save model without updating timestamps' do
    org = FactoryGirl.build(:organisation)
    WithoutTimestamps.run do
      org.save
    end
    expect(org.created_at).to eq(nil)
    expect(org.updated_at).to eq(nil)
  end

  it 'update model without updating timestamps' do
    org = FactoryGirl.create(:organisation, name: 'test org')
    org.name = 'new org name'
    expect do
      WithoutTimestamps.run do
      org.save
      end
    end.not_to change{org.updated_at}
  end

end
