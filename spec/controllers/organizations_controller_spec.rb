require 'spec_helper'

describe OrganizationsController do
  let(:category_html_options) { [['cat1', 1], ['cat2', 2]] }
  let(:organization) { mock_model('Organization') }

  describe "GET search" do
    context 'setting appropriate view vars for all combinations of input' do
      let(:result) { [organization] }
      let(:category) { double('Category') }
      before(:each) do
        result.stub_chain(:page, :per).and_return(result)
        Category.should_receive(:html_drop_down_options).and_return(category_html_options)
      end

      it "orders search results by most recent" do
        Organization.should_receive(:order_by_most_recent).and_return(result)
        result.stub_chain(:search_by_keyword, :filter_by_category).with('test').with(nil).and_return(result)
        get :search, :q => 'test'
      end

      it "sets up appropriate values for view vars: query_term, organizations" do
        Organization.should_receive(:search_by_keyword).with('test').and_return(result)
        result.should_receive(:filter_by_category).with('1').and_return(result)
        Category.should_receive(:find_by_id).with("1").and_return(category)
        get :search, :q => 'test', "category" => {"id"=>"1"}
        assigns(:query_term).should eq 'test'
        assigns(:category).should eq category
      end

      it "handles lack of category gracefully" do
        Organization.should_receive(:search_by_keyword).with('test').and_return(result)
        result.should_receive(:filter_by_category).with(nil).and_return(result)
        get :search, :q => 'test'
        assigns(:query_term).should eq 'test'
      end

      it "handles lack of query term gracefully" do
        Organization.should_receive(:search_by_keyword).with(nil).and_return(result)
        result.should_receive(:filter_by_category).with(nil).and_return(result)
        get :search
        assigns(:query_term).should eq nil
      end

      it "handles lack of id gracefully" do
        Organization.should_receive(:search_by_keyword).with('test').and_return(result)
        result.should_receive(:filter_by_category).with(nil).and_return(result)
        get :search, :q => 'test', "category" => nil
        assigns(:query_term).should eq 'test'
      end

      it "handles empty string id gracefully" do
        Organization.should_receive(:search_by_keyword).with('test').and_return(result)
        result.should_receive(:filter_by_category).with("").and_return(result)
        get :search, :q => 'test', "category" =>  {"id"=>""}
        assigns(:query_term).should eq 'test'
      end

      after(:each) do
        response.should render_template 'index'
        response.should render_template 'layouts/two_columns'
        assigns(:organizations).should eq result
        assigns(:category_options).should eq category_html_options
      end
    end
    # TODO figure out how to make this less messy
    it "assigns to flash.now but not flash when search returns no results" do
      double_now_flash = double("FlashHash")
      result = []
      result.should_receive(:empty?).and_return(true)
      result.stub_chain(:page, :per).and_return(result)
      Organization.should_receive(:search_by_keyword).with('no results').and_return(result)
      result.should_receive(:filter_by_category).with('1').and_return(result)
      category = double('Category')
      Category.should_receive(:find_by_id).with("1").and_return(category)
      ActionDispatch::Flash::FlashHash.any_instance.should_receive(:now).and_return double_now_flash
      ActionDispatch::Flash::FlashHash.any_instance.should_not_receive(:[]=)
      double_now_flash.should_receive(:[]=).with(:alert, SEARCH_NOT_FOUND)
      get :search , :q => 'no results' , "category" => {"id"=>"1"}
    end

    it "does not set up flash nor flash.now when search returns results" do
      result = [organization]
      result.should_receive(:empty?).and_return(false)
      result.stub_chain(:page, :per).and_return(result)
      Organization.should_receive(:search_by_keyword).with('some results').and_return(result)
      result.should_receive(:filter_by_category).with('1').and_return(result)
      category = double('Category')
      Category.should_receive(:find_by_id).with("1").and_return(category)
      get :search , :q => 'some results'  , "category" => {"id"=>"1"}
      expect(flash.now[:alert]).to be_nil
      expect(flash[:alert]).to be_nil
    end
  end

  describe "GET index" do
    it "assigns all organizations as @organizations" do
      result = [organization]
      Category.should_receive(:html_drop_down_options).and_return(category_html_options)
      Organization.should_receive(:order_by_most_recent).and_return(result)
      result.stub_chain(:page, :per).and_return(result)
      get :index
      assigns(:organizations).should eq(result)
      response.should render_template 'layouts/two_columns'
    end
  end

  describe "GET show" do
    before(:each) do
      @user = double("User")
      Organization.stub(:find).with('37') { organization }
      @user.stub(:can_edit?).and_return
      @user.stub(:can_request_org_admin?)
      controller.stub(:current_user).and_return(@user)
    end

    it 'should use a two_column layout' do
      get :show, :id => '37'
      response.should render_template 'layouts/two_columns'
    end

    it "assigns the requested organization as @organization" do
      Organization.should_receive(:find).with('37') { organization }
      get :show, :id => '37'
      assigns(:organization).should eq organization
    end

    context "editable flag is assigned to match user permission" do
      it "user with permission leads to editable flag true" do
        @user.should_receive(:can_edit?).with(organization).and_return(true)
        get :show, :id => 37
        assigns(:editable).should be(true)
      end

      it "user without permission leads to editable flag false" do
        @user.should_receive(:can_edit?).with(organization).and_return(true)
        get :show, :id => 37
        assigns(:editable).should be(true)
      end

      it 'when not signed in editable flag is nil' do
        controller.stub(:current_user).and_return(nil)
        get :show, :id => 37
        expect(assigns(:editable)).to be_false
      end
    end

    context "grabbable flag is assigned to match user permission" do
      it 'assigns grabbable to true when user can request org admin status' do
        @user.stub(:can_edit?)
        @user.should_receive(:can_request_org_admin?).with(organization).and_return(true)
        controller.stub(:current_user).and_return(@user)
        get :show, :id => 37
        assigns(:grabbable).should be(true)
      end
      it 'assigns grabbable to false when user cannot request org admin status' do
        @user.stub(:can_edit?)
        @user.should_receive(:can_request_org_admin?).with(organization).and_return(false)
        controller.stub(:current_user).and_return(@user)
        get :show, :id => 37
        assigns(:grabbable).should be(false)
      end
      it 'when not signed in grabbable flag is true' do
        controller.stub(:current_user).and_return(nil)
        get :show, :id => 37
        expect(assigns(:grabbable)).to be_true
      end
    end
  end

  describe "GET new" do
    context "while signed in" do
      before(:each) do
        user = double("User")
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
        Organization.stub(:new) { organization }
      end

      it "assigns a new organization as @organization" do
        get :new
        assigns(:organization).should be organization
      end

      it 'should use a two_column layout' do
        get :new
        response.should render_template 'layouts/two_columns'
      end
    end

    context "while not signed in" do
      it "redirects to sign-in" do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET edit" do
    context "while signed in as user who can edit" do
      before(:each) do
        user = double("User")
        user.stub(:can_edit?){true}
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
      end

      it "assigns the requested organization as @organization" do
        Organization.stub(:find).with('37') { organization }
        get :edit, :id => '37'
        assigns(:organization).should be organization
        response.should render_template 'layouts/two_columns'
      end
    end
    context "while signed in as user who cannot edit" do
      before(:each) do
        user = double("User")
        user.stub(:can_edit?){false}
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
      end

      it "redirects to organization view" do
        Organization.stub(:find).with('37') { organization }
        get :edit, :id => '37'
        response.should redirect_to organization_url(37)
      end
    end
    #TODO: way to dry out these redirect specs?
    context "while not signed in" do
      it "redirects to sign-in" do
        get :edit, :id => '37'
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST create", :helpers => :controllers do
    context "while signed in as admin" do
      before(:each) do
        make_current_user_admin.should_receive(:admin?).and_return true
      end

      describe "with valid params" do
        before(:each) { organization.stub(:save => true, :name => 'org') }
        it "assigns a newly created organization as @organization" do
          Organization.stub(:new).with({'these' => 'params'}) { organization }
          post :create, :organization => {'these' => 'params'}
          assigns(:organization).should be organization
        end

        it "redirects to the created organization" do
          Organization.stub(:new) { organization }
          post :create, :organization => {}
          response.should redirect_to(organization_url(organization))
        end
      end

      describe "with invalid params" do
        before(:each) { organization.stub(:save => false) }
        after(:each) { response.should render_template 'layouts/two_columns' }

        it "assigns a newly created but unsaved organization as @organization" do
          Organization.stub(:new).with({'these' => 'params'}) { organization }
          post :create, :organization => {'these' => 'params'}
          assigns(:organization).should be organization
        end

        it "re-renders the 'new' template" do
          Organization.stub(:new) { organization }
          post :create, :organization => {}
          response.should render_template("new")
        end
      end
    end

    context "while not signed in" do
      it "redirects to sign-in" do
        organization.stub(:save => true)
        Organization.stub(:new).with({'these' => 'params'}) { organization }
        post :create, :organization => {'these' => 'params'}
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "while signed in as non-admin" do
      before(:each) do
        make_current_user_nonadmin.should_receive(:admin?).and_return(false)
        organization.stub(:save => true)
      end

      describe "with valid params" do
        it "refuses to create a new organization" do
          # stubbing out Organization to prevent new method from calling Gmaps APIs
          Organization.stub(:new).with({'these' => 'params'}) { organization }
          Organization.should_not_receive :new
          post :create, :organization => {'these' => 'params'}
        end

        it "redirects to the organizations index" do
          Organization.stub(:new).with({'these' => 'params'}) { organization }
          post :create, :organization => {'these' => 'params'}
          expect(response).to redirect_to organizations_path           
        end

        it "assigns a flash refusal" do
          Organization.stub(:new).with({'these' => 'params'}) { organization }
          post :create, :organization => {'these' => 'params'}
          expect(flash[:notice]).to eq("You don't have permission")
        end
      end
      # not interested in invalid params
    end
  end

  describe "PUT update" do
    context "while signed in as user who can edit" do
      before(:each) do
        user = double 'User', :can_edit? => true
        request.env['warden'].stub :authenticate! => user
        controller.stub :current_user => user
      end

      describe "with valid params" do
        before(:each) { organization.stub(:update_attributes_with_admin => true) }

        it "updates org for e.g. donation_info url" do
          Organization.should_receive(:find).with('37') { organization }
          organization.should_receive(:update_attributes_with_admin).with({'donation_info' => 'http://www.friendly.com/donate', 'admin_email_to_add' => nil})
          put :update, :id => '37', :organization => {'donation_info' => 'http://www.friendly.com/donate'}
        end

        it "assigns the requested organization as @organization" do

          Organization.stub(:find) { organization }
          put :update, :id => "1"
          assigns(:organization).should be organization
        end

        it "redirects to the organization" do
          organization.stub(:update_attributes_with_admin => true)
          Organization.stub(:find) { organization }
          put :update, :id => "1"
          response.should redirect_to(organization_url(organization))
        end
      end

      describe "with invalid params" do
        before(:each) { organization.stub(:update_attributes_with_admin => false) }
        after(:each) { response.should render_template 'layouts/two_columns' }

        it "assigns the organization as @organization" do
          Organization.stub(:find) { organization }
          put :update, :id => "1"
          assigns(:organization).should be organization
        end

        it "re-renders the 'edit' template" do
          Organization.stub(:find) { organization }
          put :update, :id => "1"
          response.should render_template("edit")
        end
      end
    end

    context "while signed in as user who cannot edit" do
      before(:each) do
        user = double 'User', :can_edit? => false
        request.env['warden'].stub :authenticate! => user
        controller.stub :current_user => user
      end

      describe "with existing organization" do
        it "does not update the requested organization" do
          organization.stub(:id => 37)
          Organization.should_receive(:find).with("#{organization.id}") { organization }
          organization.should_not_receive(:update_attributes)
          put :update, :id => "#{organization.id}", :organization => {'these' => 'params'}
          response.should redirect_to(organization_url("#{organization.id}"))
          expect(flash[:notice]).to eq("You don't have permission")
        end
      end

      describe "with non-existent organization" do
        it "does not update the requested organization" do
          Organization.should_receive(:find).with("9999") { nil }
          put :update, :id => "9999", :organization => {'these' => 'params'}
          response.should redirect_to(organization_url("9999"))
          expect(flash[:notice]).to eq("You don't have permission")
        end
      end
    end

    context "while not signed in" do
      it "redirects to sign-in" do
        put :update, :id => "1", :organization => {'these' => 'params'}
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE destroy" do
    context "while signed in as admin", :helpers => :controllers do
      before(:each) do
        make_current_user_admin
      end
      it "destroys the requested organization and redirect to organization list" do
        Organization.should_receive(:find).with('37') { organization }
        organization.should_receive(:destroy)
        delete :destroy, :id => '37'
        response.should redirect_to(organizations_url)
      end
    end
    context "while signed in as non-admin", :helpers => :controllers do
      before(:each) do
        make_current_user_nonadmin
      end
      it "does not destroy the requested organization but redirects to organization home page" do
        double = organization
        Organization.should_not_receive(:find).with('37'){double}
        double.should_not_receive(:destroy)
        delete :destroy, :id => '37'
        response.should redirect_to(organization_url('37'))
      end
    end
    context "while not signed in" do
      it "redirects to sign-in" do
        delete :destroy, :id => '37'
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end