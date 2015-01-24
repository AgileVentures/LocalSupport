require 'rails_helper'

describe PagesController, :type => :controller do
  let(:page) { mock_model Page, id: '2' }

  before { allow(controller).to receive(:superadmin?) { true } }

  describe 'GET index' do
    it 'is restricted' do
      expect(controller).to receive(:superadmin?) { false }
      get :index, {}
      expect(response.status).to eq 302
    end

    it 'uses a full-width layout' do
      get :index, {}
      expect(response).to render_template 'layouts/full_width'
    end

    it "assigns the pages in alphabetical order by default" do
      pages = double Array
      expect(Page).to receive(:order).with('name ASC').and_return pages
      get :index, {}
      expect(assigns(:pages)).to eq(pages)
    end
  end

  describe 'GET show' do
    let(:about_page) { double :page,
                              name: 'About Us',
                              permalink: 'about',
                              content: 'blah blah'
    }
    let(:user) { double :user }

    describe 'assigns site superadmin status of current_user to @superadmin' do
      it 'NIL when there is no current_user' do
        get :show, {id: 'about'}
        expect(assigns(:superadmin)).to be nil
      end
      it 'FALSE when current_user is NOT superadmin' do
        allow(user).to receive(:superadmin?) { false }
        allow(controller).to receive(:current_user) { user }
        get :show, {id: 'about'}
        expect(assigns(:superadmin)).to be false
      end

      it 'TRUE when current_user is superadmin' do
        allow(user).to receive(:superadmin?) { true }
        allow(controller).to receive(:current_user) { user }
        get :show, {id: 'about'}
        expect(assigns(:superadmin)).to be true
      end
    end

    it 'assigns a persisted page as @page' do
      expect(Page).to receive(:find_by_permalink!).with('about') { about_page }
      get :show, {id: 'about'}
      expect(assigns(:page)).to eq about_page
    end

    before do
      allow(controller).to receive(:current_user)
      allow(Page).to receive(:find_by_permalink!)
    end

    describe 'assigns site superadmin status of current_user to @superadmin' do
      it 'NIL when there is no current_user' do
        get :show, {id: 'about'}
        expect(assigns(:superadmin)).to be nil
      end
      it 'FALSE when current_user is NOT superadmin' do
        allow(user).to receive(:superadmin?) { false }
        allow(controller).to receive(:current_user) { user }
        get :show, {id: 'about'}
        expect(assigns(:superadmin)).to be false
      end

      it 'TRUE when current_user is superadmin' do
        allow(user).to receive(:superadmin?) { true }
        allow(controller).to receive(:current_user) { user }
        get :show, {id: 'about'}
        expect(assigns(:superadmin)).to be true
      end
    end

    it 'assigns a persisted page as @page' do
      expect(Page).to receive(:find_by_permalink!).with('about') { about_page }
      get :show, {id: 'about'}
      expect(assigns(:page)).to eq about_page
    end

    it 'is NOT restricted' do
      expect(controller).not_to receive(:superadmin?)
      get :show, {id: 'about'}
      expect(response.status).to eq 200
    end

    it 'uses a full-width layout' do
      get :show, {id: 'about'}
      expect(response).to render_template 'layouts/full_width'
    end
  end

  describe 'GET new' do
    before { allow(Page).to receive(:new) }

    it 'assigns a new page as @page' do
      expect(Page).to receive(:new) { page }
      get :new, {}
      expect(assigns(:page)).to eq page
    end

    it 'is restricted' do
      expect(controller).to receive(:superadmin?) { false }
      get :new, {}
      expect(response.status).to eq 302
    end

    it 'uses a full-width layout' do
      get :new, {}
      expect(response).to render_template 'layouts/full_width'
    end
  end

  describe 'GET edit' do
    before { allow(Page).to receive(:find_by_permalink!) }

    it 'assigns the requested page as @page' do
      expect(Page).to receive(:find_by_permalink!).with(page.id) { page }
      get :edit, {id: page.id}
      expect(assigns(:page)).to eq page
    end

    it 'is restricted' do
      expect(controller).to receive(:superadmin?) { false }
      get :edit, {id: page.id}
      expect(response.status).to eq 302
    end

    it 'uses a full-width layout' do
      get :edit, {id: page.id}
      expect(response).to render_template 'layouts/full_width'
    end
  end

  describe 'POST create' do
    let(:attributes) { {name: 'Yoohoo!', permalink: 'yoohoo', content: 'yada yada'} }

    before do
      allow(Page).to receive(:new) { page }
      allow(page).to receive(:save)
    end

    it 'assigns a newly created page to @page' do
      expect(Page).to receive(:new).with(attributes.stringify_keys) { page }
      post :create, {page: attributes}
      expect(assigns(:page)).to eq page
    end

    it 'if created page is valid, it redirects to show it' do
      expect(page).to receive(:save) { true }
      post :create, {page: attributes}
      expect(response).to redirect_to page
      expect(flash[:notice]).to eq 'Page was successfully created.'
    end

    it 'if created page is INVALID, it re-renders the "new" template' do
      expect(page).to receive(:save) { false }
      post :create, {page: attributes}
      expect(response).to render_template 'new'
    end

    it 'is restricted' do
      expect(controller).to receive(:superadmin?) { false }
      post :create, {page: attributes}
      expect(response.status).to eq 302
    end

    it 'uses a full-width layout' do
      post :create, {page: attributes}
      expect(response).to render_template 'layouts/full_width'
    end
  end

  describe 'PUT update' do
    let(:attributes) { {name: 'Yoohoo!', permalink: 'yoohoo', content: 'yada yada'} }

    before do
      allow(Page).to receive(:find_by_permalink!) { page }
      allow(page).to receive(:update_attributes)
    end

    it 'assigns the updated page to @page' do
      expect(Page).to receive(:find_by_permalink!).with(page.id) { page }
      put :update, {id: page.id, page: attributes}
      expect(assigns(:page)).to eq page
    end

    it 'if updated page is valid, it redirects to show it' do
      expect(page).to receive(:update_attributes).with(attributes.stringify_keys) { true }
      put :update, {id: page.id, page: attributes}
      expect(response).to redirect_to page
      expect(flash[:notice]).to eq 'Page was successfully updated.'
    end

    it 'if updated page is INVALID, it re-renders the "edit" template' do
      expect(page).to receive(:update_attributes).with(attributes.stringify_keys) { false }
      put :update, {id: page.id, page: attributes}
      expect(response).to render_template 'edit'
    end

    it 'is restricted' do
      expect(controller).to receive(:superadmin?) { false }
      put :update, {id: page.id, page: attributes}
      expect(response.status).to eq 302
    end

    it 'uses a full-width layout' do
      put :update, {id: page.id, page: attributes}
      expect(response).to render_template 'layouts/full_width'
    end
  end
  
  describe 'DELETE destroy' do
    before do
      allow(Page).to receive(:find_by_permalink!) { page }
      allow(page).to receive(:destroy)
    end

    it 'assigns the page to be destroyed to @page' do
      expect(Page).to receive(:find_by_permalink!).with(page.id) { page }
      delete :destroy, {id: page.id}
      expect(assigns(:page)).to eq page
    end

    it 'destroys the page' do
      expect(page).to receive(:destroy)
      delete :destroy, {id: page.id}
    end

    it 'redirects to the index of pages' do
      delete :destroy, {id: page.id}
      expect(response).to redirect_to pages_path
    end

    it 'is restricted' do
      expect(controller).to receive(:superadmin?) { false }
      delete :destroy, {id: page.id}
      expect(response.status).to eq 302
    end
  end
  describe ".permit" do
    it "returns the cleaned params" do
      pages_params = { page: {content: 'stuff', name: 'this', permalink: 'here', link_visible: false}}
      params = ActionController::Parameters.new.merge(pages_params)
      permitted_params = PagesController::PageParams.build(params)
      expect(permitted_params).to eq(pages_params.with_indifferent_access[:page])
    end
  end
end
