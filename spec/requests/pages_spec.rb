require 'spec_helper'

describe 'Pages', :helpers => :requests do

  let(:page) { FactoryGirl.create :page}
  let(:admin_user) { FactoryGirl.create :user, :admin => true}

  before {login(admin_user)}

  describe 'PUT update' do
    describe 'link_visible support' do
      it 'sets the link_visible flag' do
        page.link_visible = false
        page.save
        put page_path(page.to_param), :page => {:link_visible => true}
        expect(page.reload.link_visible).to be true
      end
      it 'clears the link_visible flag' do
        put page_path(page.to_param), :page => {:link_visible => false}
        expect(page.reload.link_visible).to be false
      end
    end
  end
end
