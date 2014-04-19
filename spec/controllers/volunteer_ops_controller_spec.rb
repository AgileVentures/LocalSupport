require 'spec_helper'
describe VolunteerOpsController do
  let(:user) { double :user }
  let(:org) { double :organization, id: '1' }
  let!(:op) { stub_model VolunteerOp } # stack level too deep errors if stub_model is loaded lazily in some contexts

  describe 'GET show' do
    it 'assigns the requested volunteer_op as @volunteer_op' do
      controller.stub org_owner?: true
      VolunteerOp.should_receive(:find).with(op.id.to_s) { op }
      get :show, {:id => op.id}
      assigns(:volunteer_op).should eq op
    end

    it 'non-org-owners allowed' do
      controller.stub org_owner?: false
      VolunteerOp.stub(:find)
      get :show, {:id => op.id}
      response.status.should eq 200
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
      VolunteerOp.should_receive(:new).with(hash_including(organization: org))
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
        before { controller.stub current_user: nil }

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
