require 'spec_helper'
describe UsersController do
  describe 'PUT update user-organization status' do
    context 'user requesting pending status to be admin of charity' do
      before(:each) do
        user = double("User")
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
        @nonadmin_user = double("User")
        User.stub(:find_by_id).with("4").and_return(@nonadmin_user)
        @nonadmin_user.stub(:pending_organization_id=).with('5')
        @nonadmin_user.stub(:save!)
      end
      it 'should update the pending organization id to nested org id' do
        User.should_receive(:find_by_id).with("4").and_return(@nonadmin_user)
        @nonadmin_user.should_receive(:pending_organization_id=).with('5')
        @nonadmin_user.should_receive(:save!)
        put :update, id: 4, organization_id: 5
      end
      it 'should redirect to the show page for nested org' do
        put :update, id: 4, organization_id: 5
        expect(response).to redirect_to(organization_path(5))
      end
      it 'should display that a user has requested admin status for nested org' do
        put :update, id: 4, organization_id: 5
        expect(flash[:notice]).to have_content("You have requested admin status for My Organization")
      end
    end
    context 'admin promoting user to charity admin' do
      it 'non-admins get redirected away' do
        pending
        #TODO redirect
      end
      it "calls a model method to add user's organziation and remove user's pending organization" do
        User.should_receive(:promote_to_org_admin).with('4')
        put :update, {:id => '4'}
      end
      it 'reload index page after update succeeds' do
        pending
      end
      it 'shows a flash telling which user got approved' do
        pending
      end
    end
  end
  describe 'GET index to view pending users' do
    before(:each) do
      user = double("User")
      request.env['warden'].stub :authenticate! => user
      user.stub(:admin?).and_return(true)
      controller.stub(:current_user).and_return(user)
      @requester1 = double("User")
      @requester1.stub(:pending_organization_id=).with('5')
      @requester2 = double("User")
      @requester2.stub(:pending_organization_id=).with('6')
    end
    it 'non-admins get redirected away' do
      pending
      #TODO redirect
    end
    it 'assigns @users with all users' do
      User.should_receive(:all).and_return([@requester1, @requester2])
      get :index
      assigns(:users).should == [@requester1, @requester2]
    end
  end
end
