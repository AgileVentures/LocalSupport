require 'spec_helper'
describe VolunteerOpsController do
  let(:user) { double :user }
  let(:org) { double :organization, id: '1' }
  let(:op) { double :volunteer_op, id: '9' }
  before do
    op.stub organization: org
  end

  describe 'GET index' do
    before { VolunteerOp.stub all: [op] }

    it 'assigns all volunteer_ops as @volunteer_ops' do
      get :index, {}
      assigns(:volunteer_ops).should eq [op]
    end

    it 'non-org-owners allowed' do
      controller.stub current_user: user, org_owner?: false
      get :index, {}
      response.status.should eq 200
    end

    it 'mutation-proofing' do
      VolunteerOp.should_receive(:all)
      get :index, {}
    end
  end

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

  describe 'GET edit' do
    before do
      controller.stub current_user: user, org_owner?: true
      VolunteerOp.stub find: op
    end

    it 'assigns the requested volunteer_op as @volunteer_op' do
      get :edit, {:id => op.id}
      assigns(:volunteer_op).should eq op
    end

    it 'non-org-owners denied' do
      controller.stub org_owner?: false
      get :edit, {:id => op.id}
      response.status.should eq 302
    end

    it 'mutation-proofing' do
      VolunteerOp.should_receive(:find).with(op.id)
      get :edit, {:id => op.id}
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

  describe 'PUT update' do
    let(:op) { stub_model VolunteerOp, id: '9' }
    let(:attributes) { {title: 'hard work', description: 'for the willing'} }
    before do
      controller.stub current_user: user, org_owner?: true
      VolunteerOp.stub find: op
      op.stub update_attributes: true
    end

    it 'assigns a the volunteer_op to be updated as @volunteer_op' do
      post :update, {id: op.id, volunteer_op: attributes}
      assigns(:volunteer_op).should eq op
    end

    it 'non-org-owners denied' do
      controller.stub org_owner?: false
      post :update, {id: op.id, volunteer_op: attributes}
      response.status.should eq 302
    end

    it 'mutation-proofing' do
      VolunteerOp.should_receive(:find).with(op.id.to_s)
      op.should_receive(:update_attributes ).with(attributes.stringify_keys)
      post :update, {id: op.id, volunteer_op: attributes}
    end

    it 'redirects to the updated volunteer_op' do
      post :update, {id: op.id, volunteer_op: attributes}
      response.should redirect_to(op)
    end

    it 'with invalid attributes, it re-renders the "edit" template' do
      op.stub update_attributes: false
      post :update, {id: op.id, volunteer_op: attributes}
      response.should render_template('edit')
    end
  end

  describe 'DELETE destroy' do
    before do
      controller.stub current_user: user, org_owner?: true
      VolunteerOp.stub find: op
      op.stub :destroy
    end

    it 'non-org-owners denied' do
      controller.stub current_user: user, org_owner?: false
      delete :destroy, { id: op.id }
      response.status.should eq 302
    end

    it 'mutation-proofing' do
      VolunteerOp.should_receive(:find).with(op.id)
      delete :destroy, { id: op.id }
    end

    it 'redirects to the volunteer_ops list' do
      delete :destroy, { id: op.id }
      response.should redirect_to(volunteer_ops_url)
    end
  end

end
