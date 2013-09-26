require 'spec_helper'

describe Page do
  it 'should override to_param to return the permalink instead of id' do
    page = FactoryGirl.create(:page)
    page.should_receive(:to_param).and_return('about')
    page.to_param
  end
end
