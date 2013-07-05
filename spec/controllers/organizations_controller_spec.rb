require 'spec_helper'

describe OrganizationsController do

  before :suite do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
  end

  def mock_organization(stubs={})
    (@mock_organization ||= mock_model(Organization).as_null_object).tap do |organization|
      organization.stub(stubs) unless stubs.empty?
    end
  end
  
  describe "GET search" do
    it "searches all organizations as @organizations" do
      result = [mock_organization]
      json='my markers'
      result.should_receive(:to_gmaps4rails).and_return(json)
      Organization.should_receive(:search_by_keyword).with('test').and_return(result)

      result.stub_chain(:page, :per).and_return(result)
      
      get :search, :q => 'test'
      response.should render_template 'index'

      assigns(:organizations).should eq([mock_organization])
      assigns(:json).should eq(json)
    end

    it "sets up query term on search" do
      get :search , :q => 'search'
      assigns(:query_term).should eq 'search'
    end
    #figure out how to make this less messy
    it "assigns to flash.now but not flash when search returns no results" do
      mock_now_flash = double("FlashHash")
      result = []
      result.should_receive(:empty?).and_return(true)
      result.stub_chain(:page, :per).and_return(result)
      Organization.should_receive(:search_by_keyword).with('no results').and_return(result)
      ActionDispatch::Flash::FlashHash.any_instance.should_receive(:now).and_return mock_now_flash
      ActionDispatch::Flash::FlashHash.any_instance.should_not_receive(:[]=)
      mock_now_flash.should_receive(:[]=).with(:alert, "Sorry, it seems we don't quite have what you are looking for.")     
      get :search , :q => 'no results'
    end

    it "does not set up flash nor flash.now when search returns results" do
      result = [mock_organization]
      json='my markers'
      result.should_receive(:to_gmaps4rails).and_return(json)
      result.should_receive(:empty?).and_return(false)
      result.stub_chain(:page, :per).and_return(result)
      Organization.should_receive(:search_by_keyword).with('some results').and_return(result)
      get :search , :q => 'some results'
      expect(flash.now[:alert]).to be_nil
      expect(flash[:alert]).to be_nil
    end
  end


  describe "GET index" do
    it "assigns all organizations as @organizations" do
      result = [mock_organization]
      json='my markers'
      result.should_receive(:to_gmaps4rails).and_return(json)
      Organization.should_receive(:order).with('updated_at DESC').and_return(result)
      result.stub_chain(:page, :per).and_return(result)
      get :index
      assigns(:organizations).should eq(result)
      assigns(:json).should eq(json)
    end
  end

  describe "GET show" do
    it "assigns the requested organization as @organization" do
      @org = mock_organization
      Organization.should_receive(:find).with("37") { @org }
      get :show, :id => "37"
      assigns(:organization).should be(mock_organization)
    end

    context "editable flag is assigned to match user permission" do
      before(:each) do
        Organization.stub(:find).with("37") { mock_organization }
        @user = mock_model("User")
        controller.stub!(:current_user).and_return(@user)
      end

      it "user with permission leads to editable flag true" do
        @user.should_receive(:can_edit?).with(mock_organization).and_return(true)
        get :show, :id => 37
        assigns(:editable).should be(true)
      end

      it "user without permission leads to editable flag false" do
        @user.should_receive(:can_edit?).with(mock_organization).and_return(true)
        get :show, :id => 37
        assigns(:editable).should be(true)
      end

      it 'when not signed in editable flag is nil' do
        controller.stub!(:current_user).and_return(nil)
        get :show, :id => 37
        expect(assigns(:editable)).to eq nil
      end
    end
  end

  describe "GET new" do
    context "while signed in" do
      before(:each) do
        user = mock_model("User")
        request.env['warden'].stub :authenticate! => user
        controller.stub!(:current_user).and_return(user)
      end

      it "assigns a new organization as @organization" do
        Organization.stub(:new) { mock_organization }
        get :new
        assigns(:organization).should be(mock_organization)
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
    context "while signed in" do
      before(:each) do
        user = mock_model("User")
        request.env['warden'].stub :authenticate! => user
        controller.stub!(:current_user).and_return(user)
      end

      it "assigns the requested organization as @organization" do
        Organization.stub(:find).with("37") { mock_organization }
        get :edit, :id => "37"
        assigns(:organization).should be(mock_organization)
      end
    end
    #TODO: way to dry out these redirect specs?
    context "while not signed in" do
      it "redirects to sign-in" do
        get :edit, :id => 37
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST create" do
    context "while signed in as admin" do
      before(:each) do
        user = mock_model("User")
        request.env['warden'].stub :authenticate! => user
        controller.stub!(:current_user).and_return(user)
	user.should_receive(:admin?).and_return(true)
      end

      describe "with valid params" do
        it "assigns a newly created organization as @organization" do
          Organization.stub(:new).with({'these' => 'params'}) { mock_organization(:save => true) }
          post :create, :organization => {'these' => 'params'}
          assigns(:organization).should be(mock_organization)
        end

        it "redirects to the created organization" do
          Organization.stub(:new) { mock_organization(:save => true) }
          post :create, :organization => {}
          response.should redirect_to(organization_url(mock_organization))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved organization as @organization" do
          Organization.stub(:new).with({'these' => 'params'}) { mock_organization(:save => false) }
          post :create, :organization => {'these' => 'params'}
          assigns(:organization).should be(mock_organization)
        end

        it "re-renders the 'new' template" do
          Organization.stub(:new) { mock_organization(:save => false) }
          post :create, :organization => {}
          response.should render_template("new")
        end
      end
    end

    context "while signed in as non-admin" do
      before(:each) do
        user = mock_model("User")
        request.env['warden'].stub :authenticate! => user
        controller.stub!(:current_user).and_return(user)
	user.should_receive(:admin?).and_return(false)
      end

      describe "with valid params" do
         it "refuses to create a new organization" do
	   # stubbing out Organization to prevent new method from calling Gmaps APIs
           Organization.stub(:new).with({'these' => 'params'}) { mock_organization(:save => true) }
	   Organization.should_not_receive :new
	   post :create, :organization => {'these' => 'params'}
         end
         it "redirects to the organizations index" do
           Organization.stub(:new).with({'these' => 'params'}) { mock_organization(:save => true) }
	   post :create, :organization => {'these' => 'params'}
	   expect(response).to redirect_to organizations_path           
	 end
	 it "assigns a flash refusal" do
           Organization.stub(:new).with({'these' => 'params'}) { mock_organization(:save => true) }
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
        user = mock_model("User")
        user.stub!(:can_edit?){true}
        request.env['warden'].stub :authenticate! => user
        controller.stub!(:current_user).and_return(user)
      end

      describe "with valid params" do

        it "updates org for e.g. donation_info url" do
          mock = mock_organization(:id => 37)
          Organization.should_receive(:find).with("37"){mock}
          mock_organization.should_receive(:update_attributes).with({'donation_info' => 'http://www.friendly.com/donate'})
          put :update, :id => "37", :organization => {'donation_info' => 'http://www.friendly.com/donate'}
        end

        it "assigns the requested organization as @organization" do
          Organization.stub(:find) { mock_organization(:update_attributes => true) }
          put :update, :id => "1"
          assigns(:organization).should be(mock_organization)
        end

        it "redirects to the organization" do
          Organization.stub(:find) { mock_organization(:update_attributes => true) }
          put :update, :id => "1"
          response.should redirect_to(organization_url(mock_organization))
        end
      end

      describe "with invalid params" do
        it "assigns the organization as @organization" do
          Organization.stub(:find) { mock_organization(:update_attributes => false) }
          put :update, :id => "1"
          assigns(:organization).should be(mock_organization)
        end

        it "re-renders the 'edit' template" do
          Organization.stub(:find) { mock_organization(:update_attributes => false) }
          put :update, :id => "1"
          response.should render_template("edit")
        end
      end
    end

    context "while signed in as user who cannot edit" do
      before(:each) do
        user = mock_model("User")
        user.stub!(:can_edit?){false}
        request.env['warden'].stub :authenticate! => user
        controller.stub!(:current_user).and_return(user)
      end

      describe "with existing organization" do
        it "does not update the requested organization" do
          org = mock_organization(:id => 37)
          Organization.should_receive(:find).with("#{org.id}")  {org}
          org.should_not_receive(:update_attributes)
          put :update, :id => "#{org.id}", :organization => {'these' => 'params'}
          response.should redirect_to(organization_url("#{org.id}"))
          expect(flash[:notice]).to eq("You don't have permission")
        end
      end

      describe "with non-existent organization" do
        it "does not update the requested organization" do
          Organization.should_receive(:find).with("9999")  {nil}
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
    context "while signed in as admin" do
      before(:each) do
        user = mock_model("User")
        user.stub!(:admin?){true}
        request.env['warden'].stub :authenticate! => user
        controller.stub!(:current_user).and_return(user)
      end
      it "destroys the requested organization" do
        Organization.should_receive(:find).with("37") { mock_organization }
        mock_organization.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the organizations list" do
        Organization.stub(:find) { mock_organization }
        delete :destroy, :id => "1"
        response.should redirect_to(organizations_url)
      end
    end
    context "while signed in as non-admin" do
      before(:each) do
        user = mock_model("User")
        user.stub!(:admin?){false}
        request.env['warden'].stub :authenticate! => user
        controller.stub!(:current_user).and_return(user)
      end
      it "does not destroy the requested organization" do
        mock = mock_organization
        Organization.should_not_receive(:find).with("37"){mock}
        mock.should_not_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the organization home page" do
        Organization.stub(:find) { mock_organization }
        delete :destroy, :id => "1"
        response.should redirect_to(organization_url(1))
      end
    end
    context "while not signed in" do
      it "redirects to sign-in" do
        delete :destroy, :id => "37"
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
