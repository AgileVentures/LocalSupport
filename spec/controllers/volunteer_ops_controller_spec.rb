require 'spec_helper'
describe VolunteerOpsController do
  let(:user) { double :user }
  let(:org) { double :organization, id: '1' }
  let(:op) { double :volunteer_op, id: '9' }
  let(:ops_collection) { double :ops_collection }
  before do
    org.stub volunteer_ops: ops_collection
    op.stub organization: org
    # ops_collection.stub find: op
  end
  
  describe 'GET index' do
    before { VolunteerOp.stub all: ops_collection }
    it 'assigns all volunteer_ops as @volunteer_ops' do
      get :index, {}
      assigns(:volunteer_ops).should eq ops_collection
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
    it 'assigns all volunteer_ops as @volunteer_ops' do
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
    it 'assigns the requested volunteer_op as @volunteer_op' do
      volunteer_op = VolunteerOp.create! valid_attributes
      get :edit, {:id => volunteer_op.to_param}, valid_session
      assigns(:volunteer_op).should eq(volunteer_op)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new VolunteerOp' do
        expect {
          post :create, {:volunteer_op => valid_attributes}, valid_session
        }.to change(VolunteerOp, :count).by(1)
      end

      it 'assigns a newly created volunteer_op as @volunteer_op' do
        post :create, {:volunteer_op => valid_attributes}, valid_session
        assigns(:volunteer_op).should be_a(VolunteerOp)
        assigns(:volunteer_op).should be_persisted
      end

      it 'redirects to the created volunteer_op' do
        post :create, {:volunteer_op => valid_attributes}, valid_session
        response.should redirect_to(VolunteerOp.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved volunteer_op as @volunteer_op' do
        # Trigger the behavior that occurs when invalid params are submitted
        VolunteerOp.any_instance.stub(:save).and_return(false)
        post :create, {:volunteer_op => { 'title' => 'invalid value' }}, valid_session
        assigns(:volunteer_op).should be_a_new(VolunteerOp)
      end

      it 're-renders the "new" template' do
        # Trigger the behavior that occurs when invalid params are submitted
        VolunteerOp.any_instance.stub(:save).and_return(false)
        post :create, {:volunteer_op => { 'title' => 'invalid value' }}, valid_session
        response.should render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested volunteer_op' do
        volunteer_op = VolunteerOp.create! valid_attributes
        # Assuming there are no other volunteer_ops in the database, this
        # specifies that the VolunteerOp created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        VolunteerOp.any_instance.should_receive(:update_attributes).with({ 'title' => 'MyString' })
        put :update, {:id => volunteer_op.to_param, :volunteer_op => { 'title' => 'MyString' }}, valid_session
      end

      it 'assigns the requested volunteer_op as @volunteer_op' do
        volunteer_op = VolunteerOp.create! valid_attributes
        put :update, {:id => volunteer_op.to_param, :volunteer_op => valid_attributes}, valid_session
        assigns(:volunteer_op).should eq(volunteer_op)
      end

      it 'redirects to the volunteer_op' do
        volunteer_op = VolunteerOp.create! valid_attributes
        put :update, {:id => volunteer_op.to_param, :volunteer_op => valid_attributes}, valid_session
        response.should redirect_to(volunteer_op)
      end
    end

    describe 'with invalid params' do
      it 'assigns the volunteer_op as @volunteer_op' do
        volunteer_op = VolunteerOp.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        VolunteerOp.any_instance.stub(:save).and_return(false)
        put :update, {:id => volunteer_op.to_param, :volunteer_op => { 'title' => 'invalid value' }}, valid_session
        assigns(:volunteer_op).should eq(volunteer_op)
      end

      it 're-renders the "edit" template' do
        volunteer_op = VolunteerOp.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        VolunteerOp.any_instance.stub(:save).and_return(false)
        put :update, {:id => volunteer_op.to_param, :volunteer_op => { 'title' => 'invalid value' }}, valid_session
        response.should render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested volunteer_op' do
      volunteer_op = VolunteerOp.create! valid_attributes
      expect {
        delete :destroy, {:id => volunteer_op.to_param}, valid_session
      }.to change(VolunteerOp, :count).by(-1)
    end

    it 'redirects to the volunteer_ops list' do
      volunteer_op = VolunteerOp.create! valid_attributes
      delete :destroy, {:id => volunteer_op.to_param}, valid_session
      response.should redirect_to(volunteer_ops_url)
    end
  end

end
