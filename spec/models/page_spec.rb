require 'spec_helper'

describe Page do
  before :each do
    @page = FactoryGirl.create(:page)   
  end
  it 'should override to_param to return the permalink instead of id' do
    @page.should_receive(:to_param).and_return('about')
    @page.to_param
  end
  it 'has a link_visible attribute that can be set' do
    @page.link_visible = true
    @page.link_visible.should eq true
  end
  it 'has a link_visible attribute that can be cleared' do
    @page.link_visible = false
    @page.link_visible.should eq false
  end
  describe 'self.create!' do
    it 'can set the link_visible attribute' do
      pg = Page.create!({"name" => "MyString", "permalink" => "my_link", :link_visible => false })
      pg.reload.link_visible.should eq false
    end
  end
end

