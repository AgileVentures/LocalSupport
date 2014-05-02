require 'spec_helper'

describe Page do
  it 'is invalid without a name' do
    FactoryGirl.build(:page, name: nil).should_not be_valid
  end

  it 'is invalid without a permalink' do
    FactoryGirl.build(:page, permalink: nil).should_not be_valid
  end

  it 'is invalid without a UNIQUE permalink' do
    FactoryGirl.create(:page, permalink: 'hello').should be_valid
    FactoryGirl.build(:page, permalink: 'hello').should_not be_valid
  end

  it 'overrides to_param to return the permalink instead of id' do
    page = FactoryGirl.build(:page)
    page.to_param.should eq page.permalink
  end
end
