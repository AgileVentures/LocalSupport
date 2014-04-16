require 'spec_helper'
describe VolunteerOpsController do
  let(:user) { double :user }
  let(:org) { double :organization, id: '1' }
  let(:op) { double :volunteer_op, id: '9' }
#  before do
#    op.stub organization: org
#  end

  describe 'GET show' do
    before { VolunteerOp.stub find: op }

    it 'assigns the requested volunteer_op as @volunteer_op' do
      get :show, {:id => op.id}
      assigns(:volunteer_op).should eq(op)
    end

    it 'non-org-owners allowed' do
      controller.stub current_user: user, org_owner?: false
      get :show, {:id => op.id}
      response.status.should eq 200
    end

    it 'mutation-proofing' do
      VolunteerOp.should_receive(:find).with(op.id)
      get :show, {:id => op.id}
    end
  end

  describe 'GET new' do
    before do
      controller.stub current_user: user, org_owner?: true
      VolunteerOp.stub new: op
    end

    it 'assigns the requested volunteer_op as @volunteer_op' do
      get :new, {}
      assigns(:volunteer_op).should eq op
    end

    it 'non-org-owners denied' do
      controller.stub org_owner?: false
      get :new, {}
      response.status.should eq 302
    end

    it 'mutation-proofing' do
      VolunteerOp.should_receive(:new)
      get :new, {}
    end
  end

  describe 'POST create' do
    let(:op) { stub_model VolunteerOp, id: '9' }
    let(:attributes) { {title: 'hard work', description: 'for the willing'} }
    before do
      controller.stub current_user: user, org_owner?: true
      VolunteerOp.stub new: op
      op.stub save: true
    end

    it 'assigns a newly created volunteer_op as @volunteer_op' do
      post :create, {volunteer_op: attributes}
      assigns(:volunteer_op).should eq op
    end

		it 'associates the new opportunity with the organization of the current user' do
			controller.current_user.should_receive(:organization) { org }
			op.should_receive(:organization=).with(org)
      post :create, {volunteer_op: attributes}
		end

    it 'non-org-owners denied' do
      controller.stub org_owner?: false
      post :create, {volunteer_op: attributes}
      response.status.should eq 302
    end

    it 'mutation-proofing' do
      VolunteerOp.should_receive(:new).with(attributes.stringify_keys) { op }
      op.should_receive :save
      post :create, {volunteer_op: attributes}
    end

    it 'redirects to the created volunteer_op' do
      post :create, {volunteer_op: attributes}
      response.should redirect_to(op)
    end

    it 'with invalid attributes, it re-renders the "new" template' do
      op.stub save: false
      post :create, {volunteer_op: attributes}
      response.should render_template('new')
    end
  end

  describe 'PRIVATE METHODS' do
    let(:user) { double :user }
    before { controller.stub current_user: user }

    context '#authorize' do
      it 'Unauthorized: redirects to root_path and displays flash' do
        controller.stub org_owner?: false
        # http://owowthathurts.blogspot.com/2013/08/rspec-response-delegation-error-fix.html
        controller.should_receive(:redirect_to).with(root_path) { true } # can't assert `redirect_to root_path`
        controller.instance_eval { authorize }.should be false
        flash[:error].should_not be_empty
      end

      it 'Authorized: allows execution to continue' do
        controller.stub org_owner?: true
        controller.instance_eval { authorize }.should be nil
      end

      it 'mutation-proofing' do
        controller.stub org_owner?: false
        controller.should_receive :redirect_to
        controller.flash.should_receive(:[]=).with(:error, "You must be signed in as an organization owner to perform this action!")
        controller.instance_eval { authorize }.should be false
      end
    end

    context '#org_owner?' do
      context 'when current user is nil' do
        before { controller.stub current_user: nil }

        it 'returns false' do
          controller.instance_eval { org_owner? }.should be_false
        end
        
        it 'mutation-proofing' do
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

        it 'mutation-proofing' do
          controller.current_user.should_receive :organization
          user.stub organization: org
          org.should_receive :present?
          controller.instance_eval { org_owner? }
        end
      end
    end
  end
end
