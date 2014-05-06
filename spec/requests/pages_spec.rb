require 'spec_helper'

describe 'Pages', :helpers => :requests do

  let(:valid_attributes) { { "name" => "MyString", "permalink" => "about"} }
  let(:admin_user) { FactoryGirl.create :user, :admin => true}

  before {login(admin_user)}

  describe 'PUT update' do
    describe 'link_visible support' do
      it 'sets the link_visible flag' do
        valid_attributes[:link_visible] = false
        page = Page.create! valid_attributes 
        page.reload.link_visible.should eq false
        put page_path(page.to_param), :page => {:link_visible => true}
        page.reload.link_visible.should eq true
      end
      it 'clears the link_visible flag' do
        valid_attributes[:link_visible] = true
        page = Page.create! valid_attributes 
        page.reload.link_visible.should eq true
        put page_path(page.to_param), :page => {:link_visible => false}
        page.reload.link_visible.should eq false
      end
    end
  end
end
