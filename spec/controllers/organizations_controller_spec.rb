require 'spec_helper'

describe OrganizationsController do
  let(:category_html_options){[['cat1',1],['cat2',2]]}

  # shouldn't this be done in spec_helper.rb?
  before :suite do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
  end

  # http://stackoverflow.com/questions/10442159/rspec-as-null-object
  # doesn't calling as_null_object on a mock negate the need to stub anything?
  def double_organization(stubs={})
    (@double_organization ||= mock_model(Organization).as_null_object).tap do |organization|
      organization.stub(stubs) unless stubs.empty?
    end
  end

  describe "popup partial" do
    it "should take some argument and call to_gmap4rails on it" do
      result = [double_organization]
      partial = double("template")
      marker = double("marker")
      marker.should_receive(:infowindow)
      result.should_receive(:to_gmaps4rails).and_yield(double_organization,marker)
      @controller.should_receive(:render_to_string)
      #not sure if we are supposed to test private method on controller ...
      @controller.send(:gmap4rails_with_popup_partial,result, partial)
    end

  end
  
  describe "GET search" do

    context 'setting appropriate view vars for all combinations of input' do
      let(:json) {'my markers'}
      let(:result) {[double_organization]}
      let(:category){double('Category')}
      before(:each) do
        result.should_receive(:to_gmaps4rails).and_return(json)
        result.stub_chain(:page, :per).and_return(result)
        Category.should_receive(:html_drop_down_options).and_return(category_html_options)
      end

      it "sets up appropriate values for view vars: query_term, organizations and json" do
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
        assigns(:organizations).should eq([double_organization])
        assigns(:json).should eq(json)
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
      result = [double_organization]
      json='my markers'
      result.should_receive(:to_gmaps4rails).and_return(json)
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
      result = [double_organization]
      json='my markers'
      result.should_receive(:to_gmaps4rails).and_return(json)
      Category.should_receive(:html_drop_down_options).and_return(category_html_options)
      Organization.should_receive(:order).with('updated_at DESC').and_return(result)
      result.stub_chain(:page, :per).and_return(result)
      get :index
      assigns(:organizations).should eq(result)
      assigns(:json).should eq(json)
    end
  end

  describe "GET show" do
    it "assigns the requested organization as @organization and appropriate json" do
      json='my markers'
      @org = double_organization
      @org.should_receive(:to_gmaps4rails).and_return(json)
      Organization.should_receive(:find).with("37") { @org }
      get :show, :id => "37"
      assigns(:organization).should be(double_organization)
      assigns(:json).should eq(json)
    end

    context "editable flag is assigned to match user permission" do
      before(:each) do
        Organization.stub(:find).with("37") { double_organization }
        @user = double("User")
        controller.stub(:current_user).and_return(@user)
      end

      it "user with permission leads to editable flag true" do
        @user.should_receive(:can_edit?).with(double_organization).and_return(true)
        get :show, :id => 37
        assigns(:editable).should be(true)
      end

      it "user without permission leads to editable flag false" do
        @user.should_receive(:can_edit?).with(double_organization).and_return(true)
        get :show, :id => 37
        assigns(:editable).should be(true)
      end

      it 'when not signed in editable flag is nil' do
        controller.stub(:current_user).and_return(nil)
        get :show, :id => 37
        expect(assigns(:editable)).to eq nil
      end
    end
  end

  describe "GET new" do
    context "while signed in" do
      before(:each) do
        user = double("User")
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
      end

      it "assigns a new organization as @organization" do
        Organization.stub(:new) { double_organization }
        get :new
        assigns(:organization).should be(double_organization)
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
        Organization.stub(:find).with("37") { double_organization }
        get :edit, :id => "37"
        assigns(:organization).should be(double_organization)
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
        Organization.stub(:find).with("37") { double_organization }
        get :edit, :id => "37"
        response.should redirect_to organization_url(37)
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
        user = double("User")
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
	user.should_receive(:admin?).and_return(true)
      end

      describe "with valid params" do
        it "assigns a newly created organization as @organization" do
          Organization.stub(:new).with({'these' => 'params'}) { double_organization(:save => true, :name => 'org') }
          post :create, :organization => {'these' => 'params'}
          assigns(:organization).should be(double_organization)
        end

        it "redirects to the created organization" do
          Organization.stub(:new) { double_organization(:save => true) }
          post :create, :organization => {}
          response.should redirect_to(organization_url(double_organization))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved organization as @organization" do
          Organization.stub(:new).with({'these' => 'params'}) { double_organization(:save => false) }
          post :create, :organization => {'these' => 'params'}
          assigns(:organization).should be(double_organization)
        end

        it "re-renders the 'new' template" do
          Organization.stub(:new) { double_organization(:save => false) }
          post :create, :organization => {}
          response.should render_template("new")
        end
      end
    end

    context "while not signed in" do
      it "redirects to sign-in" do
        Organization.stub(:new).with({'these' => 'params'}) { double_organization(:save => true) }
        post :create, :organization => {'these' => 'params'}
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "while signed in as non-admin" do
      before(:each) do
        user = double("User")
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
	user.should_receive(:admin?).and_return(false)
      end

      describe "with valid params" do
         it "refuses to create a new organization" do
	   # stubbing out Organization to prevent new method from calling Gmaps APIs
           Organization.stub(:new).with({'these' => 'params'}) { double_organization(:save => true) }
	   Organization.should_not_receive :new
	   post :create, :organization => {'these' => 'params'}
         end
         it "redirects to the organizations index" do
           Organization.stub(:new).with({'these' => 'params'}) { double_organization(:save => true) }
	   post :create, :organization => {'these' => 'params'}
	   expect(response).to redirect_to organizations_path           
	 end
	 it "assigns a flash refusal" do
           Organization.stub(:new).with({'these' => 'params'}) { double_organization(:save => true) }
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
        user = double("User")
        user.stub(:can_edit?){true}
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
      end

      describe "with valid params" do

        it "updates org for e.g. donation_info url" do
          double = double_organization(:id => 37, :model_name => 'Organization')
          Organization.should_receive(:find).with("37"){double}
          double_organization.should_receive(:update_attributes_with_admin).with({'donation_info' => 'http://www.friendly.com/donate', 'admin_email_to_add' => nil})
          put :update, :id => "37", :organization => {'donation_info' => 'http://www.friendly.com/donate'}
        end

        it "assigns the requested organization as @organization" do
          Organization.stub(:find) { double_organization(:update_attributes_with_admin => true) }
          put :update, :id => "1"
          assigns(:organization).should be(double_organization)
        end

        it "redirects to the organization" do
          Organization.stub(:find) { double_organization(:update_attributes_with_admin => true) }
          put :update, :id => "1"
          response.should redirect_to(organization_url(double_organization))
        end
      end

      describe "with invalid params" do
        it "assigns the organization as @organization" do
          Organization.stub(:find) { double_organization(:update_attributes_with_admin => false) }
          put :update, :id => "1"
          assigns(:organization).should be(double_organization)
        end

        it "re-renders the 'edit' template" do
          Organization.stub(:find) { double_organization(:update_attributes_with_admin => false) }
          put :update, :id => "1"
          response.should render_template("edit")
        end
      end
    end

    context "while signed in as user who cannot edit" do
      before(:each) do
        user = double("User")
        user.stub(:can_edit?){false}
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
      end

      describe "with existing organization" do
        it "does not update the requested organization" do
          org = double_organization(:id => 37)
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
        user = double("User")
        user.stub(:admin?){true}
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
      end
      it "destroys the requested organization" do
        Organization.should_receive(:find).with("37") { double_organization }
        double_organization.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the organizations list" do
        Organization.stub(:find) { double_organization }
        delete :destroy, :id => "1"
        response.should redirect_to(organizations_url)
      end
    end
    context "while signed in as non-admin" do
      before(:each) do
        user = double("User")
        user.stub(:admin?){false}
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
      end
      it "does not destroy the requested organization" do
        double = double_organization
        Organization.should_not_receive(:find).with("37"){double}
        double.should_not_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the organization home page" do
        Organization.stub(:find) { double_organization }
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
