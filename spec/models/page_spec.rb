require 'rails_helper'

describe Page, :type => :model do
  context 'single page examples' do
    before :each do
      @page = FactoryGirl.create(:page)   
    end
    it 'should override to_param to return the permalink instead of id' do
      expect(@page).to receive(:to_param).and_return('about')
      @page.to_param
    end
    it 'has a link_visible attribute that can be set' do
      @page.link_visible = true
      expect(@page.link_visible).to eq true
    end
    it 'has a link_visible attribute that can be cleared' do
      @page.link_visible = false
      expect(@page.link_visible).to eq false
    end
  end
  describe '::create!' do
    it 'can set the link_visible attribute to be false' do
      unlinked_page = Page.create!(:name => 'MyString', 
                                   :permalink => 'my_link',
                                   :link_visible => false)
      expect(unlinked_page.reload.link_visible).to eq false
    end
  end
  ####################################################################
  context 'multiple page examples' do
    before :each do
      @linked_page = FactoryGirl.create(:page)
      @second_linked_page = FactoryGirl.create(:page,
                                               :name => 'An interesting page',
                                               :permalink => 'interesting')
      @unlinked_page = FactoryGirl.create(:page,
                                          :name => 'A boring page',
                                          :permalink => 'bore',
                                          :link_visible => false)
    end
    
    describe '::visible_links' do
      it 'returns a collection of links to the pages that have visible links' do
        
        expect(Page.visible_links).to eq \
          [{:name => 'About Us', :permalink => 'about'},
           {:name => 'An interesting page', :permalink => 'interesting'}]
      end
    end
  end
  #####################################################################
  describe 'validations' do
    it 'is invalid without a name' do
      expect(FactoryGirl.build(:page, name: nil)).not_to be_valid
    end

    it 'is invalid without a permalink' do
      expect(FactoryGirl.build(:page, permalink: nil)).not_to be_valid
    end

    it 'is invalid without a UNIQUE permalink' do
      expect(FactoryGirl.create(:page, permalink: 'hello')).to be_valid
      expect(FactoryGirl.build(:page, permalink: 'hello')).not_to be_valid
    end

    it 'overrides to_param to return the permalink instead of id' do
      page = FactoryGirl.build(:page)
      expect(page.to_param).to eq page.permalink
    end
  end
end
