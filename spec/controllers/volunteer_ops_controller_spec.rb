require 'spec_helper'
describe VolunteerOpsController do
  it "should render template two column layout"  do
    get :index
    response.should render_template 'index'
    response.should render_template 'layouts/two_columns'
  end
end

describe VolunteerOpsController do
  let(:user) { double :user }
  let(:org) { double :organisation, id: '1' }
  let!(:op) { stub_model VolunteerOp } # stack level too deep errors if stub_model is loaded lazily in some contexts
  describe ".permit" do 
    it "returns the cleaned params" do
      vol_ops_params = { volunteer_op: {title: "Opp", organisation_id: "1", description: "Great op"}}
      params = ActionController::Parameters.new.merge(vol_ops_params)
      permitted_params = VolunteerOpsController::VolunteerOpParams.build(params)
      expect(permitted_params).to eq({title: "Opp", organisation_id: "1", description: "Great op"}.with_indifferent_access)
    end
  end

  describe 'GET index' do
    before :each do
      @results = [op]
      VolunteerOpsController.any_instance.stub(:gmap4rails_with_popup_partial)
      VolunteerOp.stub(:order_by_most_recent).and_return(@results)
    end

    it 'assigns all volunteer_ops as @volunteer_ops' do
      op2 = stub_model VolunteerOp, :organisation => (stub_model Organisation)
      @results = [op2]
      VolunteerOp.should_receive(:order_by_most_recent).and_return(@results)
      get :index, {}
      assigns(:volunteer_ops).should eq @results
    end

    it 'assigns all volunteer_op orgs as @organisations' do
      org2 = stub_model Organisation
      @results.stub(:map).and_return([org2])
      get :index, {}
      assigns(:organisations).should eq([org2])
    end

    it 'assigns @json' do
      json = 'my markers'
      org2 = stub_model Organisation
      @results.stub(:map).and_return([org2])
      controller.should_receive(:gmap4rails_with_popup_partial).and_return(json)
      get :index, {}
      assigns(:json).should eq(json)
    end
  end

  describe 'GET show' do
    before do
      @org = stub_model Organisation
      @op2 = stub_model VolunteerOp, :organisation => (@org)
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
      get :new, {:organisation_id => 2}
      assigns(:volunteer_op).should eq op
    end

    it 'non-org-owners denied' do
      controller.stub org_owner?: false
      get :new, {:organisation_id => 2}
      response.status.should eq 302
    end
  end

  describe 'POST create' do
    let(:params) { {organisation_id: 5, volunteer_op: {title: 'hard work', description: 'for the willing'}} }
    before do
      user.stub(:organisation) { org }
      controller.stub current_user: user, org_owner?: true, admin?: false
      VolunteerOp.stub(:new) { op }
      op.stub(:save)
    end

    it 'assigns a newly created volunteer_op as @volunteer_op' do
      post :create, params
      assigns(:volunteer_op).should eq op
    end

    it 'associates the new opportunity with the organisation' do
      VolunteerOp.should_receive(:new).with(hash_including("organisation_id" => "5"))
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

  describe 'GET edit' do
    before do
      @org = stub_model Organisation
      @op2 = stub_model VolunteerOp, :organisation => (@org)
      @results = [@op2]
      allow(VolunteerOp).to receive(:find).with(@op2.id.to_s).and_return(@op2)
    end
    context 'admin user logged in' do
      before do
        allow(controller).to receive(:org_owner?).and_return(true)
        allow(controller).to receive(:current_user).and_return(user)
      end
      it 'assigns the requested volunteer_op as @volunteer_op' do
        get :edit, {:id => @op2.id}
        assigns(:volunteer_op).should eq @op2
      end
      it 'assigns an organisation' do
        get :edit, {:id => @op2.id}
        expect(assigns(:organisation)).to eq @org
      end
      it 'renders the edit template' do
        get :edit, {:id => @op2.id}
        response.should render_template 'edit'
      end
    end
    context 'non-admin user logged in' do
      before do
        allow(controller).to receive(:org_owner?).and_return(false)
      end
      it 'does not render the edit template' do
        get :edit, {:id => @op2.id}
        response.should_not render_template 'edit'
      end
    end

  end

  describe 'POST update' do
    before do
      @org = stub_model Organisation, :title => "title", :description => "description"
      @op2 = stub_model VolunteerOp, :organisation => (@org)
      @results = [@op2]
      expect(VolunteerOp).to receive(:find).with(@op2.id.to_s).and_return(@op2)
    end
    context 'user is authorized' do
      before do
        allow(controller).to receive(:authorize).and_return(true)
      end
      it 'updates the model' do
        expect(@op2).to receive(:update_attributes).with({"title" => "new title", "description" => "new description"})
        put :update, :id => @op2.to_param, :volunteer_op => {:title => "new title", :description => "new description"}
      end
      it 'sets a flash message for success' do
        expect(@op2).to receive(:update_attributes).and_return true
        put :update, {volunteer_op: {title: "blah"}, id: @op2.to_param}
        expect(flash[:notice]).not_to be_nil
      end
      it 'redirects to the show page on success' do
        expect(@op2).to receive(:update_attributes).and_return true
        put :update, {volunteer_op: {title: "blah"}, id: @op2.to_param}
        response.should redirect_to volunteer_op_path(@op2)
      end
      it 'redirects to the edit page on failure' do
        expect(@op2).to receive(:update_attributes).and_return false
        put :update, {volunteer_op: {title: "blah"}, id: @op2.to_param}
        response.should render_template 'edit'
      end
    end
    context 'user is not authorized' do
      before do
        allow(controller).to receive(:authorize).and_return(false)
      end
      it 'does not update the model' do
        expect(@op2).not_to receive(:update_attributes).and_return true
        put :update, {:volunteer_op => {:title => "new title", :description => "new description"}, 
          :id => @op2.to_param}
      end
    end
  end

  describe 'PRIVATE METHODS' do
    let(:user) { double :user }
    before { controller.stub current_user: user }

    describe '#authorize' do
      it 'Unauthorized: redirects to root_path and displays flash' do
        controller.stub org_owner?: false
        controller.stub admin?: false
        controller.should_receive(:redirect_to).with(root_path) { true } # calling original raises errors
        controller.flash.should_receive(:[]=).with(:error, 'You must be signed in as an organisation owner or site admin to perform this action!').and_call_original
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
      end

      context 'when there is a current user present' do
        let(:org) { mock_model Organisation, :id => 5 }
        before { user.stub organisation: nil }

        it 'depends on { current_user.organisation.id == params[:organisation_id] }' do
          controller.stub(:params){{organisation_id: "5" }}
          controller.instance_eval { org_owner? }.should be_false
          user.stub organisation: org
          controller.instance_eval { org_owner? }.should be_true
        end

        it 'checks if the current_user has an organisation' do
          controller.current_user.should_receive :organisation
          user.stub organisation: org
          org.should_receive :present?
          controller.instance_eval { org_owner? }
        end
      end
    end
  end
end
