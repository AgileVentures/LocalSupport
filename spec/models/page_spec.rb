require 'spec_helper'

describe Page do
  it 'should override to_param to return the permalink instead of id' do
    page = FactoryGirl.create(:page)
    page.should_receive(:to_param).and_return('about')
    page.to_param
  end

  describe "#find_page" do
    it 'should call find_by_permalink' do
      Page.should_receive(:find_by_permalink)
      Page.find_page('4')
    end

    it 'if results is nil, it returns custom 404 page' do
      Page.stub(:find_by_permalink).and_return('nil')
      Page.should_receive(:find_by_name).with('404')
      Page.find_page('4')
    end
  end



end
