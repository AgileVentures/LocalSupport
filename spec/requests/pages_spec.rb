require 'rails_helper'

describe 'Pages', :type => :request, :helpers => :requests do

  let(:page) { FactoryGirl.create :page}
  let(:superadmin_user) { FactoryGirl.create :user, :superadmin => true}

  before {login(superadmin_user)}

  describe 'PUT update' do
    describe 'link_visible support' do
      it 'sets the link_visible flag' do
        page.link_visible = false
        page.save
        patch page_path(page.to_param), :page => {:link_visible => true}
        expect(page.reload.link_visible).to be true
      end
      it 'clears the link_visible flag' do
        patch page_path(page.to_param), :page => {:link_visible => false}
        expect(page.reload.link_visible).to be false
      end
    end
  end
end
