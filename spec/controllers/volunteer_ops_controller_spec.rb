require 'spec_helper'

describe  VolunteerOpsController do
  it "should render template two column layout"  do
    get :index
    response.should render_template 'index'
    response.should render_template 'layouts/two_columns'
  end
end

describe VolunteerOpsController do
  let(:user) { double :user }
  let(:org) { double :organization, id: '1' }
  let!(:op) { stub_model VolunteerOp } # stack level too deep errors if stub_model is loaded lazily in some contexts

  describe 'GET index' do
    before :each do
      @results = [op]
      ApplicationController.any_instance.stub(:gmap4rails_with_popup_partial)
      VolunteerOp.stub(:all).and_return(@results)
    end

    it 'assigns all volunteer_ops as @volunteer_ops' do
      op2 = stub_model VolunteerOp, :organization => (stub_model Organization)
      @results = [op2]
      VolunteerOp.should_receive(:all).and_return(@results)
      get :index, {}
      assigns(:volunteer_ops).should eq @results
    end

    it 'assigns all volunteer_op orgs as @organizations' do
      org2 = stub_model Organization
      @results.stub(:map).and_return([org2])
      get :index, {}
      assigns(:organizations).should eq([org2])
    end

    it 'assigns @json' do
      json = 'my markers'
      org2 = stub_model Organization
      @results.stub(:map).and_return([org2])
      controller.should_receive(:gmap4rails_with_popup_partial).and_return(json)
      get :index, {}
      assigns(:json).should eq(json)
    end
  end

  describe 'GET show' do
    before do
      @org = stub_model Organization
      @op2 = stub_model VolunteerOp, :organization => (@org)
      @results = [@op2]
      allow(VolunteerOp).to receive(:find).with(@op2.id.to_s).and_return(@op2)
    end
    it 'assigns the requested volunteer_op as @volunteer_op' do
      get :show, {:id => @op2.id}
      assigns(:volunteer_op).should eq @op2
    end

    it 'non-org-owners allowed' do
      allow(controller).to receive(:org_owner?).and_return(false)
      get :show, {:id => @op2.id}
      response.status.should eq 200
    end

    it "passes a true editable flag when admin user" do
      allow(controller).to receive(:current_user).and_return(user)
      allow(user).to receive(:can_edit?).with(@org).and_return(true)
      get :show, {:id => @op2.id}
      expect(assigns(:editable)).to be_true
    end

    it "passes a false editable flag when guest user" do
      # allow(controller).to_receive(:user).and_return(nil)
      controller.stub(:current_user).and_return(nil)
      @results = [@op2]
      VolunteerOp.stub(:find).with(@op2.id.to_s) { @op2 }
      get :show, {:id => @op2.id}
      expect(assigns(:editable)).to be_false
    end
  end

  describe 'GET new' do
    it 'assigns the requested volunteer_op as @volunteer_op' do
      controller.stub org_owner?: true
      VolunteerOp.should_receive(:new) { op }
      get :new, {}
      assigns(:volunteer_op).should eq op
    end

    it 'non-org-owners denied' do
      controller.stub org_owner?: false
      get :new, {}
      response.status.should eq 302
    end
  end

  describe 'POST create' do
    let(:params) { {volunteer_op: {title: 'hard work', description: 'for the willing'}} }
    before do
      user.stub(:organization) { org }
      controller.stub current_user: user, org_owner?: true
      VolunteerOp.stub(:new) { op }
      op.stub(:save)
    end

    it 'assigns a newly created volunteer_op as @volunteer_op' do
      post :create, params
      assigns(:volunteer_op).should eq op
    end

    it 'associates the new opportunity with the organization of the current user' do
      controller.current_user.should_receive(:organization) { org }
      VolunteerOp.should_receive(:new).with(hash_including("organization_id" => "1"))
      post :create, params
    end

    it 'non-org-owners denied' do
      controller.stub org_owner?: false
      post :create, params
      response.status.should eq 302
    end

    it 'if valid, it redirects to the created volunteer_op' do
      op.should_receive(:save) { true }
      post :create, params
      response.should redirect_to op
    end

    it 'if invalid, it re-renders the "new" template' do
      op.should_receive(:save) { false }
      post :create, params
      response.should render_template 'new'
    end
  end

  describe 'PRIVATE METHODS' do
    let(:user) { double :user }
    before { controller.stub current_user: user }

    describe '#authorize' do
      it 'Unauthorized: redirects to root_path and displays flash' do
        controller.stub org_owner?: false
        controller.should_receive(:redirect_to).with(root_path) { true } # calling original raises errors
        controller.flash.should_receive(:[]=).with(:error, 'You must be signed in as an organization owner to perform this action!').and_call_original
        controller.instance_eval { authorize }.should be false
        # can't assert `redirect_to root_path`: http://owowthathurts.blogspot.com/2013/08/rspec-response-delegation-error-fix.html
        flash[:error].should_not be_empty
      end

      it 'Authorized: allows execution to continue' do
        controller.stub org_owner?: true
        controller.instance_eval { authorize }.should be nil
      end
    end

    describe '#org_owner?' do
      context 'when current user is nil' do
        before :each do
          allow_message_expectations_on_nil
          controller.stub current_user: nil
        end

        it 'returns false' do
          controller.instance_eval { org_owner? }.should be_false
        end

        it 'first checks if there is a current_user' do
          controller.current_user.should_receive :present?
          controller.current_user.should_not_receive :organization
          controller.instance_eval { org_owner? }
        end
      end

      context 'when there is a current user present' do
        let(:org) { double :organization }
        before { user.stub organization: nil }

        it 'otherwise depends on { current_user.organization.present? }' do
          controller.instance_eval { org_owner? }.should be_false
          user.stub organization: org
          controller.instance_eval { org_owner? }.should be_true
        end

        it 'checks if the current_user has an organization' do
          controller.current_user.should_receive :organization
          user.stub organization: org
          org.should_receive :present?
          controller.instance_eval { org_owner? }
        end
      end
    end
  end
end
