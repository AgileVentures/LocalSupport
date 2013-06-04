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
      
      get :search, :q => 'test'
      response.should render_template 'index'

      assigns(:organizations).should eq([mock_organization])
      assigns(:json).should eq(json)
    end
  end


  describe "GET index" do
    it "assigns all organizations as @organizations" do
      mock_array = []
      mock_json = ""
      #this array expectation doesn't work and I don't know why
      #Array.should_receive(:to_gmaps4rails).and_return(mock_json)
      Organization.stub(:all) { mock_array }
      get :index
      assigns(:organizations).should eq(mock_array)
      assigns(:json).should eq("[]")
    end
  end

  describe "GET show" do
    it "assigns the requested organization as @organization" do
      Organization.stub(:find).with("37") { mock_organization }
      get :show, :id => "37"
      assigns(:organization).should be(mock_organization)
    end
  end

  describe "GET new" do
    context "while signed in" do
      before(:each) do
        @user = FactoryGirl.create(:charity_worker)
        sign_in :charity_worker, @user
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
        expect(response).to redirect_to new_charity_worker_session_path
      end
    end
  end

  describe "GET edit" do
    context "while signed in" do
      before(:each) do
        @user = FactoryGirl.create(:charity_worker)
        sign_in :charity_worker, @user
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
        expect(response).to redirect_to new_charity_worker_session_path
      end
    end
  end

  describe "POST create" do
    context "while signed in" do
      before(:each) do
        @user = FactoryGirl.create(:charity_worker)
        sign_in :charity_worker, @user
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
    context "while not signed in" do
      it "redirects to sign-in" do
        Organization.stub(:new).with({'these' => 'params'}) { mock_organization(:save => true) }
        post :create, :organization => {'these' => 'params'}
        expect(response).to redirect_to new_charity_worker_session_path
      end
    end
  end

  describe "PUT update" do
    context "while signed in as admin" do
      before(:each) do
        @admin = FactoryGirl.create(:charity_worker, :admin => true)
        sign_in :charity_worker, @admin
      end
      describe "with valid params" do
        it "updates the requested organization" do
          Organization.should_receive(:find).with("37") { mock_organization }
          mock_organization.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :organization => {'these' => 'params'}
        end

        it "updates donation_info url" do
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

    context "while signed in as normal user belonging to organization" do
      before(:each) do
        #TODO: Is this necessary to push into real database to get the association to take?
        @user = FactoryGirl.create(:charity_worker_stubbed_organization)
        @associated_org = @user.organization
        sign_in :charity_worker, @user
      end
      describe "with valid params" do
        it "updates the requested organization" do
          Organization.should_receive(:find).with("#{@associated_org.id}"){@associated_org}
          @associated_org.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "#{@associated_org.id}", :organization => {'these' => 'params'}
        end
        it "updates donation_info url" do
          org = @user.organization
          Organization.should_receive(:find).with("#{@associated_org.id}"){@associated_org}
         @associated_org.should_receive(:update_attributes).with({'donation_info' => 'http://www.friendly.com/donate'})
          put :update, :id => "#{@associated_org.id}", :organization => {'donation_info' => 'http://www.friendly.com/donate'}
        end
      end
    end

    context "while signed in as normal user belonging to no organization" do
      before(:each) do
        @user = FactoryGirl.create(:charity_worker)
        @non_associated_org = mock_organization
        sign_in :charity_worker, @user
      end
      describe "with valid params" do
        it "does not update the requested organization" do
          Organization.should_not_receive(:find).with("#{@non_associated_org.id}")
          @non_associated_org.should_not_receive(:update_attributes)
          put :update, :id => "#{@non_associated_org.id}", :organization => {'these' => 'params'}
          response.should redirect_to(organization_url("#{@non_associated_org.id}"))
          expect(flash[:notice]).to eq("You don't have permission")
        end
      end

    end
    context "while not signed in" do
      it "redirects to sign-in" do
        put :update, :id => "1", :organization => {'these' => 'params'}
        expect(response).to redirect_to new_charity_worker_session_path
      end
    end
  end

  describe "DELETE destroy" do
    context "while signed in" do
      before(:each) do
        @user = FactoryGirl.create(:charity_worker)
        sign_in :charity_worker, @user
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
    context "while not signed in" do
      it "redirects to sign-in" do
        delete :destroy, :id => "37"
        expect(response).to redirect_to new_charity_worker_session_path
      end
    end
  end

end
