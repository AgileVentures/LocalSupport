require 'rails_helper'

describe OrganisationsController, :type => :controller do
  let(:category_html_options) { [['cat1', 1], ['cat2', 2]] }

  # http://stackoverflow.com/questions/10442159/rspec-as-null-object
  # doesn't calling as_null_object on a mock negate the need to stub anything?
  def double_organisation(stubs={})
    (@double_organisation ||= mock_model(Organisation).as_null_object).tap do |organisation|
      stubs.each do |k,v|
        allow(organisation).to receive(k) { v }
      end
    end
  end

  describe '#build_map_markers' do
    render_views
    let!(:org) { create :organisation }
    let(:org_relation){Organisation.all}
    subject { JSON.parse(controller.send(:build_map_markers, org_relation)).first }
    it { expect(subject['lat']).to eq org.latitude }
    it { expect(subject['lng']).to eq org.longitude }
    it { expect(subject['infowindow']).to include org.friendly_id }
    it { expect(subject['infowindow']).to include org.name }
    it { expect(subject['infowindow']).to include org.description }
    context 'markers without coords omitted' do
      let!(:org) { mock_model Organisation, address: '150 pinner rd', latitude: nil, longitude: nil }
      it { expect(JSON.parse(controller.send(:build_map_markers, org_relation))).to be_empty }
    end
  end

  describe 'GET search' do

    let(:category_params) do
      {
        'what_id' => '',
        'who_id'  => '',
        'how_id'  => '',
      }
    end

    context 'setting appropriate view vars for all combinations of input' do
      let!(:double_organisation) { create :organisation }
      let(:markers) { 'my markers' }
      let(:result) { Organisation.all }
      let(:category) { double('Category') }
      before(:each) do
        expect(controller).to receive(:build_map_markers).and_return(markers)
        allow(Category).to receive(:what_they_do) { Category.all }
        allow(Category).to receive(:who_they_help) { Category.all }
        allow(Category).to receive(:how_they_help) { Category.all }
      end

      it 'orders search results by most recent' do
        expect(Organisation).to receive(:order_by_most_recent).and_return(result)
        expect(result).to receive(:search_by_keyword).with('test').and_return(result)
        get :search, { q: 'test' }.merge(category_params)
        expect(assigns(:organisations)).to eq([double_organisation])
      end

      it 'sets up appropriate values for view vars: query_term, organisations and markers' do
        expect(Organisation).to receive(:search_by_keyword).with('test').and_return(result)
        expect(result).to receive(:filter_by_categories).with(['1']).and_return(result)
        get :search, { q: 'test' }.merge(category_params).merge('what_id' => '1')
        expect(assigns(:parsed_params).query_term).to eq 'test'
      end

      it 'handles lack of category gracefully' do
        expect(Organisation).to receive(:search_by_keyword).with('test').and_return(result)
        get :search, { q: 'test' }.merge(category_params)
        expect(assigns(:parsed_params).query_term).to eq 'test'
      end

      it 'handles lack of query term gracefully' do
        expect(Organisation).to receive(:search_by_keyword).with('').and_return(result)
        get :search, category_params.merge({q: ''})
        expect(assigns(:parsed_params).query_term).to eq('')
      end

      it 'handles lack of id gracefully' do
        expect(Organisation).to receive(:search_by_keyword).with('test').and_return(result)
        get :search, { q: 'test' }.merge(category_params)
        expect(assigns(:parsed_params).query_term).to eq 'test'
      end

      after(:each) do
        expect(response).to render_template 'index'
        expect(response).to render_template 'layouts/two_columns_with_map'
        expect(assigns(:organisations)).to eq([double_organisation])
        expect(assigns(:markers)).to eq(markers)
        expect(assigns(:cat_name_ids)).to eq({what: [], how: [], who: []})
      end
    end

    # TODO figure out how to make this less messy
    it 'assigns to flash.now but not flash when search returns no results' do
      expect(controller).to receive(:build_map_markers).and_return('my markers')
      double_now_flash = double('FlashHash')
      result = Organisation.all
      expect(result).to receive(:empty?).and_return(true)
      expect(Organisation).to receive(:search_by_keyword).with('no results').and_return(result)
      expect(result).to receive(:filter_by_categories).with(['1']).and_return(result)
      category = double('Category')
      expect_any_instance_of(ActionDispatch::Flash::FlashHash).to receive(:now).and_return double_now_flash
      expect_any_instance_of(ActionDispatch::Flash::FlashHash).not_to receive(:[]=)
      expect(double_now_flash).to receive(:[]=).with(:alert, SEARCH_NOT_FOUND)
      get :search, { q: 'no results' }.merge(category_params).merge('what_id' => '1')
    end

    it 'does not set up flash nor flash.now when search returns results' do
      result = Organisation.all
      markers='my markers'
      expect(controller).to receive(:build_map_markers).and_return(markers)
      expect(result).to receive(:empty?).and_return(false)
      expect(Organisation).to receive(:search_by_keyword).with('some results').and_return(result)
      expect(result).to receive(:filter_by_categories).with(['1']).and_return(result)
      category = double('Category')
      get :search, { q: 'some results' }.merge(category_params).merge('what_id' => '1')
      expect(flash.now[:alert]).to be_nil
      expect(flash[:alert]).to be_nil
    end
  end

  describe 'GET index' do
    it 'assigns all organisations as @organisations' do
      result = Organisation.all
      markers='my markers'
      expect(controller).to receive(:build_map_markers).and_return(markers)
      expect(Organisation).to receive(:order_by_most_recent).and_return(result)
      get :index
      expect(assigns(:organisations)).to eq(result)
      expect(assigns(:markers)).to eq(markers)
      expect(response).to render_template 'layouts/two_columns_with_map'
    end
  end

  describe 'GET show' do
    let(:real_org){create(:organisation)}
    before(:each) do
      @user = double('User')
      allow(@user).to receive(:pending_org_admin?)
      allow(@user).to receive(:can_edit?)
      allow(@user).to receive(:can_delete?)
      allow(@user).to receive(:can_create_volunteer_ops?)
      allow(@user).to receive(:can_request_org_admin?)
      allow(controller).to receive(:current_user).and_return(@user)
    end

    it 'should use a two_column with map layout' do
      get :show, :id => real_org.id.to_s
      expect(response).to render_template 'layouts/two_columns_with_map'
    end

    it 'assigns the requested organisation as @organisation and appropriate markers' do
      markers='my markers'
      @org = real_org
      expect(controller).to receive(:build_map_markers).and_return(markers)
      get :show, :id => real_org.id.to_s
      expect(assigns(:organisation)).to eq(real_org)
      expect(assigns(:markers)).to eq(markers)
    end

    context 'editable flag is assigned to match user permission' do
      it 'user with permission leads to editable flag true' do
        expect(@user).to receive(:can_edit?).with(real_org).and_return(true)
        get :show, id: real_org.id.to_s
        expect(assigns(:editable)).to be(true)
      end

      it 'user without permission leads to editable flag false' do
        expect(@user).to receive(:can_edit?).with(real_org).and_return(true)
        get :show, id: real_org.id.to_s
        expect(assigns(:editable)).to be(true)
      end

      it 'when not signed in editable flag is nil' do
        allow(controller).to receive(:current_user).and_return(nil)
        get :show, id: real_org.id.to_s
        expect(assigns(:editable)).to be_nil
      end
    end

    context 'grabbable flag is assigned to match user permission' do
      it 'assigns grabbable to true when user can request org superadmin status' do
        allow(@user).to receive(:can_edit?)
        expect(@user).to receive(:can_request_org_admin?).with(real_org).and_return(true)
        allow(controller).to receive(:current_user).and_return(@user)
        get :show, :id => real_org.id.to_s
        expect(assigns(:grabbable)).to be(true)
      end
      it 'assigns grabbable to false when user cannot request org superadmin status' do
        allow(@user).to receive(:can_edit?)
        expect(@user).to receive(:can_request_org_admin?).with(real_org).and_return(false)
        allow(controller).to receive(:current_user).and_return(@user)
        get :show, :id => real_org.id.to_s
        expect(assigns(:grabbable)).to be(false)
      end
      it 'when not signed in grabbable flag is true' do
        allow(controller).to receive(:current_user).and_return(nil)
        get :show, :id => real_org.id.to_s
        expect(assigns(:grabbable)).to be true
      end
    end

    describe 'can_create_volunteer_op flag' do
      context 'depends on can_create_volunteer_ops?' do
        it 'true' do
          expect(@user).to receive(:can_create_volunteer_ops?) { true }
          get :show, :id => real_org.id.to_s
          expect(assigns(:can_create_volunteer_op)).to be true
        end

        it 'false' do
          expect(@user).to receive(:can_create_volunteer_ops?) { false }
          get :show, :id => real_org.id.to_s
          expect(assigns(:can_create_volunteer_op)).to be false
        end
      end

      it 'will not be called when current user is nil' do
        allow(controller).to receive_messages current_user: nil
        expect(@user).not_to receive :can_create_volunteer_ops?
        get :show, :id => real_org.id.to_s
        expect(assigns(:can_create_volunteer_op)).to be nil
      end
    end
  end

  describe 'GET new' do
    context 'while signed in' do
      before(:each) do
        user = double('User')
        allow(request.env['warden']).to receive_messages :authenticate! => user
        allow(controller).to receive(:current_user).and_return(user)
        allow(Organisation).to receive(:new) { double_organisation }
      end

      it 'assigns a new organisation as @organisation' do
        get :new
        expect(assigns(:organisation)).to be(double_organisation)
      end

      it 'should use a two_column with map layout' do
        get :new
        expect(response).to render_template 'layouts/two_columns_with_map'
      end
    end

    context 'while not signed in' do
      it 'redirects to sign-in' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET edit' do
    let(:org) { create(:organisation) }

    context 'while signed in as user who can edit' do
      before(:each) do
        user = double('User')
        allow(user).to receive(:can_edit?) { true }
        allow(request.env['warden']).to receive_messages :authenticate! => user
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'assigns the requested organisation as @organisation' do
        get :edit, id: org.id
        expect(assigns(:organisation)).to eq org
        expect(response).to render_template 'layouts/two_columns_with_map'
      end
    end
    context 'while signed in as user who cannot edit' do
      before(:each) do
        user = double('User')
        allow(user).to receive(:can_edit?) { false }
        allow(request.env['warden']).to receive_messages :authenticate! => user
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'redirects to organisation view' do
        get :edit, id: org
        expect(response).to redirect_to organisation_url(org)
      end
    end
    #TODO: way to dry out these redirect specs?
    context 'while not signed in' do
      it 'redirects to sign-in' do
        get :edit, :id => '37'
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST create', helpers: :controllers do
    context 'while signed in as superadmin' do
      let!(:org) { build :organisation }
      before(:each) do
        expect(make_current_user_superadmin).to receive(:superadmin?).and_return true
      end

      describe 'with valid params' do
        it 'assigns a newly created organisation as @organisation' do
          allow(Organisation).to receive(:new) { org }
          post :create, :organisation => {'these' => 'params'}
          expect(assigns(:organisation)).to be org
        end

        it 'redirects to the created organisation' do
          allow(Organisation).to receive(:new) { org }
          post :create, organisation: {name: 'blah'}
          expect(response).to redirect_to(organisation_url(org))
        end
      end

      describe 'with invalid params' do
        after(:each) { expect(response).to render_template 'two_columns_with_map' }

        it 'assigns a newly created but unsaved organisation as @organisation' do
          allow(Organisation).to receive(:new){ double_organisation(:save => false) }
          post :create, :organisation => {'these' => 'params'}
          expect(assigns(:organisation)).to be(double_organisation)
        end

        it 're-renders the "new" template' do
          allow(Organisation).to receive(:new) { double_organisation(:save => false) }
          post :create, organisation: {name: 'great'}
          expect(response).to render_template('new')
        end
      end
    end

    context 'while not signed in' do
      it 'redirects to sign-in' do
        allow(Organisation).to receive(:new).with({'these' => 'params'}) { double_organisation(:save => true) }
        post :create, :organisation => {'these' => 'params'}
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'while signed in as non-superadmin' do
      before(:each) do
        expect(make_current_user_nonsuperadmin).to receive(:superadmin?).and_return(false)
      end

      describe 'with valid params' do
        it 'refuses to create a new organisation' do
          # stubbing out Organisation to prevent new method from calling Gmaps APIs
          allow(Organisation).to receive(:new).with({'these' => 'params'}) { double_organisation(:save => true) }
          expect(Organisation).not_to receive :new
          post :create, :organisation => {'these' => 'params'}
        end

        it 'redirects to the organisations index' do
          allow(Organisation).to receive(:new).with({'these' => 'params'}) { double_organisation(:save => true) }
          post :create, :organisation => {'these' => 'params'}
          expect(response).to redirect_to organisations_path
        end

        it 'assigns a flash refusal' do
          allow(Organisation).to receive(:new).with({'these' => 'params'}) { double_organisation(:save => true) }
          post :create, :organisation => {'these' => 'params'}
          expect(flash[:notice]).to eq('You don\'t have permission')
        end
      end
      # not interested in invalid params
    end
  end

  describe 'PUT update' do
    let(:org) { create :organisation }
    let(:all_orgs) { double }
    context 'while signed in as user who can edit' do
      before(:each) do
        user = double('User')
        allow(user).to receive(:can_edit?) { true }
        allow(request.env['warden']).to receive_messages :authenticate! => user
        allow(controller).to receive(:current_user).and_return(user)
        
      end

      describe 'with valid params' do
        it 'updates org for e.g. donation_info url' do
          expect(Organisation).to receive(:friendly) { all_orgs }
          expect(all_orgs).to receive(:find).with('37') { org }
          expect(org).to receive(:update_attributes_with_superadmin).with({'donation_info' => 'http://www.friendly.com/donate', 'superadmin_email_to_add' => nil})
          put :update, :id => '37', :organisation => {'donation_info' => 'http://www.friendly.com/donate'}
        end

        it 'assigns the requested organisation as @organisation' do
          allow(Organisation).to receive(:friendly) { all_orgs }
          allow(all_orgs).to receive(:find) { org }
          put :update, id: '1', organisation: {'these': 'params'}
          expect(assigns(:organisation)).to be(org)
        end

        it 'redirects to the organisation' do
          allow(Organisation).to receive(:friendly) { all_orgs }
          allow(all_orgs).to receive(:find) { org }
          put :update, id: '1', organisation: {'these': 'params'}
          expect(response).to redirect_to(organisation_url(org))
        end
      end

      describe 'with invalid params' do
        let(:dbl_org) { double_organisation(update_attributes_with_superadmin: false) }
        before(:each) do 
          allow(Organisation).to receive(:friendly) { all_orgs }
          allow(all_orgs).to receive(:find) { dbl_org }
          put :update, id: '1', organisation: {'these': 'params'}
        end
        after(:each) { expect(response).to render_template 'layouts/two_columns_with_map' }

        it 'assigns the organisation as @organisation' do
          expect(assigns(:organisation)).to be(double_organisation)
        end

        it 're-renders the "edit" template' do
          expect(response).to render_template('edit')
        end
      end
    end

    context 'while signed in as user who cannot edit' do
      before(:each) do
        user = double('User')
        allow(user).to receive(:can_edit?) { false }
        allow(request.env['warden']).to receive_messages :authenticate! => user
        allow(controller).to receive(:current_user).and_return(user)
      end

      describe 'with existing organisation' do
        it 'does not update the requested organisation' do
          org = double_organisation(:id => 37)
          expect(Organisation).to receive(:friendly) { all_orgs }
          expect(all_orgs).to receive(:find).with("#{org.id}") { org }
          expect(org).not_to receive(:update_attributes)
          put :update, :id => "#{org.id}", :organisation => {'these' => 'params'}
          expect(response).to redirect_to(organisation_url("#{org.id}"))
          expect(flash[:notice]).to eq('You don\'t have permission')
        end
      end

      describe 'with non-existent organisation' do
        it 'does not update the requested organisation' do
          expect(Organisation).to receive(:friendly) { all_orgs }
          expect(all_orgs).to receive(:find).with('9999') { nil }
          put :update, id: '9999', organisation: {'these': 'params'}
          expect(response).to redirect_to(organisation_url('9999'))
          expect(flash[:notice]).to eq('You don\'t have permission')
        end
      end
    end

    context 'while not signed in' do
      it 'redirects to sign-in' do
        put :update, id: '1', organisation: {'these': 'params'}
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE destroy' do
    let(:all_orgs) { double }
    context 'while signed in as superadmin', helpers: :controllers do
      before(:each) do
        make_current_user_superadmin
      end
      it 'destroys the requested organisation and redirect to organisation list' do
        expect(Organisation).to receive(:friendly) { all_orgs }
        expect(all_orgs).to receive(:find).with('37') { double_organisation }
        expect(double_organisation).to receive(:destroy)
        delete :destroy, id: '37'
        expect(response).to redirect_to(organisations_url)
      end
    end
    context 'while signed in as non-superadmin', helpers: :controllers do
      before(:each) do
        make_current_user_nonsuperadmin
      end
      it 'does not destroy the requested organisation but redirects to organisation home page' do
        double = double_organisation
        expect(Organisation).not_to receive(:find).with('37') { double }
        expect(double).not_to receive(:destroy)
        delete :destroy, :id => '37'
        expect(response).to redirect_to(organisation_url('37'))
      end
    end
    context 'while not signed in' do
      it 'redirects to sign-in' do
        delete :destroy, :id => '37'
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  describe '.permit' do 
    it 'returns the cleaned params' do
      organisation_params = { organisation: {
                                name: 'Happy Friends', 
                                description: 'Do nice things', 
                                address: '22 Pinner Road', 
                                postcode: '12345', 
                                email: 'happy@annoting.com', 
                                website: 'www.happyplace.com', 
                                telephone: '123-456-7890', 
                                donation_info: 'www.giveusmoney.com',
                                publish_address: true, 
                                publish_phone: true, 
                                publish_email: true, 
                                category_ids: ['1','2']
                            }}
      params = ActionController::Parameters.new.merge(organisation_params)
      permitted_params = OrganisationsController::OrganisationParams.build(params)
      expect(permitted_params).to eq({name: 'Happy Friends', 
                                      description: 'Do nice things', 
                                      address: '22 Pinner Road', 
                                      postcode: '12345', email: 'happy@annoting.com', 
                                      website: 'www.happyplace.com', 
                                      telephone: '123-456-7890', 
                                      donation_info: 'www.giveusmoney.com',
                                      publish_address: true, 
                                      publish_phone: true, 
                                      publish_email: true,
                                      category_ids: ['1','2']
                                      }.with_indifferent_access)
      #attr_accessible :name, :description, :address, :postcode, :email, :website, :telephone, :donation_info, :publish_address, :publish_phone, :publish_email, :category_organisations_attributes
    end
  end
end
