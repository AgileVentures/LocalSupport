require 'spec_helper'
describe UsersController do
  describe 'PUT update' do
    context 'when signed in as non-admin' do
      before(:each) do
        user = double("User")
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
      end
      it 'should update the pending organization id to nested org id' do
        nonadmin_user = double("User")
        User.should_receive(:find_by_id).with("4").and_return(nonadmin_user)
        nonadmin_user.should_receive(:pending_organization_id=).with('5')
        nonadmin_user.should_receive(:save!)
        put :update, id: 4, organization_id: 5
      end
      it 'should redirect to the show page for nested org' do
        nonadmin_user = double("User")
        User.stub(:find_by_id).with("4").and_return(nonadmin_user)
        nonadmin_user.stub(:pending_organization_id=).with('5')
        nonadmin_user.stub(:save!)
        put :update, id: 4, organization_id: 5
        expect(response).to redirect_to(organization_path(5))
      end
    end
  end
end
