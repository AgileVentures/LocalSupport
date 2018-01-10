require "rails_helper"

describe EventsController, type: :controller do
  describe 'GET index' do
    it 'assigns upcoming events as @events' do
      @events = Event.upcoming(10)
      @markers = BuildMarkersWithInfoWindow.with(Event.build_by_coordinates(@events), self)

      get :index
      
      expect(assigns(:markers)).to eq(@markers)
      expect(response).to be_successful
      expect(response).to render_template(:index)
    end
  end
end
