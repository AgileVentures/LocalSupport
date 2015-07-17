require 'rails_helper'
describe VolunteerOpsController, :type => :controller do
  it "should render template two column with map layout"  do
    get :index
    expect(response).to render_template 'index'
    expect(response).to render_template 'layouts/two_columns_with_map'
  end
end

describe VolunteerOpsController, :type => :controller do
  let(:user) { double :user }
  let(:org) { double :organisation, id: '1' }
  let!(:op) { stub_model VolunteerOp } # stack level too deep errors if stub_model is loaded lazily in some contexts
  describe 'strong params' do
    before do
      @org = stub_model Organisation, :name => "title", :description => "description"
      @op2 = stub_model VolunteerOp, :organisation => (@org)
    end
    it '#update uses strong params' do
      put :update, :id => @op2.to_param, :volunteer_op => {:title => "new title", :description => "new description"}
      expect(controller.volunteer_op_params).to eq(
        {"description" => "new description",
         "title" => "new title"}
      )
    end
  end

  describe "#build_map_markers" do
    render_views
    let(:org) { create :organisation }
    let!(:op) { create :volunteer_op, organisation: org }
    subject { JSON.parse(controller.send(:build_map_markers, [org])).first }
    it { expect(subject['lat']).to eq org.latitude }
    it { expect(subject['lng']).to eq org.longitude }
    it { expect(subject['infowindow']).to include org.id.to_s }
    it { expect(subject['infowindow']).to include org.name }
    it { expect(subject['infowindow']).to include op.id.to_s }
    it { expect(subject['infowindow']).to include op.title }
    it { expect(subject['infowindow']).to include op.description }
    context 'markers without coords omitted' do
      let(:org) { create :organisation, address: "0 pinnner road", latitude: nil, longitude: nil }
      it { expect(JSON.parse(controller.send(:build_map_markers, [org]))).to be_empty }
    end
  end

  describe 'GET index' do
    before :each do
      @results = [op]
      allow(VolunteerOp).to receive(:order_by_most_recent).and_return(@results)
    end

    it 'assigns all volunteer_ops as @volunteer_ops' do
      op2 = stub_model VolunteerOp, :organisation => (stub_model Organisation)
      @results = [op2]
      expect(VolunteerOp).to receive(:order_by_most_recent).and_return(@results)
      get :index, {}
      expect(assigns(:volunteer_ops)).to eq @results
    end

    it 'assigns all volunteer_op orgs as @organisations' do
      org2 = stub_model Organisation
      allow(@results).to receive(:map).and_return([org2])
      get :index, {}
      expect(assigns(:organisations)).to eq([org2])
    end

    it 'assigns @markers' do
      markers = 'my markers'
      org2 = stub_model Organisation
      allow(@results).to receive(:map).and_return([org2])
      expect(controller).to receive(:build_map_markers).and_return(markers)
      get :index, {}
      expect(assigns(:markers)).to eq(markers)
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
      expect(assigns(:volunteer_op)).to eq @op2
    end

    it 'non-org-owners allowed' do
      allow(controller).to receive(:org_owner?).and_return(false)
      get :show, {:id => @op2.id}
      expect(response.status).to eq 200
    end

    it "passes a true editable flag when superadmin user" do
      allow(controller).to receive(:current_user).and_return(user)
      allow(user).to receive(:can_edit?).with(@org).and_return(true)
      get :show, {:id => @op2.id}
      expect(assigns(:editable)).to be_truthy
    end

    it "passes a false editable flag when guest user" do
      # allow(controller).to_receive(:user).and_return(nil)
      allow(controller).to receive(:current_user).and_return(nil)
      @results = [@op2]
      allow(VolunteerOp).to receive(:find).with(@op2.id.to_s) { @op2 }
      get :show, {:id => @op2.id}
      expect(assigns(:editable)).to be_falsey
    end
  end

  describe 'GET new' do
    it 'assigns the requested volunteer_op as @volunteer_op' do
      allow(controller).to receive_messages org_owner?: true
      expect(VolunteerOp).to receive(:new) { op }
      get :new, {:organisation_id => 2}
      expect(assigns(:volunteer_op)).to eq op
    end

    it 'non-org-owners denied' do
      allow(controller).to receive_messages org_owner?: false
      get :new, {:organisation_id => 2}
      expect(response.status).to eq 302
    end
  end

  describe 'POST create' do
    let(:params) { {organisation_id: 5, volunteer_op: {title: 'hard work', description: 'for the willing'}} }
    before do
      allow(user).to receive(:organisation) { org }
      allow(controller).to receive_messages current_user: user, org_owner?: true, superadmin?: false
      allow(VolunteerOp).to receive(:new) { op }
      allow(op).to receive(:save)
    end

    it 'assigns a newly created volunteer_op as @volunteer_op' do
      post :create, params
      expect(assigns(:volunteer_op)).to eq op
    end

    it 'associates the new opportunity with the organisation' do
      expect(VolunteerOp).to receive(:new).with(hash_including("organisation_id" => "5"))
      post :create, params
    end

    it 'non-org-owners denied' do
      allow(controller).to receive_messages org_owner?: false
      post :create, params
      expect(response.status).to eq 302
    end

    it 'if valid, it redirects to the created volunteer_op' do
      expect(op).to receive(:save) { true }
      post :create, params
      expect(response).to redirect_to op
    end

    it 'if invalid, it re-renders the "new" template' do
      expect(op).to receive(:save) { false }
      post :create, params
      expect(response).to render_template 'new'
    end
  end

  describe 'GET edit' do
    before do
      @org = stub_model Organisation
      @op2 = stub_model VolunteerOp, :organisation => (@org)
      @results = [@op2]
      allow(VolunteerOp).to receive(:find).with(@op2.id.to_s).and_return(@op2)
    end
    context 'superadmin user logged in' do
      before do
        allow(controller).to receive(:org_owner?).and_return(true)
        allow(controller).to receive(:current_user).and_return(user)
      end
      it 'assigns the requested volunteer_op as @volunteer_op' do
        get :edit, {:id => @op2.id}
        expect(assigns(:volunteer_op)).to eq @op2
      end
      it 'assigns an organisation' do
        get :edit, {:id => @op2.id}
        expect(assigns(:organisation)).to eq @org
      end
      it 'renders the edit template' do
        get :edit, {:id => @op2.id}
        expect(response).to render_template 'edit'
      end
    end
    context 'non-superadmin user logged in' do
      before do
        allow(controller).to receive(:org_owner?).and_return(false)
      end
      it 'does not render the edit template' do
        get :edit, {:id => @op2.id}
        expect(response).not_to render_template 'edit'
      end
    end

  end

  describe 'POST update' do
    before do
      @org = stub_model Organisation, :name => "title", :description => "description"
      @op2 = stub_model VolunteerOp, :organisation => (@org)
      @results = [@op2]
    end
    context 'user is authorized' do
      before do
        allow(controller).to receive(:authorize).and_return(true)
        expect(VolunteerOp).to receive(:find).with(@op2.id.to_s).and_return(@op2)
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
        expect(response).to redirect_to volunteer_op_path(@op2)
      end
      it 'redirects to the edit page on failure' do
        expect(@op2).to receive(:update_attributes).and_return false
        put :update, {volunteer_op: {title: "blah"}, id: @op2.to_param}
        expect(response).to render_template 'edit'
      end
    end
    context 'user is not authorized' do
      it 'does not update the model' do
        allow(controller).to receive_messages org_owner?: false, superadmin?: false
        expect(@op2).not_to receive(:update_attributes)
        put :update, {:volunteer_op => {:title => "new title", :description => "new description"}, 
          :id => @op2.to_param}
      end
    end
  end

  describe 'PRIVATE METHODS' do
    let(:user) { double :user }
    before { allow(controller).to receive_messages current_user: user }

    describe '#authorize' do
      it 'Unauthorized: redirects to root_path and displays flash' do
        allow(controller).to receive_messages org_owner?: false
        allow(controller).to receive_messages superadmin?: false
        expect(controller).to receive(:redirect_to).with(root_path) { true } # calling original raises errors
        expect(controller.flash).to receive(:[]=).with(:error, 'You must be signed in as an organisation owner or site superadmin to perform this action!').and_call_original
        expect(controller.instance_eval { authorize }).to be_falsey
        # can't assert `redirect_to root_path`: http://owowthathurts.blogspot.com/2013/08/rspec-response-delegation-error-fix.html
        expect(flash[:error]).not_to be_empty
      end

      it 'Authorized: allows execution to continue' do
        allow(controller).to receive_messages org_owner?: true
        expect(controller.instance_eval { authorize }).to be nil
      end
    end

    describe '#org_owner?' do
      context 'when current user is nil' do
        before :each do
          allow_message_expectations_on_nil
          allow(controller).to receive_messages current_user: nil
        end

        it 'returns a falsey value' do
          expect(controller.instance_eval { org_owner? }).to be_falsey
        end
      end

      context 'when there is a current user present' do
        let(:org) { mock_model Organisation, :id => 5 }
        before { allow(user).to receive_messages organisation: nil }

        it 'depends on { current_user.organisation.id == params[:organisation_id] }' do
          allow(controller).to receive(:params){{organisation_id: "5" }}
          expect(controller.instance_eval { org_owner? }).to be_falsey
          allow(user).to receive_messages organisation: org
          expect(controller.instance_eval { org_owner? }).to be_truthy
        end

        it 'checks if the current_user has an organisation' do
          expect(controller.current_user).to receive :organisation
          allow(user).to receive_messages organisation: org
          expect(org).to receive :present?
          controller.instance_eval { org_owner? }
        end
      end
    end
  end
end
