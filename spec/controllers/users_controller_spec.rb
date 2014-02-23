require 'spec_helper'
describe UsersController do
  describe 'PUT update user-organization status', :helpers => :controllers do
    before(:each) do
      make_current_user_admin
      @nonadmin_user = double("User")
      User.stub(:find_by_id).with("4").and_return(@nonadmin_user)
      @nonadmin_user.stub(:pending_organization_id=).with('5')
      @nonadmin_user.stub(:save!)
      @org = double("Organization")
      @org.stub(:name).and_return('Red Cross')
      Organization.stub(:find).and_return(@org)
    end
    context 'user requesting pending status to be admin of charity' do
      before do 
        @nonadmin_user.stub(:request_admin_status)
        @nonadmin_user.stub(:promote_to_org_admin)
        @nonadmin_user.stub(:email)
      end

      it 'should redirect to the show page for nested org' do
        put :update, id: 4, organization_id: 5
        expect(response).to redirect_to(organization_path(5))
      end
      it 'should display that a user has requested admin status for nested org' do
        put :update, id: 4, organization_id: 5
        expect(flash[:notice]).to have_content("You have requested admin status for #{@org.name}")
      end
    end
    context 'admin promoting user to charity admin' do
      before(:each) do
        @nonadmin_user.stub(:promote_to_org_admin)
        @nonadmin_user.stub(:email).and_return('stuff@stuff.com')
      end
      it 'non-admins get refused' do
        @nonadmin_user.stub(:admin?).and_return(false)
        controller.stub(:current_user).and_return(@nonadmin_user)
        put :update, {:id => '4'}
        response.response_code.should == 404
      end

      it 'redirect to index page after update succeeds' do
        put :update, {:id => '4'}
        response.should redirect_to users_path
      end
      it 'shows a flash telling which user got approved' do
        put :update, {:id => '4'}
        expect(flash[:notice]).to have_content("You have approved #{@nonadmin_user.email}.")
      end
    end
  end

  describe 'GET index to view pending users' do
    before(:each) do
      @user = double("User")
    end

    context "user signed in" do
      before(:each) do
        controller.stub(:current_user).and_return(@user)
      end

      context "as admin" do
        before(:each) do
          @user.stub(:admin?).and_return(true)
        end

        it "assigns all users to @users" do
          user_double = double("User")
          User.stub(:all).and_return([user_double])
          get :index
          expect(assigns(:users)).to eql([user_double])
        end

        it "renders the index template" do
          get :index
          expect(response).to render_template('index')
        end

        it "renders in full width" do
          get :index
          expect(response).to render_template('layouts/full_width')
        end
      end

      context "as non-admin" do
        before(:each) do
          @user.stub(:admin?).and_return(false)
        end

        it "redirects user to root and flashes a notice" do
          get :index
          response.should redirect_to root_path
        end

        it "flashes the relevant notice" do
          get :index
          expect(flash[:error]).to have_content("You must be signed in as an admin to perform this action!")
        end
      end
    end

    context "user not signed in" do
      before(:each) do
        controller.stub(:current_user).and_return(nil)
      end

      it "redirects user to root" do
        get :index
        response.should redirect_to root_path
      end

      it "flashes the relevant notice" do
        get :index
        expect(flash[:error]).to have_content("You must be signed in as an admin to perform this action!")
      end

    end
  end
end
