require 'spec_helper'

describe OrganisationsController do
  let(:category_html_options) { [['cat1', 1], ['cat2', 2]] }

  # shouldn't this be done in spec_helper.rb?
  before :suite do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
  end

  # http://stackoverflow.com/questions/10442159/rspec-as-null-object
  # doesn't calling as_null_object on a mock negate the need to stub anything?
  def double_organisation(stubs={})
    (@double_organisation ||= mock_model(Organisation).as_null_object).tap do |organisation|
      organisation.stub(stubs) unless stubs.empty?
    end
  end

  describe "popup partial" do
    it "should take some argument and call to_gmap4rails on it" do
      result = [double_organisation]
      partial = double("template")
      marker = double("marker")
      marker.should_receive(:infowindow)
      result.should_receive(:to_gmaps4rails).and_yield(double_organisation, marker)
      @controller.should_receive(:render_to_string)
      #not sure if we are supposed to test private method on controller ...
      @controller.send(:gmap4rails_with_popup_partial, result, partial)
    end

  end

  describe "GET search" do

    context 'setting appropriate view vars for all combinations of input' do
      let(:json) { 'my markers' }
      let(:result) { [double_organisation] }
      let(:category) { double('Category') }
      before(:each) do
        result.should_receive(:to_gmaps4rails).and_return(json)
        result.stub_chain(:page, :per).and_return(result)
        Category.should_receive(:html_drop_down_options).and_return(category_html_options)
      end

      it "orders search results by most recent" do
        Organisation.should_receive(:order_by_most_recent).and_return(result)
        result.stub_chain(:search_by_keyword, :filter_by_category).with('test').with(nil).and_return(result)
        get :search, :q => 'test'
        assigns(:organisations).should eq([double_organisation])
      end

      it "sets up appropriate values for view vars: query_term, organisations and json" do
        Organisation.should_receive(:search_by_keyword).with('test').and_return(result)
        result.should_receive(:filter_by_category).with('1').and_return(result)
        Category.should_receive(:find_by_id).with("1").and_return(category)
        get :search, :q => 'test', "category" => {"id" => "1"}
        assigns(:query_term).should eq 'test'
        assigns(:category).should eq category
      end

      it "handles lack of category gracefully" do
        Organisation.should_receive(:search_by_keyword).with('test').and_return(result)
        result.should_receive(:filter_by_category).with(nil).and_return(result)
        get :search, :q => 'test'
        assigns(:query_term).should eq 'test'
      end

      it "handles lack of query term gracefully" do
        Organisation.should_receive(:search_by_keyword).with(nil).and_return(result)
        result.should_receive(:filter_by_category).with(nil).and_return(result)
        get :search
        assigns(:query_term).should eq nil
      end

      it "handles lack of id gracefully" do
        Organisation.should_receive(:search_by_keyword).with('test').and_return(result)
        result.should_receive(:filter_by_category).with(nil).and_return(result)
        get :search, :q => 'test', "category" => nil
        assigns(:query_term).should eq 'test'
      end

      it "handles empty string id gracefully" do
        Organisation.should_receive(:search_by_keyword).with('test').and_return(result)
        result.should_receive(:filter_by_category).with("").and_return(result)
        get :search, :q => 'test', "category" => {"id" => ""}
        assigns(:query_term).should eq 'test'
      end

      after(:each) do
        response.should render_template 'index'
        response.should render_template 'layouts/two_columns'
        assigns(:organisations).should eq([double_organisation])
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
      Organisation.should_receive(:search_by_keyword).with('no results').and_return(result)
      result.should_receive(:filter_by_category).with('1').and_return(result)
      category = double('Category')
      Category.should_receive(:find_by_id).with("1").and_return(category)
      ActionDispatch::Flash::FlashHash.any_instance.should_receive(:now).and_return double_now_flash
      ActionDispatch::Flash::FlashHash.any_instance.should_not_receive(:[]=)
      double_now_flash.should_receive(:[]=).with(:alert, SEARCH_NOT_FOUND)
      get :search, :q => 'no results', "category" => {"id" => "1"}
    end

    it "does not set up flash nor flash.now when search returns results" do
      result = [double_organisation]
      json='my markers'
      result.should_receive(:to_gmaps4rails).and_return(json)
      result.should_receive(:empty?).and_return(false)
      result.stub_chain(:page, :per).and_return(result)
      Organisation.should_receive(:search_by_keyword).with('some results').and_return(result)
      result.should_receive(:filter_by_category).with('1').and_return(result)
      category = double('Category')
      Category.should_receive(:find_by_id).with("1").and_return(category)
      get :search, :q => 'some results', "category" => {"id" => "1"}
      expect(flash.now[:alert]).to be_nil
      expect(flash[:alert]).to be_nil
    end
  end

  describe "GET index" do
    describe 'ControllerExtensions::Organisations::Default' do
      let(:params) { example.metadata.slice(:scopes) }
      before do
        controller.stub example.metadata.slice(:admin?)
      end

      context admin?: false do
        it do
          get :index, params
          expect(controller.params[:scopes]).to eq ['order_by_most_recent']
        end
      end

      context admin?: true do
        it do
          get :index, params
          expect(controller.params[:scopes]).to eq ['order_by_most_recent']
        end
      end

      context admin?: false, scopes: ['hello'] do
        it do
          get :index, params
          expect(controller.params[:scopes]).to eq ['order_by_most_recent']
        end
      end

      context admin?: true, scopes: ['hello'] do
        it do
          expect(Organisation).to receive(:hello).and_return Organisation.all
          get :index, params
          expect(controller.params[:scopes]).to eq ['hello']
        end
      end
    end


    context 'ControllerExtensions::Organisations::Index' do
      it "assigns all organisations as @organisations" do
        result = [double_organisation]
        json='my markers'
        result.should_receive(:to_gmaps4rails).and_return(json)
        Category.should_receive(:html_drop_down_options).and_return(category_html_options)
        Organisation.should_receive(:order_by_most_recent).and_return(result)
        result.stub_chain(:page, :per).and_return(result)
        get :index
        assigns(:organisations).should eq(result)
        assigns(:json).should eq(json)
        response.should render_template 'layouts/two_columns'
      end
    end

    context 'ControllerExtensions::Organisations::WithoutUsers' do
      it 'non-admins not allowed' do
        controller.stub admin?: false
        get :index, service: 'without_users'
        expect(controller.params[:template]).to eq 'organisations/index'
      end

      context 'admins' do
        before do
          controller.stub admin?: true
          get :index, service: 'without_users'
        end

        context 'params set' do
          {
            template: 'without_users_index',
            layout: 'invitation_table',
            scopes: ['not_null_email','null_users','without_matching_user_emails'],
          }.each do |k, v|
            it do
              if k == :template
                v = v.prepend(controller.controller_name + '/')
              end
              expect(controller.params[k]).to eq v
            end
          end
        end

        context 'instance variables set' do
          it do
            expect(assigns(:resend_invitation)).to eq false
          end

          it do
            org = create(:organisation, email: 'well@hello.there')
            expect(assigns(:organisations)).to include org
          end
        end
      end
    end

  end

  describe "GET show" do
    before(:each) do
      @user = double("User")
      @user.stub(:pending_admin?)
      Organisation.stub(:find).with('37') { double_organisation }
      @user.stub(:can_edit?)
      @user.stub(:can_delete?)
      @user.stub(:can_create_volunteer_ops?)
      @user.stub(:can_request_org_admin?)
      controller.stub(:current_user).and_return(@user)
    end

    it 'should use a two_column layout' do
      get :show, :id => '37'
      response.should render_template 'layouts/two_columns'
    end

    it "assigns the requested organisation as @organisation and appropriate json" do
      json='my markers'
      @org = double_organisation
      @org.should_receive(:to_gmaps4rails).and_return(json)
      Organisation.should_receive(:find).with('37') { @org }
      get :show, :id => '37'
      assigns(:organisation).should be(double_organisation)
      assigns(:json).should eq(json)
    end

    context "editable flag is assigned to match user permission" do
      it "user with permission leads to editable flag true" do
        @user.should_receive(:can_edit?).with(double_organisation).and_return(true)
        get :show, :id => 37
        assigns(:editable).should be(true)
      end

      it "user without permission leads to editable flag false" do
        @user.should_receive(:can_edit?).with(double_organisation).and_return(true)
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
        @user.should_receive(:can_request_org_admin?).with(double_organisation).and_return(true)
        controller.stub(:current_user).and_return(@user)
        get :show, :id => 37
        assigns(:grabbable).should be(true)
      end
      it 'assigns grabbable to false when user cannot request org admin status' do
        @user.stub(:can_edit?)
        @user.should_receive(:can_request_org_admin?).with(double_organisation).and_return(false)
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

    describe 'can_create_volunteer_op flag' do
      context 'depends on can_create_volunteer_ops?' do
        it 'true' do
          @user.should_receive(:can_create_volunteer_ops?) { true }
          get :show, :id => 37
          assigns(:can_create_volunteer_op).should be true
        end

        it 'false' do
          @user.should_receive(:can_create_volunteer_ops?) { false }
          get :show, :id => 37
          assigns(:can_create_volunteer_op).should be false
        end
      end

      it 'will not be called when current user is nil' do
        controller.stub current_user: nil
        @user.should_not_receive :can_create_volunteer_ops?
        get :show, :id => 37
        assigns(:can_create_volunteer_op).should be nil
      end
    end
  end

  describe "GET new" do
    context "while signed in" do
      before(:each) do
        user = double("User")
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
        Organisation.stub(:new) { double_organisation }
      end

      it "assigns a new organisation as @organisation" do
        get :new
        assigns(:organisation).should be(double_organisation)
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
        user.stub(:can_edit?) { true }
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
      end

      it "assigns the requested organisation as @organisation" do
        Organisation.stub(:find).with('37') { double_organisation }
        get :edit, :id => '37'
        assigns(:organisation).should be(double_organisation)
        response.should render_template 'layouts/two_columns'
      end
    end
    context "while signed in as user who cannot edit" do
      before(:each) do
        user = double("User")
        user.stub(:can_edit?) { false }
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
      end

      it "redirects to organisation view" do
        Organisation.stub(:find).with('37') { double_organisation }
        get :edit, :id => '37'
        response.should redirect_to organisation_url(37)
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
        it "assigns a newly created organisation as @organisation" do
          Organisation.stub(:new){ double_organisation(:save => true, :name => 'org') }
          post :create, :organisation => {'these' => 'params'}
          assigns(:organisation).should be(double_organisation)
        end

        it "redirects to the created organisation" do
          Organisation.stub(:new) { double_organisation(:save => true) }
          post :create, :organisation => {name: "blah"}
          response.should redirect_to(organisation_url(double_organisation))
        end
      end

      describe "with invalid params" do
        after(:each) { response.should render_template 'layouts/two_columns' }

        it "assigns a newly created but unsaved organisation as @organisation" do
          Organisation.stub(:new){ double_organisation(:save => false) }
          post :create, :organisation => {'these' => 'params'}
          assigns(:organisation).should be(double_organisation)
        end

        it "re-renders the 'new' template" do
          Organisation.stub(:new) { double_organisation(:save => false) }
          post :create, :organisation => {name: "great"}
          response.should render_template("new")
        end
      end
    end

    context "while not signed in" do
      it "redirects to sign-in" do
        Organisation.stub(:new).with({'these' => 'params'}) { double_organisation(:save => true) }
        post :create, :organisation => {'these' => 'params'}
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "while signed in as non-admin" do
      before(:each) do
        make_current_user_nonadmin.should_receive(:admin?).and_return(false)
      end

      describe "with valid params" do
        it "refuses to create a new organisation" do
          # stubbing out Organisation to prevent new method from calling Gmaps APIs
          Organisation.stub(:new).with({'these' => 'params'}) { double_organisation(:save => true) }
          Organisation.should_not_receive :new
          post :create, :organisation => {'these' => 'params'}
        end

        it "redirects to the organisations index" do
          Organisation.stub(:new).with({'these' => 'params'}) { double_organisation(:save => true) }
          post :create, :organisation => {'these' => 'params'}
          expect(response).to redirect_to organisations_path
        end

        it "assigns a flash refusal" do
          Organisation.stub(:new).with({'these' => 'params'}) { double_organisation(:save => true) }
          post :create, :organisation => {'these' => 'params'}
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
        user.stub(:can_edit?) { true }
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
      end

      describe "with valid params" do
        it "updates org for e.g. donation_info url" do
          double = double_organisation(:id => 37, :model_name => 'Organisation')
          Organisation.should_receive(:find).with('37') { double }
          double_organisation.should_receive(:update_attributes_with_admin).with({'donation_info' => 'http://www.friendly.com/donate', 'admin_email_to_add' => nil})
          put :update, :id => '37', :organisation => {'donation_info' => 'http://www.friendly.com/donate'}
        end

        it "assigns the requested organisation as @organisation" do
          Organisation.stub(:find) { double_organisation(:update_attributes_with_admin => true) }
          put :update, :id => "1", :organisation => {'these' => 'params'}
          assigns(:organisation).should be(double_organisation)
        end

        it "redirects to the organisation" do
          Organisation.stub(:find) { double_organisation(:update_attributes_with_admin => true) }
          put :update, :id => "1", :organisation => {'these' => 'params'}
          response.should redirect_to(organisation_url(double_organisation))
        end
      end

      describe "with invalid params" do
        after(:each) { response.should render_template 'layouts/two_columns' }

        it "assigns the organisation as @organisation" do
          Organisation.stub(:find) { double_organisation(:update_attributes_with_admin => false) }
          put :update, :id => "1", :organisation => {'these' => 'params'}
          assigns(:organisation).should be(double_organisation)
        end

        it "re-renders the 'edit' template" do
          Organisation.stub(:find) { double_organisation(:update_attributes_with_admin => false) }
          put :update, :id => "1", :organisation => {'these' => 'params'}
          response.should render_template("edit")
        end
      end
    end

    context "while signed in as user who cannot edit" do
      before(:each) do
        user = double("User")
        user.stub(:can_edit?) { false }
        request.env['warden'].stub :authenticate! => user
        controller.stub(:current_user).and_return(user)
      end

      describe "with existing organisation" do
        it "does not update the requested organisation" do
          org = double_organisation(:id => 37)
          Organisation.should_receive(:find).with("#{org.id}") { org }
          org.should_not_receive(:update_attributes)
          put :update, :id => "#{org.id}", :organisation => {'these' => 'params'}
          response.should redirect_to(organisation_url("#{org.id}"))
          expect(flash[:notice]).to eq("You don't have permission")
        end
      end

      describe "with non-existent organisation" do
        it "does not update the requested organisation" do
          Organisation.should_receive(:find).with("9999") { nil }
          put :update, :id => "9999", :organisation => {'these' => 'params'}
          response.should redirect_to(organisation_url("9999"))
          expect(flash[:notice]).to eq("You don't have permission")
        end
      end
    end

    context "while not signed in" do
      it "redirects to sign-in" do
        put :update, :id => "1", :organisation => {'these' => 'params'}
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE destroy" do
    context "while signed in as admin", :helpers => :controllers do
      before(:each) do
        make_current_user_admin
      end
      it "destroys the requested organisation and redirect to organisation list" do
        Organisation.should_receive(:find).with('37') { double_organisation }
        double_organisation.should_receive(:destroy)
        delete :destroy, :id => '37'
        response.should redirect_to(organisations_url)
      end
    end
    context "while signed in as non-admin", :helpers => :controllers do
      before(:each) do
        make_current_user_nonadmin
      end
      it "does not destroy the requested organisation but redirects to organisation home page" do
        double = double_organisation
        Organisation.should_not_receive(:find).with('37') { double }
        double.should_not_receive(:destroy)
        delete :destroy, :id => '37'
        response.should redirect_to(organisation_url('37'))
      end
    end
    context "while not signed in" do
      it "redirects to sign-in" do
        delete :destroy, :id => '37'
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  describe ".permit" do 
    it "returns the cleaned params" do
      organisation_params = { organisation: {name: 'Happy Friends', description: 'Do nice things', address: '22 Pinner Road', 
                             postcode: '12345', email: 'happy@annoting.com', website: 'www.happyplace.com', 
                             telephone: '123-456-7890', donation_info: 'www.giveusmoney.com',
                             publish_address: true, publish_phone: true, publish_email: true, 
                             category_organisations_attributes: {'1' => {"_destroy" => "1", "id" => "1", "category_id" => "5"}}
                             }}
      params = ActionController::Parameters.new.merge(organisation_params)
      permitted_params = OrganisationsController::OrganisationParams.build(params)
      expect(permitted_params).to eq({name: 'Happy Friends', description: 'Do nice things', address: '22 Pinner Road', 
                                      postcode: '12345', email: 'happy@annoting.com', website: 'www.happyplace.com', 
                                      telephone: '123-456-7890', donation_info: 'www.giveusmoney.com',
                                      publish_address: true, publish_phone: true, publish_email: true,
                                      category_organisations_attributes: {'1' => {"_destroy" => "1", "id" => "1", "category_id" => "5"}}
                                      }.with_indifferent_access)
      #attr_accessible :name, :description, :address, :postcode, :email, :website, :telephone, :donation_info, :publish_address, :publish_phone, :publish_email, :category_organisations_attributes
    end
  end
end
