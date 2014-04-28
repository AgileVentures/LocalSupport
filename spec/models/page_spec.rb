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
  describe '::create!' do
    it 'can set the link_visible attribute to be false' do
      unlinked_page = Page.create!({"name" => "MyString", "permalink" => "my_link", :link_visible => false })
      unlinked_page.reload.link_visible.should eq false
    end
  end
  describe '::visible_links' do
    it 'returns a collection of links to the pages that have visible links' do
      # first_linked_page = stub_model(Page,
      #                                :name => "About us",
      #                                :permalink => "about",
      #                                :link_visible => true)
      # second_linked_page = stub_model(Page,
      #                                 :name => "An interesting page",
      #                                 :permalink => "interesting",
      #                                 :link_visible => true)
      #
      # unlinked_page = stub_model(Page,
      #                            :name => "A boring page",
      #                            :permalink => nil,
      #                            :link_visible => false)
      expect(Page.visible_links).to eq [{:name => "About Us",
                                          :permalink => "about"}]
    end
  end
end

