require 'rails_helper'

describe VolunteerOpsController, :type => :controller do
  describe 'GET #index' do
    it 'assigns @volunteer_ops variable' do
      get :index
      expect(assigns(:volunteer_ops)).to_not eq nil
    end
    
    it 'assigns @markers variable' do
      get :index
      expect(assigns(:markers)).to_not eq nil
    end
    
    it 'returns status 200' do
      get :index
      expect(response.status).to eq 200
    end
    
    it 'renders index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end
end