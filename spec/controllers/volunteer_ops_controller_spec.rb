require 'rails_helper'

RSpec.describe VolunteerOpsController, type: :controller, helpers: :requests do
  let(:organisation) { FactoryBot.create(:organisation) }
  let(:valid_attributes) do
    {
        description: Faker::Superhero.descriptor,
        title: Faker::Book.title,
        organisation_id: organisation.id,
        address: Faker::Address.full_address,
        postcode: Faker::Address.postcode
    }
  end

  let(:invalid_attributes) do
    {
        description: Faker::Superhero.descriptor,
        title: Faker::Book.title,
        address: Faker::Address.full_address,
        postcode: Faker::Address.postcode,
        post_to_doit: ''
    }
  end

  describe 'GET #index' do
    it 'volunteer opportunities' do
      FactoryBot.create(:volunteer_op, valid_attributes)
      @markers = BuildMarkersWithInfoWindow.with(
          VolunteerOp.build_by_coordinates,
          VolunteerOpsController.new
      )
      get :index, params: {}
      expect(response).to be_success
      expect(assigns(:markers)).to eq(@markers)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #search' do
    it 'should search volunteer opportunities' do
      volunteer_op = FactoryBot.create(:volunteer_op, title: 'nisevi', organisation: organisation)
      FactoryBot.create(:volunteer_op, title: 'hulk', organisation: organisation)
      get :search, params: { q: 'nisevi' }
      expect(response).to be_success
      expect(response).to render_template(:index)
      expect(assigns(:volunteer_ops)).to eq([volunteer_op])
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      volunteer_op = VolunteerOp.create! valid_attributes
      get :show, params: { id: volunteer_op.to_param }
      expect(response).to be_success
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      request.env['devise.mapping'] = Devise.mappings[:superadmin]
      sign_in FactoryBot.create(:superadmin)
      volunteer_op = VolunteerOp.create! valid_attributes
      get :edit, params: { id: volunteer_op.to_param }
      expect(response).to be_success
    end
  end

  describe 'PUT #update' do
    before(:each) do
      request.env['devise.mapping'] = Devise.mappings[:superadmin]
      sign_in FactoryBot.create(:superadmin)
    end

    context 'with valid params' do
      let(:new_attributes) do
        {
            description: 'New description',
            title: 'Super awesome title'
        }
      end

      it 'updates the requested high_score' do
        volunteer_op = VolunteerOp.create! valid_attributes
        put :update, params: { id: volunteer_op.to_param, volunteer_op: new_attributes }
        volunteer_op.reload
        expect(volunteer_op.title).to eq('Super awesome title')
        expect(volunteer_op.description).to eq('New description')
      end

      it 'redirects to the volunteer_op' do
        volunteer_op = VolunteerOp.create! valid_attributes
        put :update, params: { id: volunteer_op.to_param, volunteer_op: valid_attributes }
        expect(response).to redirect_to(volunteer_op)
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      request.env['devise.mapping'] = Devise.mappings[:superadmin]
      sign_in FactoryBot.create(:superadmin)
    end

    it 'destroys the requested volunteer_op' do
      volunteer_op = VolunteerOp.create! valid_attributes
      expect do
        delete :destroy, params: { id: volunteer_op.to_param }
      end.to change(VolunteerOp, :count).by(-1)
    end

    it 'redirects to the volunteer_ops list' do
      volunteer_op = VolunteerOp.create! valid_attributes
      delete :destroy, params: { id: volunteer_op.to_param }
      expect(response).to redirect_to(volunteer_ops_url)
    end
  end

  describe '#embedded_map' do
    it 'volunteer opportunities' do
      FactoryBot.create(:volunteer_op, valid_attributes)
      @markers = BuildMarkersWithInfoWindow.with(
          VolunteerOp.build_by_coordinates,
          VolunteerOpsController.new
      )
      get :index, params: {iframe: true}
      expect(response).to be_success
      expect(assigns(:markers)).to eq(@markers)
    end
  end
end