

RSpec.describe EventsController, type: :controller, helpers: :requests do
  let(:organisation) { FactoryBot.create(:organisation) }
  let(:valid_attributes) do
    {
        title: 'comic-con',
        description: 'superheroes',
        start_date: Date.today,
        end_date: Date.today + 3.hours,
        organisation_id: organisation.id,
        address: "4 pinner road"
    }
  end

  let(:invalid_attributes) do
    {
        title: 'comic-con',
        description: 'superheroes',
        start_date: Date.today,
        end_date: Date.today + 3.hours
    }
  end

  describe 'GET #index' do
    it 'assigns upcoming events as @events' do
      @events = Event.upcoming(10)
      @markers = BuildMarkersWithInfoWindow
                     .with(Event.build_by_coordinates(@events), self)

      get :index, params: {}
      expect(response).to be_success
      expect(assigns(:markers)).to eq(@markers)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      event = Event.create! valid_attributes
      get :show, params: {id: event.to_param}
      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      request.env['devise.mapping'] = Devise.mappings[:superadmin]
      sign_in FactoryBot.create(:superadmin)
      get :new, params: {}
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    before(:each) do
      request.env['devise.mapping'] = Devise.mappings[:superadmin]
      sign_in FactoryBot.create(:superadmin)
    end

    context 'with valid params' do
      it 'creates a new Event' do
        expect do
          post :create, params: { event: valid_attributes }
        end.to change(Event, :count).by(1)
      end

      it 'redirects to the created event' do
        post :create, params: {event: valid_attributes}
        expect(response).to redirect_to(Event.last)
      end
      
      it 'assigns the address in params to address attribute' do
        post :create, params: { event: valid_attributes }
        expect(assigns(:event).attributes.symbolize_keys[:address]).to eq("4 pinner road")
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { event: invalid_attributes }
        expect(response).to be_success
      end
    end
  end
end
