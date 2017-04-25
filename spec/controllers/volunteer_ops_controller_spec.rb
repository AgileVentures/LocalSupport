require 'rails_helper'

describe VolunteerOpsController, :type => :controller do
  describe 'GET #index' do
    before(:each) { get :index }
    
    it 'assigns @volunteer_ops variable' do
      expect(assigns(:volunteer_ops)).to be_instance_of Array
    end
    
    it 'assigns @markers variable' do
      expect(assigns(:markers)).to_not eq nil
    end
    
    it 'returns status 200' do
      expect(response.status).to eq 200
    end
    
    it 'renders index template' do
      expect(response).to render_template(:index)
    end
  end
end